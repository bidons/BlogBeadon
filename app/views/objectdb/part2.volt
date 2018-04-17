{{ assets.outputCss('blog-css') }}
{{ assets.outputJs('blog-js') }}

<h2 class="center-wrap">Конструкторы
</h2>

<div class="container">
<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/kuas.jpg"  width="300" height="300">
        </div>
    </div>
    <div class="entry-content"></div>
    <div class="post-series-content">
        {#<p>This post is first part of a series called #}{#<strong>Getting Started with Datatable 1.10</strong>.</p>#}
        <ol>
            <li><a class="wrapper-blog" href="/objectdb/index" title="Введение (зачем, почему)" >Введение</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part1" title="Реляционное связывание (таблиц и полей)">Реляционное связывание таблиц и полей</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part2" title="Особенности работы  (планировщика запросов) PosgreSQL">Особенности работы  (планировщика запросов) PosgreSQL</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part3" title="Работы с фильтрами-условиями (предикативная логика)">Работы с фильтрами-условиями (предикативная логика)</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part4" title="Материализация (Materialize View)" >Материализация (Materialize View)</a></li>
        </ol>
    </div>
</div>
<hr>

<div class="well">
    <ul>
        <li>

            <p>Для начала нужно понять как планировщик выполнения запросов PostgreSQL в зависимости от конструкции
                формирует план запроса и выдаёт результат. Уточню, что это общие принципы.
            </p>

            <p> Есть таблица client и связана с client_phone, создадим обвёртку
                <pre class="prettyprint lang-sql">
                    CREATE VIEW vw_client AS
                        (
                            SELECT c.id, c.email, cp.main
                            FROM client AS c
                            LEFT JOIN client_phone AS cp ON c.phone_id = cp.id
                        );
                </pre>
            </p>

        <li>Выполнем с лимитированным количеством, как видно индекс был использован ровно столько строк сколько и лимитом
           <pre class="prettyprint lang-sql">
                 EXPLAIN ANALYSE
                            SELECT *
                            FROM vw_client LIMIT 10;
           </pre>
<table border="1" style="border-collapse:collapse">
<tr><th>QUERY PLAN</th></tr>
<tr><td>Limit  (cost=0.42..6.33 rows=10 width=391) (actual time=0.016..0.055 rows=10 loops=1)</td></tr>
<tr><td>  -&gt;  Nested Loop Left Join  (cost=0.42..102433.00 rows=173450 width=391) (actual time=0.015..0.051 rows=10 loops=1)</td></tr>
<tr><td>        -&gt;  Seq Scan on client c  (cost=0.00..6536.50 rows=173450 width=182) (actual time=0.005..0.008 rows=10 loops=1)</td></tr>
<tr><td>        -&gt;  Index Scan using client_phone_pkey on client_phone cp  (cost=0.42..0.54 rows=1 width=209) (actual time=0.002..0.003 rows=1 loops=10)</td></tr>
<tr><td>              Index Cond: (c.phone_id = id)</td></tr>
<tr><td>Planning time: 0.211 ms</td></tr>
<tr><td>Execution time: 0.092 ms</td></tr>
</table>

            <li>Получаем количеством строк, как видно таблица с джойном была проигнорирована
              <pre class="prettyprint lang-sql">
                 EXPLAIN ANALYSE
                            SELECT count(*)
                            FROM vw_client LIMIT 10;
           </pre>
        </li>
            <table border="1" style="border-collapse:collapse">
                <tr><th>QUERY PLAN</th></tr>
                <tr><td>Aggregate  (cost=6970.12..6970.14 rows=1 width=8) (actual time=78.669..78.670 rows=1 loops=1)</td></tr>
                <tr><td>  -&gt;  Seq Scan on client c  (cost=0.00..6536.50 rows=173450 width=0) (actual time=0.007..43.830 rows=173813 loops=1)</td></tr>
                <tr><td>Planning time: 0.085 ms</td></tr>
                <tr><td>Execution time: 78.714 ms</td></tr>
            </table>

        <li>Выполним с условием (опять же 10-строк с индексом)</li>
        <pre class="prettyprint lang-sql">
                EXPLAIN ANALYSE
                    SELECT *
                        FROM vw_client
                        WHERE email ~'@gmail.com'
                        LIMIT 10;
        </pre>
    <table border="1" style="border-collapse:collapse">
    <tr><th>QUERY PLAN</th></tr>
    <tr><td>Limit  (cost=0.42..8.07 rows=10 width=391) (actual time=0.023..0.113 rows=10 loops=1)</td></tr>
    <tr><td>  -&gt;  Nested Loop Left Join  (cost=0.42..60296.58 rows=78841 width=391) (actual time=0.022..0.107 rows=10 loops=1)</td></tr>
    <tr><td>        -&gt;  Seq Scan on client c  (cost=0.00..6970.12 rows=78841 width=182) (actual time=0.012..0.061 rows=10 loops=1)</td></tr>
    <tr><td>              Filter: (email ~ &#39;@gmail.com&#39;::text)</td></tr>
    <tr><td>              Rows Removed by Filter: 18</td></tr>
    <tr><td>        -&gt;  Index Scan using client_phone_pkey on client_phone cp  (cost=0.42..0.67 rows=1 width=209) (actual time=0.003..0.003 rows=1 loops=10)</td></tr>
    <tr><td>              Index Cond: (c.phone_id = id)</td></tr>
    <tr><td>Planning time: 0.425 ms</td></tr>
    <tr><td>Execution time: 0.157 ms</td></tr>
    </table>

        <li>А теперь самое интерессное выгребем с условием но при этом возьмём только одно поле,
        как видно есть определённая связь, обращение к полю и само условие исключаю дополнительные сканы и обращения</li>
        <pre class="prettyprint lang-sql">
                EXPLAIN ANALYSE
                    SELECT id
                        FROM vw_client
                        WHERE email ~'@gmail.com'
                        LIMIT 10;
        </pre>

        <table border="1" style="border-collapse:collapse">
            <tr><td>Seq Scan on client c  (cost=0.00..10298.30 rows=83931 width=26) (actual time=0.018..287.580 rows=79014 loops=1)</td></tr>
            <tr><td>  Filter: (email ~ &#39;gmail.com&#39;::text)</td></tr>
            <tr><td>  Rows Removed by Filter: 87170</td></tr>
            <tr><td>Planning time: 0.466 ms</td></tr>
            <tr><td>Execution time: 290.095 ms</td></tr>
        </table>






        <li>
            Что из этого следует: В не зависимости от количества джойнов и обращений, планировщик будет терзучить только то множество которое будет в результате, и то множество которое будет в условии или при сортировке

              <pre class="prettyprint lang-sql">
            -- Плохой запрос (для пагинации, джойн так себе затея, обязательная связанность для множества плохо)
            CREATE VIEW vw_client AS (
            SELECT *
            FROM client AS c
            JOIN client_phone AS cp ON c.phone_id  =cp.id
            );

            -- Плохой запрос (агрегат )
            CREATE VIEW vw_client AS (
            SELECT c.id,count(*),first(cp.phone_main)
            FROM client AS c
            JOIN client_phone AS cp ON c.phone_id  =cp.id
            GROUP by c.id
            );

            -- Ничего так запрос (но обращаться к полю region как к условию так и к сортировке плохо)
            CREATE VIEW vw_client AS (
            SELECT ip2location(c.ip).region,*
            FROM client AS c
            left JOIN client_phone AS cp ON c.phone_id  =cp.id
            );

            -- Ничего так (но обращаться к полям из "позднего джойна" как к условию так и к сортировке плохо)
            CREATE VIEW vw_client AS (
            SELECT *
            FROM client AS c
            LEFT JOIN lateral (select * from client_phone as cp where c.id = c.id) as cp on true
            );
           </pre>
        </li>
    </ul>
</div>
</div>