require 'json'

class PagesController < ApplicationController
  def home
    json_data = read_json_file('combined_data.json')
    @last_bd_update = json_data['timestamp']['timestamp']
    @consulta_estacoes = json_data['estacoes_data']
    @consulta_microparticulas = json_data['microparticulas_data']
  end

  def about
  end

  def refresh_data
    json_data = read_json_file('combined_data.json')
    render json: {
      bd_update_time: json_data['timestamp']['timestamp'],
      estacoes_metereologicas: json_data['estacoes_data'],
      microparticulas: json_data['microparticulas_data']
    }
  end

  private

  def read_json_file(file_name)
    file_path = Rails.root.join('json_data', file_name)
    json_data = File.read(file_path)
    JSON.parse(json_data)
  end
end
