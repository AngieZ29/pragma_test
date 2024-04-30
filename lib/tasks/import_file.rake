desc 'Importar archivos .csv'
task import_data: :environment do
  require 'csv'
  require 'yaml'

  config = YAML.load_file('config/application.yml')

  entries = Dir.entries(config['file_path'])
  files = entries.reject { |entry| File.directory?(File.join(config['file_path'], entry)) }
  result = []

  files.each do |file|
    if file =~ /\.csv\z/
      puts "Archivo> #{file}"
      ReadFilesAndInsert.read_files(file, config['file_path'])
    end
  end

  puts '********************** FINALIZA CARGA ARCHIVOS CSV **********************'
end
