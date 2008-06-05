#!/usr/local/bin/ruby
puts "Renaming migrations to old schema ...."
PATTERN=/([0-9]+)_(\S+)/
dir = Dir["2008*"]
i=0
dir.each do |fn|
  prefix = fn.match(PATTERN)[1]
  suffix = fn.match(PATTERN)[2]
  newname = sprintf( "%03d_%s",i += 1, suffix )
  puts "mv #{fn} #{newname}"
end
