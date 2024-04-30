require 'csv'

class ReadFilesAndInsert
  def self.read_files(file, dir)
    # Se crea registro de log por archivo
    log_file = LogFile.create!(name_csv: file)

    csv_file = File.read("#{dir}/#{file}")
    csv = CSV.parse(csv_file, headers: true)

    # Análisis de datos
    data_analytics(file, csv)

    # Calidad de Datos
    price_nil = data_quality(csv)

    # Transformar Datos
    data_transform(csv, log_file, price_nil)
  end

  def self.data_analytics(file, csv)
    puts "Número de filas: #{csv.length}"
    puts "Columnas: #{csv.first.size}"
  end

  def self.data_quality(csv)
    timestamp, price, user_id = 0, 0, 0

    csv.each do |row|
      data = row.to_hash
      timestamp += 1 if data['timestamp'].nil?
      price += 1 if data['price'].nil?
      user_id += 1 if data['user_id'].nil?
    end

    puts "Valores nulos => timestamp: #{timestamp}, price: #{price}, user_id: #{user_id}"
  end

  def self.data_transform(csv, log_file, nil_price)
    current_result = {}
    count_total = 0
    avg = 0
    min = nil
    max = nil
    sum = 0
    nil_price = 0

    file_statistic = FileStatistic.last

    if file_statistic
      count_total = file_statistic.total_rows
      min = file_statistic.min_price
      max = file_statistic.max_price
      sum = file_statistic.sum_price
      nil_price = file_statistic.nil_price
    end

    csv.each do |row|
      data = row.to_hash
      price = data['price']
      # price = data['price'].present? ? data['price'].to_i : 0
      min = price unless min
      max = price unless max
      count_total += 1
      nil_price += 1 if data['price'].nil?

      # Se convierte a fecha el campo timestamp con el formato dd/mm/yyyy
      date = Date.strptime(data['timestamp'], '%m/%d/%Y')
      data['timestamp'] = date.strftime('%d/%m/%Y')

      # Se calcula min, max y se acumula valor de price
      if price.present?
        min = min.to_i < price.to_i ? min.to_i : price.to_i
        max = max.to_i > price.to_i ? max.to_i : price.to_i
        sum += price.to_i
      end

      # Insert de registros
      log_file.data_csvs.create!(data)

      # Hash para imprimir estadisticas
      current_result = {
        total_rows: count_total,
        price: price,
        sum_price: sum,
        avg_price: (sum.to_f / (count_total.to_f - nil_price)).round(2),
        min_price: min,
        max_price: max,
        nil_price: nil_price
      }

      puts current_result
    end

    current_result.delete(:price)

    # Se crea registro de ultimo csv cargado y sumatoria de anteriores cargas
    log_file.file_statistics.create!(current_result)

    if file_statistic
      last_result = file_statistic.as_json.transform_keys(&:to_sym)
      last_result = last_result.transform_keys(&:to_sym)
      last_result.delete(:created_at)
      last_result.delete(:updated_at)
      last_result.delete(:id)
      last_result.delete(:log_file_id)

      puts '***************************************************************************************'
      puts "Acumulado anterior: #{last_result}"
      puts "Acumulado actual:   #{current_result}"
      puts '***************************************************************************************'
    end
  end
end
