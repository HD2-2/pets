# Loading...[####                                        ] 10%

s = "." * 50
timings = (Random.srand(1234).to_s * 3).split('').map(&:to_i).take(101)
(0..100).each do |i|
  s[i/2] = '#' if i.even? && i < 100
  print "Loading...[" + s + "] #{i}%\r"
  sleep (timings[i] / 30.0)
end
puts "\nCompleted!"