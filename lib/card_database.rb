require "pathname"
require "json"
require_relative "card"
require_relative "card_set"
require_relative "card_printing"
require_relative "query"

class CardDatabase
  attr_reader :sets, :cards
  def initialize
    @sets = {}
    @cards = {}
    yield(self)
  end

  def search(query_string)
    query = Query.new(query_string)
    results = []
    each_printing do |card|
      if query.match?(card)
        results << card
      end
    end
    results.sort
  end

  def search_card_names(query_string)
    search(query_string).map(&:name).uniq
  end

  def each_printing
    @cards.each do |card_name, card|
      card.printings.each do |printing|
        yield printing
      end
    end
  end

  def printings
    enum_for(:each_printing).to_a
  end

  def subset(sets)
    # puts "Loading subset: #{sets}"
    self.class.send(:new) do |db|
      db.send(:load_from_subset!, self, sets)
    end
  end

  class <<self
    private :new

    def load(path)
      # puts "Initialize #{path}"
      new do |db|
        db.send(:load_from_json!, Pathname(path))
      end
    end
  end

  private

  def load_from_subset!(db, sets)
    db.sets.each do |set_code, set|
      next unless sets.include?(set_code)
      @sets[set_code] = set
    end
    db.cards.each do |card_name, card|
      printings = card.printings.select do |printing|
        sets.include?(printing.set_code)
      end
      next if printings.empty?
      @cards[card_name] = card.dup
      @cards[card_name].printings = printings
    end
    # color_identity already set in parent database
  end

  def load_from_json!(path)
    color_identity_cache = {}
    multipart_cards = {}
    data = JSON.parse(path.open.read)
    data["sets"].each do |set_code, set_data|
      @sets[set_code] = CardSet.new(set_data)
    end
    data["cards"].each do |card_name, card_data|
      case card_data["layout"]
      when "token", "vanguard", "plane", "scheme", "phenomenon"
        # Do not include in search results
        next
      when "normal", "leveler", "double-faced", "split", "flip"
        # OK
      else
        warn "Unknown card layout: #{rard_data["layout"]}"
      end
      card = @cards[card_name] = Card.new(card_data.reject{|k,_| k == "printings"})
      color_identity_cache[card_name] = card.partial_color_identity
      if card_data["names"]
        multipart_cards[card_name] = card_data["names"] - [card_name]
      end
      card_data["printings"].each do |set_code, printing_data|
        card.printings << CardPrinting.new(
          card,
          @sets[set_code],
          printing_data
        )
      end
    end
    @cards.each do |card_name, card|
      if card.has_multiple_parts?
        card.color_identity = card.names.map{|n| color_identity_cache[n].chars }.inject(&:|).sort.join
      end
    end
    multipart_cards.each do |card_name, other_names|
      card = @cards[card_name]
      other_cards = other_names.map{|name| @cards[name] }
      card.printings.each do |printing|
        printing.others = other_cards.map do |other_card|
          from_same_set = other_card.printings.select{|other_printing| other_printing.set_code == printing.set_code}
          raise "Can't link other side" unless from_same_set.size == 1
          from_same_set[0]
        end
      end
    end
  end
end
