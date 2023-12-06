$(document).ready(function () {
  // Função para formatar a data do bd_update_time
  function formatUpdateTime(bdArray) {
    var date_bd_time = new Date(
      parseInt(bdArray.substring(0, 4)),  // Ano
      parseInt(bdArray.substring(4, 6)) - 1,  // Mês (subtraindo 1, pois os meses em JavaScript são indexados de 0 a 11)
      parseInt(bdArray.substring(6, 8)),  // Dia
      parseInt(bdArray.substring(8, 10)) - 3,  // Hora (subtraindo 3)
      parseInt(bdArray.substring(10, 12)),  // Minuto
      parseInt(bdArray.substring(12, 14))  // Segundo
    );

    // Formata a data para exibição
    var formattedDate = date_bd_time.toLocaleString('pt-BR', { timeZone: 'UTC' });

    return formattedDate;
  }

  // Função para criar coluna com base nos dados do sensor
  function createSensorColumn(sensorData) {
    var columnHTML = `
      <div class="column is-one-third">
        <div class="box " id="${sensorData.deviceName}">
          <div class="notification is-success">
            <h3 class="title is-5">${sensorData.deviceName}</h3>
            Sensor operando normalmente.
          </div>
          <div class="sensor-menu" id="${sensorData.deviceName}-menu" style="display: none;">
            <div class="notification">
              <h3>Informações do Sensor</h3>
              ${createTable(sensorData)}
            </div>
          </div>
        </div>
      </div>
    `;
    return columnHTML;
  }

  function createTable(sensorData) {
    var tableHTML = '<table class="table is-bordered is-striped is-fullwidth"><tbody>';

    var labels = {
      'deviceName': 'Nome do Dispositivo',
      'temperature': 'Temperatura',
      'humidity': 'Umidade',
      'rain_lvl': 'Nível de Chuva',
      'avg_wind_speed': 'Velocidade Média do Vento',
      'gust_wind_speed': 'Velocidade Máxima do Vento',
      'wind_direction': 'Direção do Vento',
      'luminosity': 'Luminosidade',
      'uv': 'Índice UV',
      'solar_radiation': 'Radiação Solar',
      'atm_pres': 'Pressão Atmosférica',
      'co2': 'Dióxido de Carbono (CO2)',
      'nh3': 'Amônia (NH3)',
      'noise': 'Nível de Ruído',
      'pm10': 'Partículas PM10',
      'pm1_0': 'Partículas PM1.0',
      'pm2_5': 'Partículas PM2.5',
      'voltage': 'Voltagem',
      // Adicione mais rótulos conforme necessário
    };

    for (var key in sensorData) {
      tableHTML += '<tr>';
      tableHTML += `<th>${labels[key]}</th>`;
      tableHTML += `<td>${sensorData[key]} ${getUnit(key)}</td>`;
      tableHTML += '</tr>';
    }

    tableHTML += '</tbody></table>';
    return tableHTML;
  }

  function getUnit(key) {
    var units = {
      'temperature': '°C',
      'humidity': '%',
      'rain_lvl': 'mm',
      'avg_wind_speed': 'km/h',
      'gust_wind_speed': 'km/h',
      'luminosity': 'lx',
      'uv': '/',
      'solar_radiation': 'W/m²',
      'atm_pres': 'hPa',
      'co2': '',
      'nh3': '',
      'noise': '',
      'pm10': '',
      'pm1_0': '',
      'pm2_5': '',
      'co2': 'ppm',  
      'nh3': 'ppm',  
      'noise': 'dB',  
      'pm10': 'µg/m³',  
      'pm1_0': 'µg/m³',  
      'pm2_5': 'µg/m³',  
      'voltage': 'V',
      'wind_direction': '°'
      // Adicione mais unidades conforme necessário
    };

    return units[key] || '';
  }

  // Função para carregar e processar os dados
  function loadData() {
    $.getJSON('/refresh_data', function (jsonData) {
      // Limpa as colunas existentes antes de adicionar novas
      $("#sensorColumns").empty();

      // Adiciona colunas com base nos dados do JSON
      jsonData.estacoes_metereologicas.forEach(function (sensorData) {
        var columnHTML = createSensorColumn(sensorData);
        $("#sensorColumns").append(columnHTML);
      });

      // Adiciona colunas para micropartículas, se houver
      if (jsonData.microparticulas) {
        jsonData.microparticulas.forEach(function (sensorData) {
          var columnHTML = createSensorColumn(sensorData);
          $("#sensorColumns").append(columnHTML);
        });
      }
      var updateTimeInfo = formatUpdateTime(jsonData.bd_update_time);
      $("#updateTimeInfo").html(`<div class="non-clickable"><strong>Última Atualização:</strong> ${updateTimeInfo}</div>`);

      
      // Evento de clique para exibir/ocultar informações do sensor
      $(".notification").click(function () {
        var sensorId = $(this).closest(".box").attr("id");
        var sensorMenu = $("#" + sensorId + "-menu .sensor-menu");
      
        if (sensorMenu.is(":visible")) {
          sensorMenu.slideUp();
          $(this).removeClass("is-active"); // Remove a classe is-active quando o painel é fechado
        } else {
          $(".sensor-menu").not(sensorMenu).slideUp();
          sensorMenu.slideDown();
          $(".notification").removeClass("is-light"); // Remove a classe is-active de todas as notificações
          $(this).addClass("is-light"); // Adiciona a classe is-active à notificação clicada
      
          var closeBtn = '<button class="delete" id="closeInfoPanelBtn"></button>';
      
          var infoContent = $("#" + sensorId + "-menu .notification").html();
          var sensorInfoContent = createTable(jsonData.estacoes_metereologicas.find(sensor => sensor.deviceName === sensorId) || jsonData.microparticulas.find(sensor => sensor.deviceName === sensorId));
          $("#infoPanel").html(
            `<div class="container is-desktop">
              <article  class="message">
                <h3 class="message-header">Informações do Sensor (${sensorId}) ${closeBtn}</h3>
                <div class="message-body">
                  <div class="table is-bordered is-striped">
                    ${sensorInfoContent}
                  </div>
                </div>
              </article >"
            </div>`
          );
      
          infoPanelOpen = true;
        }
      });
    });
  }

  // Chama a função de carga de dados inicial
  loadData();

  // Define um intervalo de atualização (a cada 5 minutos neste exemplo)
  setInterval(loadData, 5 * 60 * 1000);

  // Evento de clique para fechar o painel de informações se estiver aberto
  $(document).on('click', '#closeInfoPanelBtn', function () {
    $("#infoPanel").html('');
    infoPanelOpen = false;
  });
});
