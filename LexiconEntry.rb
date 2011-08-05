class LexiconEntry
  attr_reader :pinyin, :meanings

  def initialize(pinyin, meanings)
    @pinyin = pinyin
    @meanings = meanings
  end
end
