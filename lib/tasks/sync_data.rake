# lib/tasks/sync_data.rake
require 'dotenv/load'

namespace :sync_data do
  task run: :environment do
    begin
      # Código para buscar dados do RethinkDB
      conn_rethinkdb = RethinkDB::RQL.new.connect(
        host: ENV['RETHINKDB_HOST'],
        port: ENV['RETHINKDB_PORT'],
        db: ENV['RETHINKDB_DB'],
        user: ENV['RETHINKDB_USER'],
        password: ENV['RETHINKDB_PASSWORD']
      )

      estacoes_data = RethinkDB::RQL.new.table('estacoes_metereologicas').run(conn_rethinkdb)
      microparticulas_data = RethinkDB::RQL.new.table('microparticulas').run(conn_rethinkdb)

      # Salvar os dados no SQLite
      CustomSqlData.create(
        estacoes_data: estacoes_data.to_a.to_json,
        microparticulas_data: microparticulas_data.to_a.to_json
      )

      # Fechar a conexão com o RethinkDB
      conn_rethinkdb.close
    rescue StandardError => e
      $stderr.puts "Error during data synchronization: #{e.message}"
      # Adicionar qualquer tratamento de erro adicional aqui, se necessário
    end
  end
end
