require 'nil/file'

require_relative 'Lexicon'

def visualiseEntry(characters, entry)
  puts "#{characters} [#{entry.pinyin.join(' ')}] #{entry.meanings.join('; ')}"
end

if ARGV.size != 1
  exit
end

path = ARGV[0]
lines = Nil.readLines(path)

lexicon = Lexicon.new('data/cedict_ts.u8')

translate = true
lines.each do |line|
  line.force_encoding('utf-8')
  line.strip!
  if line.empty?
    puts "--\n\n"
    next
  end
  if translate
    puts line
    line.each_char do |char|
      entry = lexicon.translate(char)
      if entry == nil
        puts "#{char}: unknown"
      else
        visualiseEntry(char, entry)
      end
    end
    groupSize = 2
    while groupSize <= line.size
      size = groupSize - 1
      (line.size - size).times do |offset|
        group = line[offset..offset + size]
        entry = lexicon.translate(group)
        if entry != nil
          visualiseEntry(group, entry)
        end
      end
      groupSize += 1
    end
  else
    puts "\"#{line}\"\n\n"
  end
  translate = !translate
end
