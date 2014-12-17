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
    @all_seen_words ={}

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
    @all_seen_words[source] = nil

    explore_current_words until @current_words.empty?
    build_path(target)
  end

  def explore_current_words
    new_current_words = []

    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adj_word|
        if @all_seen_words.include?(adj_word)
          next
        else
          new_current_words << adj_word
          @all_seen_words[adj_word] = current_word
        end
      end
    end

    # new_current_words.each do |current|
    #   puts "#current word: #{current} came from the parent: #{@all_seen_words[current]}"
    # end
    @current_words = new_current_words
  end

  def build_path(target)
    path = [target]
    parent = ""

    if @all_seen_words[target] == nil
      puts "no connection!"
    else
      while true
        parent = @all_seen_words[path.last]
        parent.nil? ? break : path << parent
      end
    end

    path.reverse
  end

end


werd = WordChainer.new('dictionary.txt')
p werd.run("hello", "funny")
