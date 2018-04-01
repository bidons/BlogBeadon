<?php

use Phinx\Migration\AbstractMigration;

class AddWordMigration extends AbstractMigration
{
    /**
     * Change Method.
     *
     * Write your reversible migrations using this method.
     *
     * More information on writing migrations is available here:
     * http://docs.phinx.org/en/latest/migrations.html#the-abstractmigration-class
     *
     * The following commands can be used in this method and Phinx will
     * automatically reverse them when rolling back:
     *
     *    createTable
     *    renameTable
     *    addColumn
     *    renameColumn
     *    addIndex
     *    addForeignKey
     *
     * Remember to call "create()" or "update()" and NOT "save()" when working
     * with the Table class.
     */
    public function change()
    {
        $query =<<<'EOD'
create INDEX sg_entry_name on sg_entry(lower(name));
create INDEX sg_class_name on sg_class(lower(name));

create view vw_word_with_prop as
select sg.name as word,freq,sgc.name as class_name,sgl.name as language
from sg_entry sg
left join sg_class as sgc on sgc.id = sg.id_class
left join sg_language as sgl on sgl.id = sgc.id_lang;

select rebuild_paging_prop('vw_word_with_prop','Части речи и типы','part_of_speech',FALSE);


update paging_column
set condition = json_build_array('select2dynamic')
where paging_column.paging_table_id in (select id from paging_table where name = 'vw_word_with_prop');


update paging_column
set condition ='["=", "!=", "<", ">", "<=", ">="]'
where id =
(select id
from paging_column as p
where paging_table_id =
      (select id from paging_table
where name ~'vw_word_with_prop') and p.name = 'freq');


select get_paging_table_total_count();
CREATE OR REPLACE FUNCTION public.paging_table_cond(a_argg jsonb)
  RETURNS text
AS
$BODY$
  DECLARE
  val_result TEXT;
  val_dbobj  TEXT = a_argg -> 'objdb';
BEGIN

    WITH getcolumns AS
  (
      SELECT jsonb_array_elements(a_argg -> 'columns') AS r
  ), normalize AS
  (
      SELECT
        r ->> 'col' AS f_data,
        r ->> 'fc'  AS f_cd,
        r ->> 'fv'  AS f_value,
        r ->> 'ft'  AS f_type
      FROM getcolumns AS t
  )
  SELECT string_agg(case when  (f_type ~ 'timestamp|date')
  THEN concat_ws(' ',
                     f_data,
                     f_cd,
                     quote_literal(split_part(f_value, ' - ', 1)),
                     'and',
                     quote_literal(split_part(f_value, ' - ', 2)))
      when (f_cd = 'in' AND f_type ~ 'int')
        THEN concat_ws(' ',
                       f_data,
                       f_cd,
                       '(' || f_value) || ')'
      when (f_cd = 'in')
        THEN concat_ws(' ',
                       f_data,
                       f_cd,
                       '(' || (SELECT string_agg(quote_literal(r), ',')
                 FROM regexp_split_to_table(f_value,',') AS r)) || ')'
      else  concat_ws(' ',
                       f_data,
                       f_cd,
                       quote_literal(f_value)) end,' and ')
  FROM normalize AS n
  INTO val_result;

  RETURN Coalesce('where true and ' || val_result, 'where true');
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;

EOD;
        $this->execute($query);
    }
}
