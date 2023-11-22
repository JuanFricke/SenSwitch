# app/models/custom_sql_data.rb
class CustomSqlData < ApplicationRecord
  serialize :estacoes_data, JSON
  serialize :microparticulas_data, JSON
end
