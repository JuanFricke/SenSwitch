# lib/tasks/sync_data.rake
namespace :sync_data do
  task run: :environment do
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

    # Salve os dados no SQLite
    SqliteData.create(estacoes_data: estacoes_data, microparticulas_data: microparticulas_data)

    # Feche a conexão com o RethinkDB
    conn_rethinkdb.close
  end
end
