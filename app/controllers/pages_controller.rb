require 'rethinkdb'
require 'json'

class PagesController < ApplicationController
  before_action :set_rethinkdb_connection

  def home
    @consulta_estacoes = query_table('estacoes_metereologicas')
    @consulta_microparticulas = query_table('microparticulas')
  end

  def about
  end

  def refresh_data
    render json: {
      estacoes_metereologicas: query_table('estacoes_metereologicas'),
      microparticulas: query_table('microparticulas')
    }
  end

  private

  def set_rethinkdb_connection
    @conn ||= RethinkDB::RQL.new.connect(
      host: ENV['RETHINKDB_HOST'],
      port: ENV['RETHINKDB_PORT'],
      db: ENV['RETHINKDB_DB'],
      user: ENV['RETHINKDB_USER'],
      password: ENV['RETHINKDB_PASSWORD']
    )
  end

  def query_table(table_name)
    RethinkDB::RQL.new.table(table_name).run(@conn)
  end

  def close_rethinkdb_connection
    @conn&.close
  end

  after_action :close_rethinkdb_connection
end
