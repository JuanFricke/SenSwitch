# db/migrate/20231121195141_create_custom_sql_data.rb
class CreateCustomSqlData < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_sql_data do |t|
      t.text :estacoes_data
      t.text :microparticulas_data
      t.timestamps
    end
  end
end
