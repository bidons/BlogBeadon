{{ assets.outputCss('blog-css') }}
{{ assets.outputJs('blog-js') }}

<h2 class="center-wrap">Конструкторы
</h2>

<div class="container">
<div class="row">
    <div class="col-md-4">
        <div class="text-center">.
            <img class="rounded-circle" src="/main/img/person_2.jpeg"  width="300" height="250">
        </div>
    </div>
    <div class="entry-content"></div>
    {{ partial('layouts/objdb') }}
</div>
<hr>
    <div class="well">
        <ul>
                <p class="center-wrap">
                   Блок схема таблиц с описанием полей
                <p>
                    <img class ="img-fluid" src="/main/img/paging_object_full_new.png">


                <ol>
                    <li>
                        paging_table - cодержит всебе портянки для быстрой доставки на сторону фронтенда,
                        с возможностью кеширования
                        <pre class="prettyprint lang-json">
[
    {
        "name": "vw_gen_materialize",             -- имя обвёртки
        "descr": "Материализация (сущ.)",         -- описание обвёртки
        "m_query": "SELECT json_agg(*)
                    FROM generate_series(1,100);" -- запрос который должен выполнится при материализации
        "m_column": "id,md5,series,action_date",
        "is_materialize": true,
        "is_paging_full": true,
        "m_prop_column_full": {        -- полная JSON портянка для построения таблицы на стороне фронтенда с фильтрами
            "columns": [{
                    "cd": ["=","!=","<",">","<=",">=","in"], -- доступные логические операторы
                    "data": "id",      -- имя поля
                    "type": "int4",    -- тип поля
                    "title": "id",     -- описание поля
                    "visible": true,   -- видмость поля
                    "is_filter": true, -- является ли поле фильтром
                    "orderable": true  -- доступно оно для сортировки
                }] ....
        },
        "m_prop_column_small": {       -- маленькая портянка для построения таблицы на стороне фронтенда с фильтрами
            "columns": [
                {
                    "data": "id",      -- имя поля
                    "type": "int4",    -- тип поля
                    "title": "id",     -- описание поля
                    "visible": true,   -- видмость поля
                    "is_filter": true, -- является ли поле фильтром
                    "orderable": true  -- доступно поле для сортировки
                },
                ]....
        },
        "paging_table_type_id": 3,                  -- тип
        "last_paging_table_materialize_info_id": 24 -- ссылка на доп данные при материализации
    }
]</pre>
                    </li>
                    <li>paging_table_type - типизация таблиц конструкторов
                         <pre class="prettyprint lang-json">
[
    {
         "name": "view_materialize",          -- физическое имя тип конструктора
         "descr": "Материализованные вьюшки", -- логическое имя тип конструктора
    }....
]
                         </pre>
                    </li>
                    <li>
                        paging_column - колонки и их свойства-опции, в табличном виде для каждого из конструктора
                        <pre class="prettyprint lang-json">
[
     {
         "name": "id",                                 -- физизическое имя поля
         "title": null,                                -- логическое имя поля
         "priority": 1,                                -- расположение в таблицы (порядок)
         "is_filter": true,                            -- является ли поле фильтром
         "is_primary": false,                          -- обязательное ли поле при выполнении и построении запроса
         "is_visible": true,                           -- видимое ли поле (is_primary is false) в к констркторе учавствовать не будет
         "is_orderable": true,                         -- доступно поле для сортировки
         "condition":["=", "!=", "<", ">", "<=", ">="] -- логические операторы для построения условия
         "paging_table_id": 100022 ,                   -- принадлежность в вьюхе
         "paging_column_type_id": 9                    -- тип колонки (явное приведение к типу чтоб не получить SQL иньекцию) при пострении условия
     }....
]
                        </pre>
                    </li>
                    <li>
                        paging_column_type - сдесь у нас тип колонок (доступные тип для построени условия на стороне бд)
                        <pre class="prettyprint lang-json">
[
    {
        "name": "bool",
        "cond_default": ["="]
    },
    {
        "name": "time",
        "cond_default": null
    },
    {
        "name": "jsonb",
        "cond_default": ["->>"]
    },
    {
        "name": "json",
        "cond_default": ["->>"]
    },
    {
        "name": "char",
        "cond_default": ["~~","=","~","!=","in"]
    },
    {
        "name": "varchar",
        "cond_default": ["~~","=","~","!=","in"]
    },
    {
        "name": "text",
        "cond_default": ["~~","=","~","!=","in"]
    },
    {
        "name": "int2",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
    },
    {
        "name": "int4",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
        ]
    },
    {
        "name": "int8",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
    },
    {
        "name": "timestamp",
        "cond_default": ["between","not between","in"]
    },
    {
        "name": "numeric",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
    },
    {
        "name": "float8",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
    },
    {
        "name": "timestamptz",
        "cond_default": ["between","not between","in"]
    },
    {
        "name": "date",
        "cond_default": ["between","not between","in"]
    }
]
                        </pre>
                    </li>
                    <li>
                        paging_table_materialize_info - история материализаций
                        <pre class="prettyprint lang-json">
[
    {
        "m_time": "2018-05-03T15:43:03.084843+03:00", -- время когда была материализация
        "m_count": 200000,                            -- количество строк в представлении
        "m_exec_time": 1.222679,                      -- время выполнения
        "paging_table_id": 100022,                    -- ссылка на материализованую вьюху
        "m_chart_json_data": null                     -- JSON объект для построения визуализации
    }
]
                        </pre>
                    </li>
                </ol>
            </ul>
    </div>

<div class="well">
        <ul>
            <p class="center-wrap">
                Ф-н для работы

            <li>
                    paging_table - cодержит всебе портянки для быстрой доставки на сторону фронтенда,
                    с возможностью кеширования
                    <pre class="prettyprint lang-json">
[
    {
        "name": "vw_gen_materialize",             -- имя обвёртки
        "descr": "Материализация (сущ.)",         -- описание обвёртки
        "m_query": "SELECT json_agg(*)
                    FROM generate_series(1,100);" -- запрос который должен выполнится при материализации
        "m_column": "id,md5,series,action_date",
        "is_materialize": true,
        "is_paging_full": true,
        "m_prop_column_full": {        -- полная JSON портянка для построения таблицы на стороне фронтенда с фильтрами
            "columns": [{
                    "cd": ["=","!=","<",">","<=",">=","in"], -- доступные логические операторы
                    "data": "id",      -- имя поля
                    "type": "int4",    -- тип поля
                    "title": "id",     -- описание поля
                    "visible": true,   -- видмость поля
                    "is_filter": true, -- является ли поле фильтром
                    "orderable": true  -- доступно оно для сортировки
                }] ....
        },
        "m_prop_column_small": {       -- маленькая портянка для построения таблицы на стороне фронтенда с фильтрами
            "columns": [
                {
                    "data": "id",      -- имя поля
                    "type": "int4",    -- тип поля
                    "title": "id",     -- описание поля
                    "visible": true,   -- видмость поля
                    "is_filter": true, -- является ли поле фильтром
                    "orderable": true  -- доступно поле для сортировки
                },
                ]....
        },
        "paging_table_type_id": 3,                  -- тип
        "last_paging_table_materialize_info_id": 24 -- ссылка на доп данные при материализации
    }
]</pre>
                </li>
                <li>paging_table_type - типизация таблиц конструкторов
                    <pre class="prettyprint lang-json">
[
    {
         "name": "view_materialize",          -- физическое имя тип конструктора
         "descr": "Материализованные вьюшки", -- логическое имя тип конструктора
    }....
]
                         </pre>
                </li>
                <li>
                    paging_column - колонки и их свойства-опции, в табличном виде для каждого из конструктора
                    <pre class="prettyprint lang-json">
[
     {
         "name": "id",                                 -- физизическое имя поля
         "title": null,                                -- логическое имя поля
         "priority": 1,                                -- расположение в таблицы (порядок)
         "is_filter": true,                            -- является ли поле фильтром
         "is_primary": false,                          -- обязательное ли поле при выполнении и построении запроса
         "is_visible": true,                           -- видимое ли поле (is_primary is false) в к констркторе учавствовать не будет
         "is_orderable": true,                         -- доступно поле для сортировки
         "condition":["=", "!=", "<", ">", "<=", ">="] -- логические операторы для построения условия
         "paging_table_id": 100022 ,                   -- принадлежность в вьюхе
         "paging_column_type_id": 9                    -- тип колонки (явное приведение к типу чтоб не получить SQL иньекцию) при пострении условия
     }....
]
                        </pre>
                </li>
                <li>
                    paging_column_type - сдесь у нас тип колонок (доступные тип для построени условия на стороне бд)
                    <pre class="prettyprint lang-json">
[
    {
        "name": "bool",
        "cond_default": ["="]
    },
    {
        "name": "time",
        "cond_default": null
    },
    {
        "name": "jsonb",
        "cond_default": ["->>"]
    },
    {
        "name": "json",
        "cond_default": ["->>"]
    },
    {
        "name": "char",
        "cond_default": ["~~","=","~","!=","in"]
    },
    {
        "name": "varchar",
        "cond_default": ["~~","=","~","!=","in"]
    },
    {
        "name": "text",
        "cond_default": ["~~","=","~","!=","in"]
    },
    {
        "name": "int2",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
    },
    {
        "name": "int4",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
        ]
    },
    {
        "name": "int8",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
    },
    {
        "name": "timestamp",
        "cond_default": ["between","not between","in"]
    },
    {
        "name": "numeric",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
    },
    {
        "name": "float8",
        "cond_default": ["=","!=","<",">","<=",">=","in"]
    },
    {
        "name": "timestamptz",
        "cond_default": ["between","not between","in"]
    },
    {
        "name": "date",
        "cond_default": ["between","not between","in"]
    }
]
                        </pre>
                </li>
                <li>
                    paging_table_materialize_info - история материализаций
                    <pre class="prettyprint lang-json">
[
    {
        "m_time": "2018-05-03T15:43:03.084843+03:00", -- время когда была материализация
        "m_count": 200000,                            -- количество строк в представлении
        "m_exec_time": 1.222679,                      -- время выполнения
        "paging_table_id": 100022,                    -- ссылка на материализованую вьюху
        "m_chart_json_data": null                     -- JSON объект для построения визуализации
    }
]
                        </pre>
                </li>
            </ol>
        </ul>
    </div>
</div>
