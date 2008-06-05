#!/usr/local/bin/ruby

puts "Make POT-Files ..."

file_in=File::open( 'po/de_AT/iboard.pot', 'r')
old_ids = []
old_strs= []

new_ids = []
line_no = 0

while line = file_in.gets do
  line.chomp!  
  if (line[0..4]) == 'msgid'
    old_ids[line_no] = "#{line}"
    next_line = file_in.gets
    old_strs[line_no] == next_line.chomp
    line_no+=1
  end
end

puts "Read #{old_ids.length} Message-IDs from old file iboard.pot"
file_in.close

file_in=File::open( 'po/de_AT/iboard-new.pot', 'r')
while line = file_in.gets do
  line.chomp!  
  if (line[0..4]) == 'msgid'
    existing = false
    old_ids.detect  { |oldid| 
      if oldid == line
        existing = true
      end
    }
    if ! existing
      puts "#{line}"
      puts 'msgstr ""'
      puts ""
    end
  end
end
file_in.close
