require 'nil/file'

require_relative 'LexiconEntry'

class Lexicon
  def initialize(path)
    contents = Nil.readFile(path)
    contents.force_encoding('utf-8')
    lines = contents.split("\n")
    @entries = {}
    lines.each do |line|
      processLine(line)
    end
  end

  def processLine(line)
    line = line.strip
    if line.empty? || line[0] == '#'
      return
    end
    tokens = line.split(' ')
    if tokens.size < 4
      return
    end
    traditional = tokens[0]
    simplified = tokens[1]
    pinyinMatch = line.match(/\[(.+?)\]/)
    if pinyinMatch == nil
      return
    end
    pinyin = pinyinMatch[1].split(' ')
    meanings = []
    line.scan(/\/(.+?)\//) do |match|
      meanings << match[0]
    end
    [traditional, simplified].each do |characters|
      @entries[characters] = LexiconEntry.new(pinyin, meanings)
    end
  end

  def translate(characters)
    entry = @entries[characters]
    if entry == nil
      return nil
    end
    meaning = entry.meanings.first
    match = meaning.match(/ (.+?)\|/)
    if match == nil
      return entry
    end
    target = match[1]
    output = @entries[target]
    #puts "Resolved #{characters} to #{output.inspect}"
    #exit
    return output
  end
end
