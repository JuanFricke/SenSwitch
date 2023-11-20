require 'rethinkdb'
require 'json'

class PagesController < ApplicationController
  def home
    # Configuração de conexão com o banco de dados RethinkDB
    conn = RethinkDB::RQL.new.connect(
      host: ENV['RETHINKDB_HOST'],
      port: ENV['RETHINKDB_PORT'],
      db: ENV['RETHINKDB_DB'],
      user: ENV['RETHINKDB_USER'],
      password: ENV['RETHINKDB_PASSWORD']
    )

    # Consulta a tabela 'estacoes_metereologicas'
    consulta_estacoes = RethinkDB::RQL.new.table('estacoes_metereologicas').run(conn)

    # Consulta a tabela 'microparticulas'
    consulta_microparticulas = RethinkDB::RQL.new.table('microparticulas').run(conn)

    @consulta_estacoes = consulta_estacoes
    @consulta_microparticulas = consulta_microparticulas

    # Fecha a conexão com o servidor RethinkDB
    conn.close


  end

  def about
    # Configuração de conexão com o banco de dados RethinkDB
    conn = RethinkDB::RQL.new.connect(
      host: ENV['RETHINKDB_HOST'],
      port: ENV['RETHINKDB_PORT'],
      db: ENV['RETHINKDB_DB'],
      user: ENV['RETHINKDB_USER'],
      password: ENV['RETHINKDB_PASSWORD']
    )

    # Consulta a tabela 'estacoes_metereologicas'
    consulta_estacoes = RethinkDB::RQL.new.table('estacoes_metereologicas').run(conn)

    # Consulta a tabela 'microparticulas'
    consulta_microparticulas = RethinkDB::RQL.new.table('microparticulas').run(conn)

    conn.close
    render json: {
      estacoes_metereologicas: consulta_estacoes,
      microparticulas: consulta_microparticulas
    }
  end
end
