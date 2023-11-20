class SqliteData < ApplicationRecord
  serialize :estacoes_data, JSON
  serialize :microparticulas_data, JSON
end
