<?php

use Phinx\Migration\AbstractMigration;

class Olapd extends AbstractMigration
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
UPDATE client_dimension_guide
  SET VALUE =
  case
       when value = 'Армия' then 'Кузнечное дело'
       when value = 'Государственная служба' then 'Гончарное производство'
       when value = 'Информационные технологии/коммуникации' then 'Плотницкое дело'
       when value = 'Культура и искусство' then 'Столярное ремесло'
       when value = 'Медицина' then 'Портняжное дело'
       when value = 'Наука и образование' then 'Ткацкое'
       when value = 'Промышленность' then 'Прядильное'
       when value = 'Сервис и услуги' then 'Скорняжное'
       when value = 'Сетевой маркетинг' then 'Пекарное'
       when value = 'Строительство и недвижимость' then 'Cапожное'
       when value = 'Торговля' then 'Печное'
       when value = 'Транспорт' then 'Ювелирное'
       when value = 'Финансы, страхование, консалтинг' then 'Кожевенное' else value end
where type_id = 4;

UPDATE client_dimension
  SET VALUE =
  case
       when value = 'Армия' then 'Кузнечное дело'
       when value = 'Государственная служба' then 'Гончарное производство'
       when value = 'Информационные технологии/коммуникации' then 'Плотницкое дело'
       when value = 'Культура и искусство' then 'Столярное ремесло'
       when value = 'Медицина' then 'Портняжное дело'
       when value = 'Наука и образование' then 'Ткацкое'
       when value = 'Промышленность' then 'Прядильное'
       when value = 'Сервис и услуги' then 'Скорняжное'
       when value = 'Сетевой маркетинг' then 'Пекарное'
       when value = 'Строительство и недвижимость' then 'Cапожное'
       when value = 'Торговля' then 'Печное'
       when value = 'Транспорт' then 'Ювелирное'
       when value = 'Финансы, страхование, консалтинг' then 'Кожевенное' else value end
where type_id = 4;

EOD;
        $this->execute($query);
    }
}
