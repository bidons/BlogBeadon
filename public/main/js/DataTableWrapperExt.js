
nodeObjects = [{"id":3,"parent":"#","text":"Материализованные вьюшки (200000)","view_name":"view_materialize","col":null,"icon":"unknown","view":null},
    {"id":4,"parent":"#","text":"Обвёртки (полезные запросы) (472)","view_name":"view_useful","col":null,"icon":"unknown","view":null},
    {"id":1,"parent":"#","text":"Части речи (51235)","view_name":"part_of_speech","col":null,"icon":"unknown","view":null},
    {"id":2,"parent":"#","text":"Лексемы-Триграммы (2000000)","view_name":"full_text_search","col":null,"icon":"unknown","view":null},
    {"id":5,"parent":"#","text":"Таблицы","view_name":"table","col":null,"icon":"unknown","view":null},
    {"id":100022,"parent":"3","text":"Материализация (сущ.) (200000)","view_name":"vw_gen_materialize","col":{"columns": [{"cd": ["=", "!=", "<", ">", "<=", ">=", "in"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["=", "~", "!=", "in"], "cdi": null, "data": "md5", "type": "text", "title": "md5", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["=", "~", "!=", "in"], "cdi": null, "data": "series", "type": "text", "title": "series", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["between", "not between", "in"], "cdi": null, "data": "action_date", "type": "timestamptz", "title": "action_date", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" WITH cte AS (\n         SELECT generate_series(1, 200000) AS id,\n            md5((random())::text) AS md5,\n            ('{Дятел,Братство,Духовность,Мебель,Любовник,Аристократ,Ковер,Портос,Трещина,Зубки,Бес,Лень,Благоговенье}'::text[])[(random() * (12)::double precision)] AS series,\n            date((((('now'::text)::date - '2 years'::interval) + (trunc((random() * (365)::double precision)) * '1 day'::interval)) + (trunc((random() * (1)::double precision)) * '1 year'::interval))) AS action_date\n        )\n SELECT cte.id,\n    cte.md5,\n    cte.series,\n    (cte.action_date)::timestamp with time zone AS action_date\n   FROM cte\n  ORDER BY ((cte.action_date)::timestamp with time zone);"},
    {"id":100010,"parent":"1","text":"Наречие (1865)","view_name":"vw_adverb","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 21);"},
    {"id":100009,"parent":"1","text":"Союз (75)","view_name":"vw_conjunction","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 20);"},
    {"id":100008,"parent":"1","text":"Безлич. глагол (73)","view_name":"vw_impersonal_verb","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 16);"},
    {"id":100004,"parent":"1","text":"Прилагательные (2281)","view_name":"vw_infinitive","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 12);"},
    {"id":100011,"parent":"1","text":"Вводное (66)","view_name":"vw_introductory","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 24);"},
    {"id":100002,"parent":"1","text":"Cуществительные (8385)","view_name":"vw_noun","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 7);"},
    {"id":100006,"parent":"1","text":"Деепричастие (1093)","view_name":"vw_participle","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 14);"},
    {"id":100015,"parent":"4","text":"Активность запросов (2)","view_name":"vw_pg_stat_activity","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "pid", "type": "int4", "title": "pid", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "live_status", "type": "text", "title": "live_status", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "state", "type": "text", "title": "state", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "query", "type": "text", "title": "query", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["between", "not between", "in"], "cdi": null, "data": "query_start", "type": "timestamptz", "title": "query_start", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT pg_stat_activity.pid,\n    (justify_interval((now() - pg_stat_activity.query_start)))::text AS live_status,\n    pg_stat_activity.state,\n    pg_stat_activity.query,\n    pg_stat_activity.usename,\n    pg_stat_activity.query_start\n   FROM pg_stat_activity\n  ORDER BY pg_stat_activity.query_start, (pg_stat_activity.state = 'active'::text) DESC;"},
    {"id":100007,"parent":"1","text":"Предлог (126)","view_name":"vw_pretext","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 15);"},
    {"id":100003,"parent":"1","text":"Местоимение (21)","view_name":"vw_pronoun","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 8);"},
    {"id":100001,"parent":"1","text":"Лексемы (12403)","view_name":"vw_rep_multilexem","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "txt", "type": "varchar", "title": "txt", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "headword", "type": "varchar", "title": "headword", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "n_lexem", "type": "int4", "title": "n_lexem", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT multilexem.id,\n    multilexem.txt,\n    multilexem.headword,\n    multilexem.n_lexem\n   FROM multilexem;"},
    {"id":100000,"parent":"1","text":"Омонимы (1429)","view_name":"vw_rep_omonym","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "entry_name", "type": "varchar", "title": "entry_name", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT omonym.id,\n    omonym.entry_name\n   FROM omonym;"},
    {"id":100012,"parent":"4","text":"Размеры объектов в бд. (66)","view_name":"vw_rep_sys_size_ddl","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "table_name", "type": "text", "title": "table_name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "row_estimate", "type": "text", "title": "row_estimate", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "total_size", "type": "text", "title": "total_size", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "index_size", "type": "text", "title": "index_size", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "toast_size", "type": "text", "title": "toast_size", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "table_size", "type": "text", "title": "table_size", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT (a.table_name)::text AS table_name,\n    (a.row_estimate)::text AS row_estimate,\n    pg_size_pretty(a.total_bytes) AS total_size,\n    pg_size_pretty(a.index_bytes) AS index_size,\n    pg_size_pretty(a.toast_bytes) AS toast_size,\n    pg_size_pretty(a.table_bytes) AS table_size\n   FROM ( SELECT a_1.oid,\n            a_1.table_schema,\n            a_1.table_name,\n            a_1.row_estimate,\n            a_1.total_bytes,\n            a_1.index_bytes,\n            a_1.toast_bytes,\n            ((a_1.total_bytes - a_1.index_bytes) - COALESCE(a_1.toast_bytes, (0)::bigint)) AS table_bytes\n           FROM ( SELECT c.oid,\n                    n.nspname AS table_schema,\n                    c.relname AS table_name,\n                    c.reltuples AS row_estimate,\n                    pg_total_relation_size((c.oid)::regclass) AS total_bytes,\n                    pg_indexes_size((c.oid)::regclass) AS index_bytes,\n                    pg_total_relation_size((c.reltoastrelid)::regclass) AS toast_bytes\n                   FROM (pg_class c\n                     LEFT JOIN pg_namespace n ON ((n.oid = c.relnamespace)))\n                  WHERE (c.relkind = 'r'::\"char\")) a_1) a\n  WHERE (a.table_schema = 'public'::name)\n  ORDER BY a.total_bytes DESC;"},
    {"id":100013,"parent":"4","text":"Размеры таблиц в бд. (239)","view_name":"vw_rep_sys_size_table","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "relation", "type": "text", "title": "relation", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "size", "type": "text", "title": "size", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT (((n.nspname)::text || '.'::text) || (c.relname)::text) AS relation,\n    pg_size_pretty(pg_relation_size((c.oid)::regclass)) AS size\n   FROM (pg_class c\n     LEFT JOIN pg_namespace n ON ((n.oid = c.relnamespace)))\n  WHERE (n.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name]))\n  ORDER BY (pg_relation_size((c.oid)::regclass)) DESC;"},
    {"id":100014,"parent":"4","text":"Буфер/Индексы. (165)","view_name":"vw_rep_sys_sizedb","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int8", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "relname", "type": "text", "title": "relname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "size_buffersize", "type": "text", "title": "size_buffersize", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "buffers_percent", "type": "text", "title": "buffers_percent", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "scan_read_fetch", "type": "text", "title": "scan_read_fetch", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "n_tup_ins", "type": "text", "title": "n_tup_ins", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "n_tup_upd", "type": "text", "title": "n_tup_upd", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "n_tup_del", "type": "text", "title": "n_tup_del", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT row_number() OVER () AS id,\n    (c.relname)::text AS relname,\n    ((pg_size_pretty(pg_relation_size((c.oid)::regclass)) || ' / '::text) || (COALESCE(bf.percent_of_relation, (0)::numeric))::text) AS size_buffersize,\n    (bf.buffers_percent)::text AS buffers_percent,\n    concat_ws('|'::text, ('S:'::text || (p.idx_scan)::text), ('R:'::text || (p.idx_tup_read)::text), ('F:'::text || (p.idx_tup_fetch)::text)) AS scan_read_fetch,\n    (d.n_tup_ins)::text AS n_tup_ins,\n    (d.n_tup_upd)::text AS n_tup_upd,\n    (d.n_tup_del)::text AS n_tup_del\n   FROM ((((pg_class c\n     LEFT JOIN pg_namespace n ON ((n.oid = c.relnamespace)))\n     LEFT JOIN pg_stat_all_tables d ON ((d.relname = c.relname)))\n     LEFT JOIN pg_stat_all_indexes p ON ((btrim((p.indexrelname)::text) = btrim((c.relname)::text))))\n     LEFT JOIN ( SELECT c_1.relname,\n            pg_size_pretty((count(*) * 8192)) AS buffered,\n            round(((100.0 * (count(*))::numeric) / ((( SELECT pg_settings.setting\n                   FROM pg_settings\n                  WHERE (pg_settings.name = 'shared_buffers'::text)))::integer)::numeric), 1) AS buffers_percent,\n            round((((100.0 * (count(*))::numeric) * (8192)::numeric) / (pg_table_size((c_1.oid)::regclass))::numeric), 1) AS percent_of_relation\n           FROM ((pg_class c_1\n             LEFT JOIN pg_buffercache b ON ((b.relfilenode = c_1.relfilenode)))\n             JOIN pg_database d_1 ON (((b.reldatabase = d_1.oid) AND (d_1.datname = current_database()))))\n          GROUP BY c_1.oid, c_1.relname\n          ORDER BY (round(((100.0 * (count(*))::numeric) / ((( SELECT pg_settings.setting\n                   FROM pg_settings\n                  WHERE (pg_settings.name = 'shared_buffers'::text)))::integer)::numeric), 1)) DESC) bf ON ((bf.relname = c.relname)))\n  WHERE ((n.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name])) AND (c.relname !~~ 'pg_toast%'::text))\n  ORDER BY (pg_relation_size((c.oid)::regclass)) DESC;"},
    {"id":100016,"parent":"2","text":"Лексемный поиск (1000000)","view_name":"vw_sg_generate_grek","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "gen_text", "type": "text", "title": "gen_text", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.gen_text\n   FROM sg_generate_grek sg;"},
    {"id":100017,"parent":"2","text":"Триграммный поиск (1000000)","view_name":"vw_sg_generate_lihotop","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "gen_text", "type": "text", "title": "gen_text", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.gen_text\n   FROM sg_generate_lihotop sg;"},
    {"id":100005,"parent":"1","text":"Глаголы (3441)","view_name":"vw_verb","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "name", "type": "varchar", "title": "name", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "uname", "type": "varchar", "title": "uname", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "freq", "type": "int4", "title": "freq", "primary": false, "visible": true, "is_filter": true, "orderable": true}]},"icon":"unknown","view":" SELECT sg.id,\n    sg.name,\n    sg.uname,\n    sg.freq\n   FROM sg_entry sg\n  WHERE (sg.id_class = 13);"},
    {"id":100021,"parent":"1","text":"Части речи и типы (19977)","view_name":"vw_word_with_prop","col":{"columns": [{"cd": ["select2dynamic"], "cdi": null, "data": "word", "type": "varchar", "title": "Часть речи", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["=", "!=", "<", ">", "<=", ">="], "cdi": null, "data": "freq", "type": "int4", "title": "Частота использования", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "class_name", "type": "varchar", "title": "Тип речи", "primary": false, "visible": true, "is_filter": true, "orderable": true}, {"cd": ["select2dynamic"], "cdi": null, "data": "language", "type": "varchar", "title": "Язык", "primary": false, "visible": true, "is_filter": false, "orderable": false}]},"icon":"unknown","view":" SELECT sg.name AS word,\n    sg.freq,\n    sgc.name AS class_name,\n    sgl.name AS language\n   FROM ((sg_entry sg\n     LEFT JOIN sg_class sgc ON ((sgc.id = sg.id_class)))\n     LEFT JOIN sg_language sgl ON ((sgl.id = sgc.id_lang)))\n  WHERE (sg.id_class <> 22);"},
    {"id":100024,"parent":"5","text":"paging_table","view_name":"paging_table","col":{"columns": [{"cd": ["=", "!=", "<", ">", "<=", ">=", "in"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["=", "~", "!=", "in"], "cdi": null, "data": "name", "type": "text", "title": "name", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["=", "~", "!=", "in"], "cdi": null, "data": "descr", "type": "text", "title": "descr", "primary": false, "visible": true, "is_filter": false, "orderable": true}]},"icon":"unknown","view":null},
    {"id":100025,"parent":"5","text":"paging_column_type","view_name":"paging_column_type","col":{"columns": [{"cd": ["=", "!=", "<", ">", "<=", ">=", "in"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["=", "~", "!=", "in"], "cdi": null, "data": "name", "type": "text", "title": "name", "primary": false, "visible": true, "is_filter": false, "orderable": true}]},"icon":"unknown","view":null},
    {"id":100026,"parent":"5","text":"paging_column","view_name":"paging_column","col":{"columns": [{"cd": ["=", "!=", "<", ">", "<=", ">=", "in"], "cdi": null, "data": "id", "type": "int4", "title": "id", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["=", "!=", "<", ">", "<=", ">=", "in"], "cdi": null, "data": "paging_table_id", "type": "int4", "title": "paging_table_id", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["=", "!=", "<", ">", "<=", ">=", "in"], "cdi": null, "data": "paging_column_type_id", "type": "int4", "title": "paging_column_type_id", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["=", "~", "!=", "in"], "cdi": null, "data": "name", "type": "text", "title": "name", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["=", "~", "!=", "in"], "cdi": null, "data": "title", "type": "text", "title": "title", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["="], "cdi": null, "data": "is_visible", "type": "bool", "title": "is_visible", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["="], "cdi": null, "data": "is_orderable", "type": "bool", "title": "is_orderable", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["="], "cdi": null, "data": "is_primary", "type": "bool", "title": "is_primary", "primary": false, "visible": true, "is_filter": false, "orderable": true}, {"cd": ["=", "!=", "<", ">", "<=", ">=", "in"], "cdi": null, "data": "priority", "type": "int4", "title": "priority", "primary": false, "visible": true, "is_filter": false, "orderable": true}]},"icon":"unknown","view":null}];

function getPagingViewObject (view_name)
{
   return  nodeObjects.find(function(element) {
        return element.view_name == view_name;
})};

(function ($) {
    $.fn.DataTableWrapperExt = function (options) {
        var element = this;

        element.css('overflow-x', 'scroll');

        var id = element.attr('id');
        if (!id) {
            id = parseInt(Math.random() * 1000000000);
            element.attr('id', id);
        }

        var idTable = id + '-datatable';
        var idTableSelector = "#" + idTable;
        var select2columnsSelector = 'select-' + idTable;
        var tableObjectName = options.externalOpt.tableDefault;

        var objectInfo = {objdb: tableObjectName, 'dtObj': {}, 's2obj': {}};
        var conditionTable = {};
        var wrapper;
        var datatable;
        var sortObject = options.sortDefault;

        var checkedIds = {};
        var colVis = {};

        function createTable(col) {
            var columns = col;

            options.dataTableOpt['columns'] = columns;
            options.dataTableOpt['order'] = [];


            options.dataTableOpt['ajax'] =
                {
                    url: options.externalOpt.urlDataTable,
                    type: "GET",
                    data: function (d) {
                        d['columns'] = prepareCondition(d).columns;

                        delete d.search;

                        if (d.order[0]) {
                            var col = columns[d.order[0].column].data;
                            d.order = [{'column': col, 'dir': d.order[0].dir}];
                        }

                        if (options.conditionDefault) {
                            d['columns'] = options.conditionDefault;
                            options.conditionDefault = null;
                        }

                        d.objdb = tableObjectName;
                        conditionTable = d;
                    },
                };

            // Add language
            options.dataTableOpt['language'] =
                {
                    "processing": "Подождите...",
                    "search": "Поиск:",
                    "lengthMenu": "Показать _MENU_ записей",
                    "info": "Записи с _START_ до _END_ из _TOTAL_ записей",
                    "infoEmpty": "Записи с 0 до 0 из 0 записей",
                    "infoFiltered": "(отфильтровано из _MAX_ записей)",
                    "infoPostFix": "",
                    "loadingRecords": "Загрузка записей...",
                    "zeroRecords": "Записи отсутствуют.",
                    "emptyTable": "В таблице отсутствуют данные",
                    "paginate": {
                        "first": "Первая",
                        "previous": "Предыдущая",
                        "next": "Следующая",
                        "last": "Последняя"
                    },
                    "aria": {
                        "sortAscending": ": активировать для сортировки столбца по возрастанию",
                        "sortDescending": ": активировать для сортировки столбца по убыванию"
                    }
                };

            //Add drawCallBack
            options.dataTableOpt['drawCallback'] = function (settings) {
                objectInfo['dtObj'] = {o: this.api().data().ajax.json(), i: this.api().data().ajax.params()};

                data = objectInfo.dtObj.o.debug[0].time;
                ttlf = objectInfo.dtObj.o.debug[2].time;
                ttl = objectInfo.dtObj.o.debug[1].time;

                $('.table-info').empty();
                if (data) {
                    $('.table-info').append('<span class="badge badge-secondary" id="datatable-data" data-toggle="modal"  data-target="#modalDynamicInfo">Лимит:' + objectInfo.dtObj.o.debug[0].time + '</span>');
                }

                if (ttlf) {
                    $('.table-info').append('<span class="badge badge-secondary" id="datatable-f-ttl" data-toggle="modal"  data-target="#modalDynamicInfo">Всего:' + objectInfo.dtObj.o.debug[2].time + '</span>');
                }

                if (ttl) {
                    $('.table-info').append('<span class="badge badge-secondary" id="datatable-ttl" data-toggle="modal"  data-target="#modalDynamicInfo">Всего с услв.:' + objectInfo.dtObj.o.debug[1].time + '</span>');
                }
            };
            // Add initComplete
            options.dataTableOpt['initComplete'] = function (settings, json) {
                if (options.initComplete)
                    options.initComplete();

                if (options.externalOpt.dtFilters)
                    addFilter(col);
            };

            options.dataTableOpt['createdRow'] = function (row, data, index) {
                if (options.createdRow) {
                    options.createdRow(row, data, index);
                }
            }
            datatable = $(idTableSelector).DataTable(options.dataTableOpt);
        }

        function addFilter(col) {
            var item = col;
            html = '';

            item.forEach(function (item, i, data) {
                v = '';
                if (item.visible) {
                    v = '<th></th>';

                    if (item.is_filter) {
                        if (item.cd[0] == 'select2dynamic') {
                            v = '<th><select multiple class="' + select2columnsSelector + '"  type="' + item.type + '" name="input" data-column="' + item.data + '"></select></th>';
                        }
                        else if (item.type == 'timestamptz' || item.type == 'date') {
                            v = '<th><input type="' + item.type + '" class="form-control input-sm" data-column="' + item.data + '"></div></th>';
                        }
                        else if (item.cd) {
                            var option = '';

                            (item.cd).forEach(function (element) {
                                option = option + '<option>' + element + '</option>';
                            });

                            var v = '<th><div class="input-group">' +
                                '<div class="input-group-btn">' +
                                '<select class="btn btn-default">' + option +
                                '</select>' +
                                '</div>' +
                                '<input type="' + item.type + '" filter-cond="=" class="form-control input-sm" data-column="' + item.data + '">' +
                                '</div></th>';
                        }
                    }
                }
                html = html + v;
            });

            $(idTableSelector + ' thead').append('<tr>"' + html + '"</tr>');

            $('th .input-group').each(function () {
                $(this).change(function () {
                    var cond;
                    $(this).find(":selected").each(function (d) {
                        cond = this.innerHTML;
                    });

                    $(this).find("[filter-cond]").each(function (d) {
                        $(this).attr('filter-cond', cond);
                    });
                });
            });

            $(idTableSelector + ' th input[type=int4]').each(function (data) {
                $(this).attr('maxlength', '7');
                $(this).bind("change keyup input click", function () {
                    if (this.value.match(/[^0-9]/g)) {
                        this.value = this.value.replace(/[^0-9]/g, '');
                    }
                });
            });

            $('.' + select2columnsSelector).each(function (data) {
                var col = ($(this).attr('data-column'));
                var type = $(this).attr('type')

                $(this).select2({
                    placeholder: "",
                    minimumInputLength: type == 'int4' ? 1 : 1,
                    width: '100%',
                    dropdownAutoWidth: true,
                    language: {
                        inputTooShort: function (args) {
                            return "";
                        },
                        noResults: function () {
                            return "Не найдено";
                        },
                        searching: function () {
                            return "Поиск...";
                        },
                        errorLoading: function () {
                            return "";
                        },
                    },
                    ajax: {
                        url: options.externalOpt.urlSelect2,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: function (srch) {
                            return Object.assign({}, srch, {
                                'objdb': tableObjectName,
                                'col': col,
                                'type': type
                            });
                        },
                        processResults: function (data, page) {
                            var ob = [];

                            objectInfo['s2obj'] = {o: data, i: {'objdb': tableObjectName, 'col': col, 'type': type}};
                            $('.table-info-select').empty();

                            if (objectInfo.s2obj['o'])
                                $('.table-info-select').append('<span class="badge badge-secondary" id="select2-query"  data-toggle="modal"  data-target="#modalDynamicInfo">Select2:' + objectInfo.s2obj.o.time + '</span>');

                            if (ob.push) {
                                $.each(data.rs, function (key, value) {
                                    ob.push({'id': value, 'text': value});
                                });
                            }
                            return {results: ob};
                        }
                    }
                });
            });

            $('.' + select2columnsSelector).on('select2:close', function (evt) {
                datatable.ajax.reload();
            });

            var selectColStamp = idTableSelector + ' th input[type=timestamp],' + idTableSelector + ' th input[type=timestamptz],' + idTableSelector + ' th input[type=date]';

            $(selectColStamp).daterangepicker({
                startDate: moment().subtract(29, 'days'),
                endDate: moment(),
                autoUpdateInput: false,
                locale: {
                    format: 'YYYY.MM.DD',
                    applyLabel: "Применить",
                    customRangeLabel: "Выбрать интервалы",
                },
                ranges: {
                    'Сегодня': [moment(), moment().add(1, 'days')],
                    'Вчера': [moment().subtract(1, 'days'), moment()],
                    'За последние 7-емь дней': [moment().subtract(6, 'days'), moment().add(1, 'days')],
                    'За последние 30-ать дней': [moment().subtract(29, 'days'), moment().add(1, 'days')],
                    'Текущий месяц': [moment().startOf('month'), moment().endOf('month').add(1, 'days')],
                    'Прошлый месяц': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month').add(1, 'days')]
                }
            });

            $(selectColStamp).on('apply.daterangepicker', function (ev, picker) {
                $(this).val(picker.startDate.format('YYYY.MM.DD') + ' - ' + picker.endDate.format('YYYY.MM.DD'));
                datatable.ajax.reload();
            });

            $(selectColStamp).on('cancel.daterangepicker', function (ev, picker) {
                $(this).val('');
                datatable.ajax.reload();
            });
        }

        function prepareCondition(d) {
            conditionTable['columns'] = [];
            var columns = [];

            $(idTableSelector + ' [data-column],th input[type=timestamp],' + idTableSelector + ' th input[type=timestamptz],' + idTableSelector + ' th input[type=date]').each(function (data) {
                var val = $(this).val();
                var filterData = $(this).attr('data-column');
                var filterType = $(this).attr('type');
                var filterCond = $(this).attr('filter-cond');

                if (val) {
                    if (Array.isArray(val)) {
                        columns.push({
                            col: filterData,
                            ft: filterType,
                            fv: val.join(),
                            fc: 'in'
                        });
                    }
                    else if (filterCond) {
                        columns.push({
                            col: filterData,
                            ft: filterType,
                            fv: val,
                            fc: (filterCond.replace('&lt;', '<')).replace('&gt;', '>')
                        });
                    }
                    else {
                        columns.push({
                            col: filterData,
                            ft: filterType,
                            fv: val,
                            fc: 'between'
                        });
                    }
                }
            });

            conditionTable['columns'] = columns;
            return conditionTable;
        };

        function initTable(visCol) {
            var columns = options.externalOpt.columns.columns;

            if (!columns) {
                return $.ajax({
                    method: "GET",
                    url: options.externalOpt.urlColumnData,
                    data: {
                        visCol: visCol,
                        objdb: tableObjectName
                    }
                }).done(function (data) {
                    CollRender(columns);
                });
            }
            else {
                CollRender(columns);
            }
        }

        function CollRender(columns) {
            moment.lang('ru');

            element.html('');
            var simple_checkbox = function (data, type, full, meta) {
                var is_checked = columns == true ? "checked" : "";
                return '<input type="checkbox" class="checkbox" ' +
                    is_checked + '  disabled/>';
            };
            var pretty_timestamp =
                function (data, type, full, meta) {
                    var now = moment.parseZone(data);
                    now = now.format('lll');

                    return now == 'Invalid date' ? '' : now;
                };

            for (var i = 0; i < columns.length; i++) {
                if (columns[i]["type"] == "bool") {
                    columns[i].render = simple_checkbox;
                }
                if (columns[i]["type"] == "timestamptz" || columns[i]["type"] == "timestamp" || columns[i]["type"] == "date") {
                    columns[i].render = pretty_timestamp;
                }
            }

            var htmlElements = [,
                '<table id="' + idTable + '" class="table table-striped table-bordered" cellspacing="0" width="100%">' +
                ' </table>'
            ];

            element.prepend(htmlElements.join(''));

            createTable(columns);

            $('[data-type=rebuild]').click(function () {
                wrapper.rebuildTable();
            });
        }

        wrapper = {
            nodeCount: function () {
                return Object.keys(checkedIds).length;
            },
            getIdDataTableSelector: function () {
                return idTableSelector;
            },
            getCheckedIds: function () {
                return checkedIds;
            },
            getDataTable: function () {
                return datatable;
            },
            rebuildTable: function () {
                return initTable(colVis);
            },
            getJsonInfo: function () {
                return objectInfo;
            },
            clearFilter: function () {
                $(idTableSelector + ' [data-column]').each(function (data) {
                    if ($(this).attr('multiple')) {
                        $(this).select2("val", "");
                    }
                    var val = $(this).val();
                    $(this).val('')
                });
                wrapper.getDataTable().ajax.reload()
            },
            rebuildS2Columns: function (data) {
                tableObjectName = data;
                initTable();
            },
        };

        initTable();

        return wrapper;
    }
})(jQuery);

$('#modalDynamicInfo').on("show.bs.modal", function(e) {
    var value = ($(e.relatedTarget).attr('id'));
    var info = wrapper.getJsonInfo();

    if(value) {
        switch (value) {
            case 'datatable-data':
                object = info['dtObj'].o.debug.query[0];
                break;
            case 'datatable-f-ttl':
                object = info['dtObj'].o.debug.query[1];
                break;
            case 'datatable-ttl':
                object = info['dtObj'].o.debug.query[2];
                break;
            case 'select2-query':
                object = info['s2obj'];
                break;
            case 'response-json':
                object = info['dtObj'].o;
                break;
            case 'request-json':
                object = info['dtObj'].i;
                break;
            case 'sql-view':
                object = definitionSql;
                break;
            default:
        }

        $(this).find(".modal-body").html('<pre><code class="json">' + object + '</code> </pre>');
    }
});