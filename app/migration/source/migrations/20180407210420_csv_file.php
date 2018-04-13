<?php

use Phinx\Migration\AbstractMigration;

class CsvFile extends AbstractMigration
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
     * Remember to call create() or update() and NOT save() when working
     * with the Table class.
     */
    public function change()
    {
$query =<<<'EOD'
create table bible
  (
      id serial primary key,
      page text,
      page_ts_vector tsvector,
      book text,
      chapter text,
      row text      
  );

  copy bible(page) from '/var/www/phalcon/app/migration/dump/source/bible.txt';
      
    delete from bible
    where page = '';
    
    update bible 
    set page_ts_vector = to_tsvector(lower(page));
    
    with cte as
(
    SELECT
      id,
      b.page as chapter,
      (SELECT bl.page as book
       FROM bible as bl
       WHERE bl.id < b.id  and b.page = 'Глава 1' or b.page ='Псалом 1' order by id  desc limit 1 )
      /*,(SELECT case when length(bl.page) < 60 then bl.page else null end  as section
       FROM bible as bl
       WHERE bl.id < b.id  and b.page = 'Глава 1' order by id  desc limit 1 offset 1)*/
    FROM bible AS b
    WHERE page ~~ 'Глава%' or page ~~'Псалом%'
    ORDER BY id
)
  update bible 
  set book = c.book,
      chapter = c.chapter 
  from cte as c 
  where c.id = bible.id;
      
      
    delete from  bible
    where id in (1,3,5,7,11,13);
    
   
  CREATE INDEX bible_tsvector_page_ts_vector ON bible USING GIN (page_ts_vector);
  
CREATE OR REPLACE FUNCTION public.first ( anyelement, anyelement )
RETURNS anyelement LANGUAGE SQL IMMUTABLE STRICT AS $$
        SELECT $1;
$$;
 
CREATE AGGREGATE public.first (
        sfunc    = public.first,
        basetype = anyelement,
        stype    = anyelement
);

update bible 
set book = 'Книга премудрости Иисуса, сына Сирахова *',chapter = 'Предисловие' 
where id = 41465;

update bible 
set book = null 
where id = 41481;

delete from bible 
where id in (62901,62903,62907,62911);

CREATE OR REPLACE FUNCTION public.str2integer(a text)
  RETURNS int4
AS
$BODY$
  BEGIN
  RETURN a :: INTEGER;
  EXCEPTION WHEN OTHERS THEN
  RETURN null;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;


EOD;
        $this->execute($query);
    }
}
