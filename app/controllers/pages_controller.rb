require 'json'

class PagesController < ApplicationController
  def home
    json_data = read_json_file('combined_data.json')
    @last_bd_update = json_data.dig('timestamp', 'timestamp')
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
      bd_update_time: json_data.dig('timestamp', 'timestamp'),
      estacoes_metereologicas: process_estacoes(json_data['estacoes_data']),
      microparticulas: process_microparticulas(json_data['microparticulas_data'])
    }

    # Renderização do JSON processado
    render json: processed_data
  end

  def process_estacoes(estacoes_data)
    estacoes_data.map do |estacao|
      device_info = estacao.dig('deviceInfo')
      object_data = estacao.dig('object')
      modules = object_data.dig('modules')

      if device_info && object_data && modules
        {
          deviceName: device_info['deviceName'],
          temperature: object_data.dig('internal_sensors', 0, 'v').to_f,
          humidity: object_data.dig('internal_sensors', 1, 'v').to_f,
          rain_lvl: modules.dig(0, 'v').to_f,
          avg_wind_speed: modules.dig(1, 'v').to_f,
          gust_wind_speed: modules.dig(2, 'v').to_f,
          wind_direction: modules.dig(3, 'v').to_i,
          luminosity: modules.dig(6, 'v').to_i,
          uv: modules.dig(7, 'v').to_f,
          solar_radiation: modules.dig(8, 'v').to_f,
          atm_pres: modules.dig(9, 'v').to_f
        }
      else
        puts "Error: Missing required elements in estacao."
        {}
      end
    end
  end

  def process_microparticulas(microparticulas_data)
    microparticulas_data.map do |microparticulas|
      object_data = microparticulas.dig('object')

      if object_data
        {
          deviceName: microparticulas['deviceName'],
          co2: object_data.dig('co2'),
          humidity: object_data.dig('humidity').to_f,
          nh3: object_data.dig('nh3'),
          noise: object_data.dig('noise').to_f,
          pm10: object_data.dig('pm10'),
          pm1_0: object_data.dig('pm1_0'),
          pm2_5: object_data.dig('pm2_5'),
          temperature: object_data.dig('temperature').to_f,
          voltage: object_data.dig('voltage').to_f
        }
      else
        puts "Error: Missing required elements in microparticulas."
        {}
      end
    end
  end

  private

  def read_json_file(file_name)
    file_path = Rails.root.join('json_data', file_name)
    json_data = File.read(file_path)
    JSON.parse(json_data)
  end
end
