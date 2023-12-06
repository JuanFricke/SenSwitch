require 'sqlite3'

# Conectar ao banco de dados SQLite (substitua 'seu_banco_de_dados.db' pelo nome do seu arquivo SQLite)
db = SQLite3::Database.new 'development.sqlite3'

# Obter a lista de tabelas no banco de dados
tabelas = db.execute "SELECT name FROM sqlite_master WHERE type='table';"

# Iterar sobre as tabelas
tabelas.each do |tabela|
  tabela_nome = tabela[0]

  # Imprimir o nome da tabela
  puts "Tabela: #{tabela_nome}"

  # Obter os dados da tabela
  dados = db.execute "SELECT * FROM #{tabela_nome};"

  # Imprimir os dados da tabela
  dados.each do |linha|
    puts linha.join(', ')
  end

  puts "\n" # Adicionar uma linha em branco entre as tabelas
end

# Fechar a conexão com o banco de dados
db.close
