require "net/http"
require "uri"
require_relative "wget"

start_time = Time.new
wget("http://web.archive.org/web/timemap/link/dev.by", "./tmp/dev_by_list.txt")
wget("http://web.archive.org/web/timemap/link/devby.io", "./tmp/devby_io_list.txt")

`cd tmp ; cat dev_by_list.txt devby_io_list.txt > list.txt ; rm dev_by_list.txt devby_io_list.txt`

file = File.new('./tmp/list.txt')
uri_list = file.readlines.map{|string| URI.extract(string)[0]}.select{|line| /\d{14}/.match?(line)}
file.close

hash = {}
output = File.new("stat/" + Time.now.strftime("%Y%m%d-%H.%M.%S") + "_dev_by_vacancies", "a:UTF-8")
i = 0
len = uri_list.size
puts "Entries amount: #{len}"
for u in uri_list do
  print " #{i} of #{len}\r"
  uri = URI.parse(u)
  begin
    response = Net::HTTP.get_response(uri).body.force_encoding(Encoding::UTF_8)
    vacancy = /(\d+) ваканси[йя] на jobs.dev.by/.match(response) || /Все вакансии \((\d+)\)/.match(response) || '00'
    i += 1
    if vacancy != '00' 
      hash[u] = vacancy[1]
    else
      next
    end
  rescue Errno::ECONNREFUSED => error
    puts "Error: #{error}"
    i += 1
    next
  end
end

hash.each{|k,v| output.puts "#{k.gsub(/.+(\d{14}).+/, '\1')[0,8]} ----- #{v} вакансий" }

output.close

puts "Выполнено за #{(Time.new - start_time).to_i} секунд"

