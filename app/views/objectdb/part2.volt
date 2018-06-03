{{ assets.outputCss('main-css') }}
{{ assets.outputJs('main-css') }}
<script type="text/javascript" src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js?lang=sql"></script>

{{ partial('layouts/objdb') }}

<div class="container">
<div class="well">
    <ul>
        <li>
            <p>Для начала нужно понять как планировщик выполнения запросов PostgreSQL в зависимости от конструкции
                формирует план запроса и выдаёт результат. Уточню, что это общие принципы будь-то обвёртки либо просто запросы.
                Хотя статья по работе с планироващиком штука не очень простая и заслуживает более детального описания,
                пройдёмся по основным механизмам.
            </p>

            <p> Есть таблица client и связана с client_phone, создадим обвёртку
                (не имеет значения это обвёртка или просто запрос с условием) оптимизатор воспринимает
                само тело ф-н , доступ к изменениям недоступен, только "VIEW"
                <pre class="prettyprint lang-sql">
                    CREATE VIEW vw_client AS
                        (
                            SELECT c.id, c.email, cp.main
                            FROM client AS c
                            LEFT JOIN client_phone AS cp ON c.phone_id = cp.id
                        );
                </pre>
            </p>

        <li>Выполняем запрос с лимитированным количеством
           <pre class="prettyprint lang-sql">
                 EXPLAIN ANALYSE
                            SELECT *
                            FROM vw_client LIMIT 10;
           </pre>
<table border="1" style="border-collapse:collapse">
    <pre>-- индекс был использован ровно столько, сколько строк с лимитом</pre>
<tr><th>QUERY PLAN</th></tr>
<tr><td>Limit  (cost=0.42..6.33 rows=10 width=391) (actual time=0.016..0.055 rows=10 loops=1)</td></tr>
<tr><td>  -&gt;  Nested Loop Left Join  (cost=0.42..102433.00 rows=173450 width=391) (actual time=0.015..0.051 rows=10 loops=1)</td></tr>
<tr><td>        -&gt;  Seq Scan on client c  (cost=0.00..6536.50 rows=173450 width=182) (actual time=0.005..0.008 rows=10 loops=1)</td></tr>
<tr><td>        -&gt;  Index Scan using client_phone_pkey on client_phone cp  (cost=0.42..0.54 rows=1 width=209) (actual time=0.002..0.003 rows=1 loops=10)</td></tr>
<tr><td>              Index Cond: (c.phone_id = id)</td></tr>
<tr><td>Planning time: 0.211 ms</td></tr>
<tr><td>Execution time: 0.092 ms</td></tr>
</table>

            <li>Получаем количеством строк
              <pre class="prettyprint lang-sql">
                 EXPLAIN ANALYSE
                            SELECT count(*)
                            FROM vw_client LIMIT 10;
           </pre>
        </li>
            <table border="1" style="border-collapse:collapse">
                <pre> Таблица с джойном была проигнорирована, поскольку само связывание не обязательное</pre>
                <tr><th>QUERY PLAN</th></tr>
                <tr><td>Aggregate  (cost=6970.12..6970.14 rows=1 width=8) (actual time=78.669..78.670 rows=1 loops=1)</td></tr>
                <tr><td>  -&gt;  Seq Scan on client c  (cost=0.00..6536.50 rows=173450 width=0) (actual time=0.007..43.830 rows=173813 loops=1)</td></tr>
                <tr><td>Planning time: 0.085 ms</td></tr>
                <tr><td>Execution time: 78.714 ms</td></tr>
            </table>

        <li>Выполним с условием</li>
        <pre class="prettyprint lang-sql">
                EXPLAIN ANALYSE
                    SELECT *
                        FROM vw_client
                        WHERE email ~'@gmail.com'
                        LIMIT 10;
        </pre>
    <table border="1" style="border-collapse:collapse">
        <pre> опять же джойн был выполнен только для 10 строк</pre>
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

        <li>Cамое интерессное, выгребем с условием но при этом возьмём только одно поле,
         есть определённая связь, обращение к полю и само условие к полю (таблицы) исключают дополнительные сканы и обращения к другим таблицам</li>
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
            Что из этого следует: В не зависимости от количества не обязательных джойнов и обращений,
            планировщик будет терзучить только то множество которое будет в результате,
            а подсчёт строк будет игнорировать связи которых нет в результе если связывание не обязательное (join).
            Приведём несколько примеров.
              <pre class="prettyprint lang-sql">
            -- Плохой запрос (для пагинации, джойн так себе затея, обязательная связанность для множества плохо, плохо только для подсчёта общего количества)
            CREATE VIEW vw_client AS (
            SELECT c.id,cp.tel,cp.id as client_phone_id
            FROM client AS c
            JOIN client_phone AS cp ON c.phone_id  =cp.id
            );

            -- Плохой запрос (агрегат),
            CREATE VIEW vw_client AS (
            SELECT c.id,count(*),first(cp.phone_main)
            FROM client AS c
            JOIN client_phone AS cp ON c.phone_id  =cp.id
            GROUP by c.id
            );

            -- Ничего так запрос (но обращаться к полю region как к условию так и к сортировке плохо)
            CREATE VIEW vw_client AS (
            SELECT ip2location(c.ip).region,с.id
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