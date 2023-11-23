# senswitch/lib/tasks/sync_data.rake
require 'dotenv/load'
require 'json'
require 'fileutils'

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

      estacoes_data = RethinkDB::RQL.new.table('estacoes_metereologicas').run(conn_rethinkdb).to_a
      microparticulas_data = RethinkDB::RQL.new.table('microparticulas').run(conn_rethinkdb).to_a

      # Salvar os dados no SQLite
      CustomSqlData.create(
        estacoes_data: estacoes_data,
        microparticulas_data: microparticulas_data
      )

      # Diretório para salvar os dados JSON
      json_data_dir = 'json_data'
      FileUtils.mkdir_p(json_data_dir) unless File.directory?(json_data_dir)

      # Salvar os dados em arquivos JSON locais no diretório senswitch/json_data
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      combined_data = {
        estacoes_data: estacoes_data,
        microparticulas_data: microparticulas_data
      }

      json_filename = "#{json_data_dir}/combined_data_#{timestamp}.json"

      File.open(json_filename, 'w') { |file| file.write(JSON.generate(combined_data)) }

      # Manter apenas os últimos 5 arquivos e excluir os mais antigos
      json_files = Dir.glob("#{json_data_dir}/combined_data_*.json").sort
      json_files = json_files.last(5)

      FileUtils.rm(json_files[0..-6]) if json_files.size > 5

      # Fechar a conexão com o RethinkDB
      conn_rethinkdb.close
    rescue StandardError => e
      $stderr.puts "Error during data synchronization: #{e.message}"
      # Adicionar qualquer tratamento de erro adicional aqui, se necessário
    end
  end
end
