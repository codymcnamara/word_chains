require 'set'
#require 'byebug'

class WordChainer

  attr_accessor :dictionary, :dictionary_set

  def initialize(dictionary_file_name)
    @dictionary = []
    File.open(dictionary_file_name) do |f|
      f.each_line { |line| @dictionary << line.chomp}
    end
    @dictionary_set = Set.new(@dictionary)
    @current_words = []

  end

  def adjacent_words(word)
    adjacent_words = []

    word.each_char.with_index do |old_letter, i|
      ('a'..'z').each do |new_letter|
        next if old_letter == new_letter

        new_word = word.dup
        new_word[i] = new_letter

        adjacent_words << new_word if self.dictionary_set.include?(new_word)
      end
    end

    adjacent_words
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = [source]

    until @current_words.empty?
      new_current_words = []
      @current_words.each do |current_word|
        adjacent_words(current_word).each do |adj_word|
          if @all_seen_words.include?(adj_word)
            next
          else
            new_current_words << adj_word
            @all_seen_words << adj_word
          end
        end
      end
      p new_current_words.sort
      @current_words = new_current_words
    end
  end
end


werd = WordChainer.new('dictionary.txt')
# werd.dict
werd.run("wonder", "flavor")