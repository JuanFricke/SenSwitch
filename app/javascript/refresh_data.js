// app/assets/javascripts/refresh_data.js
document.addEventListener("DOMContentLoaded", function() {
    function refreshData() {
      $.getJSON('/refresh_data', function(data) {
        var estacoesArray = data.estacoes_metereologicas;
        var microparticulasArray = data.microparticulas;
  
        var dataAtualizacao = new Date().toLocaleString();
  
        var estacoesJSON = JSON.stringify({ dataAtualizacao, data: estacoesArray }, null, 2);
        var microparticulasJSON = JSON.stringify({ dataAtualizacao, data: microparticulasArray }, null, 2);
  
        $('#data-container').html('<pre>' + estacoesJSON + '</pre><br><pre>' + microparticulasJSON + '</pre>');
      });
    }
  
    setInterval(refreshData, 30000);
    refreshData();
  });
  