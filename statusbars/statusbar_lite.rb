print "Loading: ["
(1..50).each do
    print "#"
    %w[/ - \\  | / - \\  | / - \\  |].each{|i| print "#{i}\b"; sleep 0.02}
end
print "]  Complete!\n"
