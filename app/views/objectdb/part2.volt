{{ assets.outputCss('blog-css') }}
{{ assets.outputJs('blog-js') }}

<h2 class="center-wrap">Конструкторы
    (<strong>Пагинаторы</strong>)
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
            <li><a class="wrapper-blog" href="/objectdb/index" title="Введение (зачем, почему)" >Введение (зачем, почему, дерево проекта) </a></li>
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

            <p>Для начала нужно понять как оптимизатор-планировщик PostgreSQL в зависимости от конструкции формирует план запроса и выдаёт результат</p>

            <p> И так есть таблица client и связана с client_phone, создадим обвёртку вьюху</p>

            <pre style="margin: 0; line-height: 125%"><span style="color: #008800; font-weight: bold">CREATE</span> <span style="color: #008800; font-weight: bold">VIEW</span> vw_client <span style="color: #008800; font-weight: bold">AS</span> (
    <span style="color: #008800; font-weight: bold">SELECT</span> <span style="color: #333333">*</span>
    <span style="color: #008800; font-weight: bold">FROM</span> client <span style="color: #008800; font-weight: bold">AS</span> c
    <span style="color: #008800; font-weight: bold">LEFT</span> <span style="color: #008800; font-weight: bold">JOIN</span> client_phone <span style="color: #008800; font-weight: bold">AS</span> cp <span style="color: #008800; font-weight: bold">ON</span> c<span style="color: #6600EE; font-weight: bold">.</span>phone_id  <span style="color: #333333">=</span>cp<span style="color: #6600EE; font-weight: bold">.</span>id
    );
    </pre>

        <li>Пнём с лимитом (как видно индекс был заюзан ровно столько строк сколько и лимита)
           <pre>
               <span style="color: #008800; font-weight: bold">EXPLAIN ANALYSE</span>
                    <span style="color: #008800; font-weight: bold">SELECT</span> <span style="color: #333333">*</span> <span style="color: #008800; font-weight: bold">FROM</span> vw_client <span style="color: #008800; font-weight: bold">limit</span> <span style="color: #6600EE; font-weight: bold">10</span>;

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
           </pre>

            <li>Теперь количество (таблица с джойном была проигнорирована)</li>
        <pre>
               <span style="color: #008800; font-weight: bold">EXPLAIN ANALYSE</span>
                    <span style="color: #008800; font-weight: bold">SELECT</span> <span style="color: #333333">*</span> <span style="color: #008800; font-weight: bold">FROM</span> vw_client <span style="color: #008800; font-weight: bold">limit</span> <span style="color: #6600EE; font-weight: bold">10</span>;

            <table border="1" style="border-collapse:collapse">
                <tr><th>QUERY PLAN</th></tr>
                <tr><td>Aggregate  (cost=6970.12..6970.14 rows=1 width=8) (actual time=78.669..78.670 rows=1 loops=1)</td></tr>
                <tr><td>  -&gt;  Seq Scan on client c  (cost=0.00..6536.50 rows=173450 width=0) (actual time=0.007..43.830 rows=173813 loops=1)</td></tr>
                <tr><td>Planning time: 0.085 ms</td></tr>
                <tr><td>Execution time: 78.714 ms</td></tr>
            </table>
        </pre>

        <li>Теперь c условием (опять же 10-строк с индексом)</li>

              <pre style="margin: 0; line-height: 125%">      <span style="color: #008800; font-weight: bold">EXPLAIN</span> <span style="color: #008800; font-weight: bold">ANALYSE</span>
      <span style="color: #008800; font-weight: bold">SELECT</span> <span style="color: #333333">*</span>
      <span style="color: #008800; font-weight: bold">FROM</span> vw_client
      <span style="color: #008800; font-weight: bold">WHERE</span> email <span style="color: #333333">~</span><span style="background-color: #fff0f0">&#39;@gmail.com&#39;</span>
      <span style="color: #008800; font-weight: bold">LIMIT</span> <span style="color: #6600EE; font-weight: bold">10</span>;

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
        </pre>
        <li>
            Что из этого следует: В не зависимости от количества джойнов и обращений, планировщик будет терзучить только то множество которое будет в результате, и то множество которое будет в условии или при сортировке

            <pre style="margin: 0; line-height: 125%">  <span style="color: #888888">-- Плохой запрос (для пагинации, джойн так себе затея)</span>
            <span style="color: #008800; font-weight: bold">CREATE</span> <span style="color: #008800; font-weight: bold">VIEW</span> vw_client <span style="color: #008800; font-weight: bold">AS</span> (
            <span style="color: #008800; font-weight: bold">SELECT</span> <span style="color: #333333">*</span>
            <span style="color: #008800; font-weight: bold">FROM</span> client <span style="color: #008800; font-weight: bold">AS</span> c
            <span style="color: #008800; font-weight: bold">JOIN</span> client_phone <span style="color: #008800; font-weight: bold">AS</span> cp <span style="color: #008800; font-weight: bold">ON</span> c<span style="color: #6600EE; font-weight: bold">.</span>phone_id  <span style="color: #333333">=</span>cp<span style="color: #6600EE; font-weight: bold">.</span>id
            );
            </pre>

            <pre style="margin: 0; line-height: 125%"> <span style="color: #888888">-- Плохой запрос (агрегат )</span>
            <span style="color: #008800; font-weight: bold">CREATE</span> <span style="color: #008800; font-weight: bold">VIEW</span> vw_client <span style="color: #008800; font-weight: bold">AS</span> (
            <span style="color: #008800; font-weight: bold">SELECT</span> c<span style="color: #6600EE; font-weight: bold">.</span>id,count(<span style="color: #333333">*</span>),<span style="color: #008800; font-weight: bold">first</span>(cp<span style="color: #6600EE; font-weight: bold">.</span>phone_main)
            <span style="color: #008800; font-weight: bold">FROM</span> client <span style="color: #008800; font-weight: bold">AS</span> c
            <span style="color: #008800; font-weight: bold">JOIN</span> client_phone <span style="color: #008800; font-weight: bold">AS</span> cp <span style="color: #008800; font-weight: bold">ON</span> c<span style="color: #6600EE; font-weight: bold">.</span>phone_id  <span style="color: #333333">=</span>cp<span style="color: #6600EE; font-weight: bold">.</span>id
            <span style="color: #008800; font-weight: bold">GROUP</span> <span style="color: #008800; font-weight: bold">by</span> c<span style="color: #6600EE; font-weight: bold">.</span>id
            );
            </pre>

            <pre style="margin: 0; line-height: 125%"><span style="color: #888888">-- Ничего так запрос (но обращаться к полю region как к условию так и к сортировке плохо)</span>
            <span style="color: #008800; font-weight: bold">CREATE</span> <span style="color: #008800; font-weight: bold">VIEW</span> vw_client <span style="color: #008800; font-weight: bold">AS</span> (
            <span style="color: #008800; font-weight: bold">SELECT</span> ip2location(c<span style="color: #6600EE; font-weight: bold">.</span>ip)<span style="color: #6600EE; font-weight: bold">.</span>region,<span style="color: #333333">*</span>
            <span style="color: #008800; font-weight: bold">FROM</span> client <span style="color: #008800; font-weight: bold">AS</span> c
            <span style="color: #008800; font-weight: bold">left</span> <span style="color: #008800; font-weight: bold">JOIN</span> client_phone <span style="color: #008800; font-weight: bold">AS</span> cp <span style="color: #008800; font-weight: bold">ON</span> c<span style="color: #6600EE; font-weight: bold">.</span>phone_id  <span style="color: #333333">=</span>cp<span style="color: #6600EE; font-weight: bold">.</span>id
            );
            </pre>

            <pre style="margin: 0; line-height: 125%">   <span style="color: #888888">-- Ничего так (но обращаться к полям из &quot;позднего джойна&quot; как к условию так и к сортировке плохо)</span>
            <span style="color: #008800; font-weight: bold">CREATE</span> <span style="color: #008800; font-weight: bold">VIEW</span> vw_client <span style="color: #008800; font-weight: bold">AS</span> (
            <span style="color: #008800; font-weight: bold">SELECT</span> <span style="color: #333333">*</span>
            <span style="color: #008800; font-weight: bold">FROM</span> client <span style="color: #008800; font-weight: bold">AS</span> c
            <span style="color: #008800; font-weight: bold">LEFT</span> <span style="color: #008800; font-weight: bold">JOIN</span> lateral (<span style="color: #008800; font-weight: bold">select</span> <span style="color: #333333">*</span> <span style="color: #008800; font-weight: bold">from</span> client_phone <span style="color: #008800; font-weight: bold">as</span> cp <span style="color: #008800; font-weight: bold">where</span> c<span style="color: #6600EE; font-weight: bold">.</span>id <span style="color: #333333">=</span> c<span style="color: #6600EE; font-weight: bold">.</span>id) <span style="color: #008800; font-weight: bold">as</span> cp <span style="color: #008800; font-weight: bold">on</span> <span style="color: #008800; font-weight: bold">true</span>
            );
            </pre>

            {#Но собственно все правила можно отбросить если использовать материализацию#}
        </li>

    </ul>
</div>