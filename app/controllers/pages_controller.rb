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
    # Leitura do arquivo JSON original
    json_data = read_json_file('combined_data.json')

    # Processamento e conversão do JSON
    processed_data = {
      bd_update_time: json_data['timestamp']['timestamp'],
      estacoes_metereologicas: process_estacoes(json_data['estacoes_data']),
      microparticulas: process_microparticulas(json_data['microparticulas_data'])
    }

    # Renderização do JSON processado
    render json: processed_data
  end

  def process_estacoes(estacoes_data)
    estacoes_data.map do |estacao|
      {
        deviceName: estacao['deviceInfo']['deviceName'],
        temperature: estacao['object']['internal_sensors'][0]['v'].to_f,
        humidity: estacao['object']['internal_sensors'][1]['v'].to_f,
        rain_lvl: estacao['object']['modules'][0]['v'].to_f,
        avg_wind_speed: estacao['object']['modules'][1]['v'].to_f,
        gust_wind_speed: estacao['object']['modules'][2]['v'].to_f,
        wind_direction: estacao['object']['modules'][3]['v'].to_i,
        luminosity: estacao['object']['modules'][6]['v'].to_i,
        uv: estacao['object']['modules'][7]['v'].to_f,
        solar_radiation: estacao['object']['modules'][8]['v'].to_f,
        atm_pres: estacao['object']['modules'][9]['v'].to_f
      }
    end
  end

  def process_microparticulas(microparticulas_data)
    microparticulas_data.map do |microparticulas|
      {
        deviceName: microparticulas['deviceName'],
        co2: microparticulas['object']['co2'],
        humidity: microparticulas['object']['humidity'].to_f,
        nh3: microparticulas['object']['nh3'],
        noise: microparticulas['object']['noise'].to_f,
        pm10: microparticulas['object']['pm10'],
        pm1_0: microparticulas['object']['pm1_0'],
        pm2_5: microparticulas['object']['pm2_5'],
        temperature: microparticulas['object']['temperature'].to_f,
        voltage: microparticulas['object']['voltage'].to_f
      }
    end
  end

  private

  def read_json_file(file_name)
    file_path = Rails.root.join('json_data', file_name)
    json_data = File.read(file_path)
    JSON.parse(json_data)
  end
end
