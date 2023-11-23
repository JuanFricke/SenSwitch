// app/assets/javascripts/refresh_data.js
document.addEventListener("DOMContentLoaded", function() {
  function refreshData() {
      $.getJSON('/refresh_data', function(data) {
          var estacoesArray = data.estacoes_metereologicas;
          var microparticulasArray = data.microparticulas;

          var dataAtualizacao = new Date().toLocaleString();

          function createTable(dataArray) {
              var table = '<table border="1"><tbody>';

              for (var key in dataArray[0]) {
                  table += '<tr>';
                  table += '<th>' + key + '</th>';
                  for (var i = 0; i < dataArray.length; i++) {
                      if (typeof dataArray[i][key] === 'object') {
                          // Tratar campos que são objetos (por exemplo, internal_sensors)
                          table += '<td>' + createTable([dataArray[i][key]]) + '</td>';
                      } else {
                          table += '<td>' + dataArray[i][key] + '</td>';
                      }
                  }
                  table += '</tr>';
              }

              table += '</tbody></table>';
              return table;
          }

          var estacoesTable = createTable(estacoesArray);
          var microparticulasTable = createTable(microparticulasArray);

          $('#data-container').html('<h3>Estações Metereológicas</h3>' + estacoesTable + '<br><h3>Micropartículas</h3>' + microparticulasTable);
      });
  }

  setInterval(refreshData, 30000);
  refreshData();
});
