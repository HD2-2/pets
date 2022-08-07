def wget(url,file)
  require 'net/http'
  require 'uri'

  # if (!file)
  #   file = File.basename(url)
  # end
  print "URL list #{url} - "
  url = URI.parse(url)
  Net::HTTP.start(url.host) do |http|
    resp = http.get(url.path)
    resp ? (puts "OK") : (puts "NOT OK")
    open(file, "wb") do |file|
      file.write(resp.body)
    end
  end
end

