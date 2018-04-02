<h2 class="center-wrap">Конструкторы
    (<strong>Пагинаторы</strong>)
</h2>

<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/person_1.jpeg"  width="300" height="250">
        </div>
    </div>
    <div class="entry-content"></div>
    <div class="post-series-content">
        {#<p>This post is first part of a series called #}{#<strong>Getting Started with Datatable 1.10</strong>.</p>#}
        <ol>
            <li><a class="wrapper-blog" href="/objectdb/index" title="Введение (зачем, почему, дерево проекта)" >Введение (зачем, почему, дерево проекта) </a></li>
            <li><a class="wrapper-blog" href="/objectdb/part1" title="Реляционное связывание (таблиц и полей)">Реляционное связывание таблиц и колонок</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part2" title="Особенности работы  (планировщика запросов) PosgreSQL">Особенности работы  (планировщика запросов) PosgreSQL</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part3" title="Работы с фильтрами-условиями (предикативная логика)">Работы с фильтрами-условиями (предикативная логика)</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part4" title="Материализация (Materialize View)" >Материализация (Materialize View)</a></li>
            <li><a class="wrapper-blog" href="/objectdb/part5" title="Исходники">Исходники</a></li>
        </ol>
    </div>
</div>
<hr>

<div class="well">
    <ul>
        <li>
            <p>
                Про материализовные вьюхи много чего написано в нете,
                если простым языком то это механизм преагрегации который материализует
                запрос обвёртку в статическую таблицу.
            </p>
            <li>
                 Возможность индексации
            </li>
            <li>
                 После материализации множество не изменно и актуалено на момент материализации
                (можно не волноватся об MVCC)
            </li>
            <li>
            Материализация позволяет нам писать сложнейшие запросы
            </li>
        </li>
        </ul>
</div>