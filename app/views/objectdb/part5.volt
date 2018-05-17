{{ assets.outputCss('main-css') }}
{{ assets.outputJs('main-css') }}
<script type="text/javascript" src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js?lang=sql"></script>

{{ partial('layouts/objdb') }}

<div class="container">
    <div class="well">
        <ul>
                <p class="center-wrap">
                   Блок схема таблиц с описанием полей
                <p>
                    <img class ="img-fluid" src="/main/img/paging_object_full_new.png">
                <ol>
                    <li>
                        paging_table - cодержит в себе портянки для быстрой доставки данных для рендеринга на сторону фронтенда
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
                    "visible": true,   -- видимость поля
                    "is_filter": true, -- является поле фильтром
                    "orderable": true  -- доступно поле для сортировки
                },
                ]....
        },
        "paging_table_type_id": 3,                  -- тип
        "last_paging_table_materialize_info_id": 24 -- ссылка на ифн. о материализации
    }
]</pre>
                    </li>
                    <li>paging_table_type - типизация таблиц конструкторов
                         <pre class="prettyprint lang-json">
[
    {
         "name": "view_materialize",          -- физическое имя (тип конструктора)
         "descr": "Материализованные вьюшки", -- логическое имя (тип конструктора)
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
                        paging_table_materialize_info - история материализаций
                        <pre class="prettyprint lang-json">
[
    {
        "m_time": "2018-05-03T15:43:03.084843+03:00", -- время когда была материализация
        "m_count": 200000,                            -- количество строк в представлении
        "m_exec_time": 1.222679,                      -- время выполнения
        "paging_table_id": 100022,                    -- ссылка на материализованную вьюху
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
         "paging_column_type_id": 9                    -- тип колонки
     }....
]
                        </pre>
                </li>
                <li>
                    paging_column_type - типы колонок и доступные предикаты (доступные тип для построени условия на стороне бд)
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
        "paging_table_id": 100022,                    -- ссылка на материализованную вьюху
        "m_chart_json_data": null                     -- JSON объект для построения визуализации
    }
]
                    </pre>
                </li>
            </ol>
        </ul>
    </div>
    <li>
        Вспомогательные ф-н
        <pre class="prettyprint lang-sql">

-- Вспомогательная ф-н для проверки типа
CREATE OR REPLACE FUNCTION str2integer(a TEXT)
  RETURNS INTEGER
IMMUTABLE
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN a :: INTEGER;
  EXCEPTION WHEN OTHERS
  THEN
    RETURN NULL;
END;
$$;

-- Вспомогательная ф-н для генерации исключения или записи в лог
CREATE OR REPLACE FUNCTION message_ex(a_flag BOOLEAN, a_message TEXT, type INTEGER)
  RETURNS BOOLEAN
IMMUTABLE
LANGUAGE plpgsql
AS $$
BEGIN
  IF (a_flag AND type = 1)
  THEN
    RAISE NOTICE '%', a_message;
  ELSEIF (a_flag AND type = -1)
    THEN
      RAISE EXCEPTION '%', a_message;
  END IF;
  RETURN TRUE;
END;
$$;

        </pre>

        Функция доступа, создание запроса, на выходе ответ в JSON-оно подобно виде:
        <pre class="prettyprint lang-sql">
CREATE OR REPLACE FUNCTION paging_objectdb(a_js JSONB)
  RETURNS SETOF JSONB
LANGUAGE plpgsql
AS $$
DECLARE

  --- Хватаю время (для дебагинга)
  val_timestart            TIMESTAMP = clock_timestamp();

  -- Таблица обвёртка
  val_table                TEXT;

  -- Сортировки множественные можно и с условием([{"column": "sorted_field = 5","dir": "asc"}]
  val_order                TEXT = (SELECT 'ORDER BY ' || string_agg((r ->> 'column') || ' ' || (r ->> 'dir'), ',')
                                   FROM (
                                          SELECT jsonb_array_elements(a_js -> 'order') AS r
                                        ) AS r);
  -- Смешение
  val_offlim               TEXT = ' LIMIT ' || COALESCE($1 ->> 'length', '0') || ' OFFSET ' ||
                                  COALESCE($1 ->> 'start', '0');
  -- Собираем условие
  val_condition            TEXT;

  -- Запрос для выпоонения (смещение)
  val_query                TEXT;

  -- Результат (результат выполнения ф-н)
  val_result               JSONB = '{}';

  -- Результат запроса (смещение)
  val_query_result_jsonb   JSONB = '{}';

  -- Результат запроса (количество, либо количество с фильтрами)
  val_query_result_integer INTEGER;

  -- Иноформация для дебага
  val_debug                JSONB = '[]';

  -- Флаг материализации
  val_mat_mode             BOOLEAN;

  -- Общее количество (если посчитано)
  val_m_count_total        INTEGER;

  -- Колончки доступные для получения лимитированного количества
  val_m_columns            TEXT;

  -- Создание условия
  val_condition_arg        JSONB = a_js -> 'columns';

  -- Флаг нужно ли считать (количество и количество с фильтрам)
  val_paging               BOOLEAN;
BEGIN

  SELECT
    p.m_column,
    ptm.m_count,
    is_materialize,
    p.name,
    is_paging_full
  FROM paging_table AS p
    LEFT JOIN paging_table_materialize_info AS ptm ON ptm.id = p.last_paging_table_materialize_info_id
  WHERE p.name = $1 ->> 'objdb'
  INTO val_m_columns, val_m_count_total, val_mat_mode, val_table, val_paging;

  -- Собираем условие
  IF (val_condition_arg IS NOT NULL)
  THEN
    WITH getcolumns AS
    (
        SELECT jsonb_array_elements(val_condition_arg) AS r
    ), normalize AS
    (
        SELECT
          r ->> 'col' AS f_data,
          r ->> 'fc'  AS f_cd,
          r ->> 'fv'  AS f_value,
          r ->> 'ft'  AS f_type
        FROM getcolumns AS t
    )
    SELECT ' WHERE ' || string_agg(CASE WHEN (f_type ~ 'timestamp|date')
      THEN concat_ws(' ',
                     f_data,
                     f_cd,
                     quote_literal(split_part(f_value, ' - ', 1)),
                     'AND',
                     quote_literal(split_part(f_value, ' - ', 2)))
                                   --- Важный момент, чтоб исключить SQL иньекцию, проверяю соответствет ли тип числу во всех остальных случаях это текст
                                   WHEN (f_cd = 'in' AND f_type ~ 'int|numeric|float|decimal' AND
                                         str2integer(f_value) IS NOT NULL)
                                     THEN concat_ws(' ',
                                                    f_data,
                                                    f_cd,
                                                    '(' || f_value) || ')'
                                   WHEN (f_cd = 'in')
                                     THEN concat_ws(' ',
                                                    f_data,
                                                    f_cd,
                                                    '(' || (SELECT string_agg(quote_literal(r), ',')
                                                            FROM regexp_split_to_table(f_value, ',') AS r)) || ')'
                                   ELSE concat_ws(' ',
                                                  f_data,
                                                  f_cd,
                                                  quote_literal(f_value)) END, ' AND ')
    FROM normalize AS n
    INTO val_condition;
  END IF;

  -- Если объект материализованн изменяю условия для доступа к материализованной сущности
  val_table = CASE WHEN val_mat_mode
    THEN replace(val_table, 'vw', 'mv')
              ELSE val_table END;

  -- Конкатенация запроса для получения лимированного количества
  SELECT concat_ws(' ', 'WITH objdb AS (',
                   'SELECT', val_m_columns,
                   'FROM', val_table,
                   val_condition, val_order, val_offlim
  , ')', 'SELECT ', 'json_agg(row_to_json(objdb)) FROM objdb')
  INTO val_query;

  EXECUTE val_query
  INTO val_query_result_jsonb;

  -- Дебажик
  val_debug = val_debug || jsonb_build_array(jsonb_build_object('data', val_query, 'time', round(
      (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));

  -- Собираю условие для вывовда результата
  val_result = val_result || jsonb_build_object('data', coalesce(val_query_result_jsonb, '[]'));

  val_timestart = clock_timestamp();

  -- Исключения дополнительных вызовов (общего количества и просто количества если данные есть)
  IF (val_mat_mode IS TRUE
      AND val_condition IS NULL
      AND val_m_count_total IS NOT NULL)
  THEN
    val_query = concat_ws(' ', 'SELECT count(*)', 'FROM', val_table);

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', NULL, 'time', NULL));
    val_result = val_result || jsonb_build_object('recordsFiltered', val_m_count_total);

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', NULL, 'time', NULL));
    val_result = val_result || jsonb_build_object('recordsTotal', val_m_count_total);

    -- Если условие пришло но есть общее количество
  ELSEIF (val_condition IS NOT NULL
          AND val_m_count_total IS NOT NULL)
    THEN
      val_query = concat_ws(' ', 'SELECT count(*)', 'FROM', val_table, val_condition);

      EXECUTE val_query
      INTO val_query_result_integer;

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', val_query, 'time', round(
          (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
      val_result = val_result || jsonb_build_object('recordsFiltered', val_query_result_integer);

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', NULL, 'time', NULL));
      val_result = val_result || jsonb_build_object('recordsTotal', val_m_count_total);

      -- Если условие пустое (то заменяю общее количество для количества с условием)
  ELSEIF (val_condition IS NULL)
    THEN

      val_query = concat_ws(' ', 'SELECT count(*)', 'FROM', val_table);

      val_timestart = clock_timestamp();

      EXECUTE val_query
      INTO val_query_result_integer;

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', NULL, 'time', NULL));
      val_result = val_result || jsonb_build_object('recordsFiltered', val_query_result_integer);

      val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', val_query, 'time', round(
          (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
      val_result = val_result || jsonb_build_object('recordsTotal', val_query_result_integer);

      -- Все остальные варианты когда нужно получить и количество и количество с условием
  ELSE
    val_query = concat_ws(' ', 'SELECT count(*)', 'FROM', val_table, val_condition);

    EXECUTE val_query
    INTO val_query_result_integer;

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsFiltered', val_query, 'time', round(
        (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_result = val_result || jsonb_build_object('recordsFiltered', val_query_result_integer);

    val_query = concat_ws(' ', 'SELECT COUNT(*)', 'FROM', val_table);

    val_timestart = clock_timestamp();

    EXECUTE val_query
    INTO val_query_result_integer;

    val_debug = val_debug || jsonb_build_array(jsonb_build_object('recordsTotal', val_query, 'time', round(
        (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_timestart)) :: NUMERIC, 4)));
    val_result = val_result || jsonb_build_object('recordsTotal', val_query_result_integer);
  END IF;

  --- Возвращаю результат
  RETURN QUERY
  SELECT val_result || jsonb_build_object('debug', val_debug);

END;
$$;
        </pre>
    </li>

    <li>
        Ф-н и триггер для материлизации полей insert or update paging_column, создание полей в слабоструктурированно виде JSON,TEXT в таблицу (paging_table)
        <pre class="prettyprint lang-sql">

CREATE OR REPLACE FUNCTION materialize_paging_column(INTEGER)
  RETURNS VOID
LANGUAGE SQL
AS $$
-- Материализация свойств и опций полей для быстрого доступа
UPDATE paging_table
SET m_prop_column_full = full_data, -- свойства полей (с условиям)
  m_prop_column_small  = small_data, -- свойства полей (без условий)
  m_column             = cols -- поля для конкатеннации запроса поля для "select" (paging_table)
FROM (SELECT
        jsonb_build_object('columns',
                           jsonb_agg(jsonb_build_object(
                                         'data', p.name
                                         'visible', coalesce(p.is_visible, FALSE),
                                         'primary', coalesce(is_primary, FALSE),
                                         'title', coalesce(p.title, p.name),
                                         'orderable', Coalesce(p.is_orderable, TRUE),
                                         'is_filter', p.is_filter,
                                         'type', pt.name,
                                         'cd', coalesce(p.condition, pt.cond_default),
                                         'cdi', p.item_condition)
                           ORDER BY p.priority)) AS full_data,
        jsonb_build_object('columns',
                           jsonb_agg(jsonb_build_object(
                                         'data', p.name,
                                         'visible', coalesce(p.is_visible, FALSE),
                                         'primary', coalesce(is_primary, FALSE),
                                         'orderable', Coalesce(p.is_orderable, TRUE),
                                         'title', coalesce(p.title, p.name),
                                         'type', pt.name)
                           ORDER BY priority))   AS small_data,
        string_agg(p.name, ','
        ORDER BY priority)                       AS cols,
        p.paging_table_id
      FROM paging_column AS p
        LEFT JOIN paging_column_type AS pt ON p.paging_column_type_id = pt.id
      WHERE p.paging_table_id = $1
            AND p.is_visible IS TRUE OR p.is_primary IS TRUE
      GROUP BY p.paging_table_id) AS rs
WHERE rs.paging_table_id = paging_table.id;
$$;

-- Функция для триггера
CREATE OR REPLACE FUNCTION paging_column_before_update_insert_trg()
  RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM materialize_paging_column(new.paging_table_id);
  RETURN NEW;
END;
$$;

        </pre>
    </li>
    <li>
        Функция материализации
        <pre class="prettyprint lang-sql">
CREATE OR REPLACE FUNCTION materialize_worker(a_mode TEXT, a_object TEXT, a_person_owner INTEGER)
  RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE

  -- Количество строк после материализации
  val_m_count         INTEGER;

  -- Время когда производилась материализация
  val_m_time          TIMESTAMPTZ;

  -- Время потраченое в мин.(0.0000) материализации
  val_exec_time       NUMERIC;

  -- Посчитаное количество
  val_count_object    INTEGER;

  -- Фиксируем метку времени чтоб следить за потраченым временем на разных этапах
  val_time_exec       TIMESTAMP = clock_timestamp();

  -- Запрос для выполнения
  val_chart_query     TEXT;

  -- Результат (JSON) для визуализации
  val_result          JSON;

  -- Ссылка на айдиху сущности
  val_paging_table_id INTEGER;

  -- Является ли обвёртка материализованной
  val_is_mat          BOOLEAN;

  -- Айдиха текущего перестроения
  val_id_mat_history  INTEGER;

BEGIN
  -- Получаем основные свойства
  SELECT
    id,
    is_materialize,
    m_query
  FROM paging_table
  WHERE name = a_object
  INTO val_paging_table_id, val_is_mat, val_chart_query;

  -- Генерируем ошибку если обвёртка не является материализованной
  PERFORM message_ex(val_is_mat IS FALSE or val_id_mat_history is null, 'Materialize view not found: "' || a_object || '"', -1);

  -- Режим перестроения
  IF (a_mode = 'recreate')
  THEN

    -- Создаём пустышку для последующей материализации (при ресторе или беками таблица будет без строк)
    EXECUTE 'CREATE MATERIALIZED view if not exists ' || replace(a_object, 'vw_', 'mv_') || ' AS
                (
                  SELECT *
                  FROM ' || a_object || ') WITH NO DATA ;';

    -- Обновляем представление
    EXECUTE 'REFRESH MATERIALIZED VIEW  ' || replace(a_object, 'vw_', 'mv_');

    -- Если есть запрос выполняем в поле выполняем (только для JSON результата)
    IF (val_chart_query IS NOT NULL)
    THEN
      EXECUTE val_chart_query
      INTO val_result;
    END IF;

    --- Считаем общее количество
    EXECUTE 'SELECT COUNT(*) FROM ' || replace(a_object, 'vw_', 'mv_')
    INTO val_count_object;

    -- Записываем информацию о состоянии и свойствах материализации
    INSERT INTO paging_table_materialize_info (paging_table_id, m_exec_time, m_time, m_count, m_chart_json_data, init_obj_id)
      SELECT
        val_paging_table_id,
        /*date_part('epoch' :: TEXT, clock_timestamp() - val_time_exec) :: DOUBLE PRECISION,*/
        extract('epoch' FROM clock_timestamp() :: TIME - val_time_exec :: TIME) :: DOUBLE PRECISION,
        now(),
        val_count_object,
        val_result,
        a_person_owner
    RETURNING m_time, m_exec_time, m_count, id
      INTO val_m_time, val_exec_time, val_m_count, val_id_mat_history;

    -- Кидаем ссылочку на таблицу чтоб быстрее стучатся к объекту
    UPDATE paging_table
    SET last_paging_table_materialize_info_id = val_id_mat_history
    WHERE id = val_paging_table_id;
  ELSE

    -- Если режим не перестроение то возвращаю информативные данные (для удобства, одна ф-н get_set)
    SELECT
      m_time,
      m_exec_time,
      m_count,
      m_chart_json_data
    FROM paging_table AS p
     LEFT JOIN paging_table_materialize_info AS pt ON p.last_paging_table_materialize_info_id = pt.id
    WHERE p.id = val_paging_table_id
    INTO val_m_time, val_exec_time, val_m_count, val_result;

  END IF;

  RETURN json_build_object('m_time', val_m_time, 'm_exec_time', val_exec_time, 'm_count', val_m_count, 'm_view',
                           a_object, 'chart_data', val_result);
END;
$$;

        </pre>
    </li>
    <li> Функция для поиска при работе с (select2, полнотекстовый поиск или нет)
    <pre class="prettyprint lang-sql">
CREATE FUNCTION paging_object_db_srch(JSON)
  RETURNS JSON
IMMUTABLE
LANGUAGE plpgsql
AS $$
DECLARE
  -- условие предиката
  srch           TEXT = $1 ->> 'term';
  -- конструктор вьюха
  objdb          TEXT = $1 ->> 'objdb';

  -- поле поиска
  col            TEXT = $1 ->> 'col';
  -- тип поля
  col_type       TEXT = $1 ->> 'type';

  -- результат
  rs             JSON;

  -- привожу условие поиска к нижнему регистру
  searchingField TEXT = ' lower(' || col || ')';

  -- запрос для выполнения
  val_query      TEXT;

  -- время выполнения
  val_time_exec  TIMESTAMP = clock_timestamp();
BEGIN

  -- проверяю существует ли объект для поиска
  IF exists(SELECT TRUE
            FROM paging_table
            WHERE name = objdb)
  THEN
     -- создание условия для текстовых типов
    IF (col_type ~ 'text|char')
    THEN
      val_query = concat('select json_agg(', col, ')'
      , ' from (select ', col, ' from ', objdb, ' where ', searchingField,
                         'like ', quote_literal('%' || lower(srch) || '%'), ' limit 10) as r;');

      EXECUTE val_query
      INTO rs;


    -- создание условие для числовых типов
    ELSEIF (col_type ~ 'int|numeric|decimal|float' AND str2integer(srch) IS NOT NULL)
      THEN

        val_query = concat('select json_agg(', col, ')'
        , ' from (select ', col, ' from ', objdb, ' where ', col, '=', srch, ' limit 10) as r;');

        EXECUTE val_query
        INTO rs;
    END IF;
  END IF;

        -- результат
  RETURN json_build_object('rs', rs, 'query', val_query, 'time', round(
      (EXTRACT(SECOND FROM clock_timestamp()) - EXTRACT(SECOND FROM val_time_exec)) :: NUMERIC, 4));
END;
$$;
        </pre>
    </li>

    <li> Функция для построения обвёртки с использованием пространства имён (PostgreSQL)
        <pre class="prettyprint lang-sql">
CREATE OR REPLACE FUNCTION rebuild_paging_prop(a_vw_view TEXT, a_descr TEXT, a_type_name TEXT, a_is_mat BOOLEAN)
  RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
  -- Получение названия (если обвёртка существует)
  val_object_table_id INTEGER = (SELECT id
                                 FROM paging_table
                                 WHERE name = a_vw_view);
BEGIN

  -- использовуем временную таблицу (операция для построения не сложная задача, можно обойтись temp)
  DROP TABLE IF EXISTS temp_paging_col_prop;

  -- Запихиваем по условию объекты во временную область (просто таблицы либо обврётки)
  CREATE TEMP TABLE temp_paging_col_prop AS
    (
      SELECT
        pv.viewname     AS tablename,   -- объект вьюха
        isc.column_name AS col,         -- физическое имя поля
        t.typname       AS col_type,    -- имя тип поля
        pgi.id          AS col_type_id, -- айди типа поля
        p.attnum        AS pr           -- порядок вывода
      FROM pg_views AS pv
        JOIN information_schema.columns AS isc ON pv.viewname = isc.table_name
        JOIN pg_attribute AS p ON p.attrelid = isc.table_name :: REGCLASS AND isc.column_name = p.attname
        JOIN pg_type AS t ON p.atttypid = t.oid
        LEFT JOIN paging_column_type AS pgi ON pgi.name = t.typname
      WHERE schemaname = 'public' AND pv.viewname = a_vw_view
      UNION ALL
      SELECT
        pv.tablename    AS tablename,   -- объект вьюха
        isc.column_name AS col,         -- физическое имя поля
        t.typname       AS col_type,    -- имя тип поля
        pgi.id          AS col_type_id, -- айди типа поля
        p.attnum        AS pr           -- порядок вывода
      FROM pg_tables AS pv
        JOIN information_schema.columns AS isc ON pv.tablename = isc.table_name
        JOIN pg_attribute AS p ON p.attrelid = isc.table_name :: REGCLASS AND isc.column_name = p.attname
        JOIN pg_type AS t ON p.atttypid = t.oid
        LEFT JOIN paging_column_type AS pgi ON pgi.name = t.typname
      WHERE pv.schemaname = 'public' AND pv.tablename = a_vw_view
    );

  -- Удалаяем объект "paging_table" если таков существует в таблице , но его нет в paging_table
  DELETE FROM paging_table
  WHERE id = val_object_table_id
        AND NOT exists(SELECT 1
                       FROM temp_paging_col_prop
                       LIMIT 1)
  RETURNING id
    INTO val_object_table_id;

  -- Добавляю объект в таблицу если тип пришёл то типизирую, если материализованная то ставлю флаг
  INSERT INTO paging_table (name, descr, paging_table_type_id, is_materialize)
    SELECT
      (SELECT tablename
       FROM temp_paging_col_prop
       LIMIT 1),
      a_descr,
      Coalesce((
                 SELECT name
                 FROM paging_table_type AS p
                 WHERE p.name = a_type_name), 1),
      coalesce(a_is_mat, FALSE)
  RETURNING id
  INTO val_object_table_id;

  -- Если поля у обвёртки изменились то изменяю их в таблицы полей, свойст и опций
  UPDATE paging_column
  SET paging_column_type_id = r.col_type_id, priority = coalesce(priority, r.pr)
  FROM (SELECT
          pcp.id,
          t.col_type_id,
          t.pr
        FROM temp_paging_col_prop AS t
          JOIN paging_column AS pcp ON pcp.name = t.col
        WHERE pcp.paging_table_id = val_object_table_id
       ) AS r
  WHERE r.id = paging_column.id;

  -- Если полей стало больше то просто добавим их (проигнорим уникальность, для существующих)
  INSERT INTO paging_column (paging_table_id, paging_column_type_id, name, priority)
    SELECT
      val_object_table_id,
      col_type_id,
      col,
      pr
    FROM temp_paging_col_prop
  ON CONFLICT (paging_table_id, name)
    DO NOTHING;

  -- Удалим все поля которые существуют в таблице но не существуют в пространстве имён PostgreSQL
  DELETE FROM paging_column
  WHERE paging_column_type_id = val_object_table_id
        AND name NOT IN (SELECT col
                         FROM temp_paging_col_prop);

  -- Материиализуем поля для быстрого доступа (paging_table)
  PERFORM materialize_paging_column((SELECT id
                                     FROM paging_table
                                     WHERE name = a_vw_view));
  RETURN '';
END;
$$;
        </pre>
    </li>
</div>
