document.addEventListener("DOMContentLoaded", function() {
    function refreshData() {
        $.getJSON('/refresh_data', function(data) {
            var estacoesArray = data.estacoes_metereologicas;
            var microparticulasArray = data.microparticulas;
            var bdArray = data.bd_update_time;
  
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
          
            var date_bd_time = new Date(
              parseInt(bdArray.substring(0, 4)),  // Ano
              parseInt(bdArray.substring(4, 6)) - 1,  // Mês (subtraindo 1, pois os meses em JavaScript são indexados de 0 a 11)
              parseInt(bdArray.substring(6, 8)),  // Dia
              parseInt(bdArray.substring(8, 10)) - 3,  // Hora (subtraindo 3, pois no bd esta salvando como gmt 0)
              parseInt(bdArray.substring(10, 12)),  // Minuto
              parseInt(bdArray.substring(12, 14))  // Segundo
            );
  
            var estacoesTable = createTable(estacoesArray);
            var microparticulasTable = createTable(microparticulasArray);
  
            $('#data-container').html('<h2>Timestamp</h2>' + date_bd_time + '</br>' + '<h3>Estações Metereológicas</h3>' + estacoesTable + '<br><h3>Micropartículas</h3>' + microparticulasTable);
        });
    }
  
    setInterval(refreshData, (1000*5*60));
    refreshData();
  });
  