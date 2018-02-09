# This is just a start of what any: is supposed to do
describe "Any queries" do
  include_context "db"

  context "card name" do
    it do
      assert_search_results %Q[any:"Abrupt Decay"], "Abrupt Decay"
    end
    it "is case insensitive" do
      assert_search_equal %Q[any:"ABRUPT decay"], %Q[any:"Abrupt Decay"]
    end
  end

  it "includes German name" do
    assert_search_equal %Q[any:"Abrupter Verfall"], %Q[de:"Abrupter Verfall"]
  end

  context "French name" do
    it do
      assert_search_equal %Q[any:"Décomposition abrupte"], %Q[fr:"Décomposition abrupte"]
    end
    it "is case insensitive" do
      assert_search_equal %Q[any:"Décomposition abrupte"], %Q[any:"décomposition ABRUPTE"]
    end
    it "ignores diacritics" do
      assert_search_equal %Q[any:"Décomposition abrupte"], %Q[any:"Decomposition abrupte"]
    end
  end

  it "includes Italian name" do
    assert_search_equal %Q[any:"Deterioramento Improvviso"], %Q[it:"Deterioramento Improvviso"]
  end

  it "includes Japanese name" do
    assert_search_equal %Q[any:"血染めの月"], %Q[jp:"血染めの月"]
  end

  it "includes Russian name" do
    assert_search_equal %Q[any:"Кровавая луна"], %Q[ru:"Кровавая луна"]

  end

  it "includes Spanish name" do
    assert_search_equal %Q[any:"Puente engañoso"], %Q[sp:"Puente engañoso"]

  end

  it "includes Portuguese name" do
    assert_search_equal %Q[any:"Ponte Traiçoeira"], %Q[pt:"Ponte Traiçoeira"]

  end

  it "includes Korean name" do
    assert_search_equal %Q[any:"축복받은 신령들"], %Q[kr:"축복받은 신령들"]

  end

  it "includes Chinese Traditional name" do
    assert_search_equal %Q[any:"刻拉諾斯的電擊"], %Q[ct:"刻拉諾斯的電擊"]

  end

  it "includes Chinese Simplified name" do
    assert_search_equal %Q[any:"刻拉诺斯的电击"], %Q[cs:"刻拉诺斯的电击"]

  end

  context "artist" do
    it do
      assert_search_equal %Q[any:"Wayne England"], %Q[a:"Wayne England"]
    end
    it "is case insensitive" do
      assert_search_equal %Q[any:"Wayne England"], %Q[any:"WAYNE england"]
    end
  end

  context "flavor text" do
    it do
      assert_search_equal %Q[any:"Jaya Ballard"], %Q[ft:"Jaya Ballard" OR ("Jaya Ballard")]
    end
    it "is case insensitive" do
      assert_search_equal %Q[any:"Jaya Ballard"], %Q[any:"JAYA ballard"]
    end
  end

  context "Oracle text" do
    it do
      assert_search_equal %Q[any:"win the game"], %Q[o:"win the game"]
    end
    it "is case insensitive" do
      assert_search_equal %Q[any:"win the game"], %Q[any:"Win THE gaME"]
    end
  end

  context "Typeline" do
    it do
      assert_search_equal %Q[any:"legendary goblin"], %Q[t:"legendary goblin"]
    end
    it "is case insensitive" do
      assert_search_equal %Q[any:"legendary goblin"], %Q[any:"Legendary GOBLIN"]
    end
  end

  context "rarity" do
    # These words conflict a good deal
    # Rare-B-Gone Oracle text mentions "mythic rare"
    it do
      assert_search_equal %Q[any:"mythic"], %Q[r:"mythic" or ft:"mythic" or o:"mythic" or "Mythic Proportions"]
    end
    it "aliases" do
      assert_search_equal %Q[any:"mythic rare"], %Q[r:"mythic" or o:"mythic rare"]
    end
    it "is case insensitive" do
      assert_search_equal %Q[any:"UNCOMMON"], %Q[any:"uncommon"]
    end
  end
end
