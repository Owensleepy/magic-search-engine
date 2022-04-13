describe "is:commander" do
  include_context "db"

  # arguable if banned cards should be included,
  # but there are multiple commander-like formats
  # with multiple banlists

  it "includes all unusual commanders" do
    assert_search_include "is:commander",
      "Erayo, Soratami Ascendant",
      "Daretti, Scrap Savant",
      "Agrus Kos, Wojek Veteran",
      "Griselbrand",
      "Bruna, the Fading Light",
      "Ulrich of the Krallenhorde",
      "The Legend of Arena"
  end

  it "does not include other sides of commander cards" do
    assert_search_exclude "is:commander",
      "Erayo's Essence",
      "Autumn-Tail, Kitsune Sage",
      "Brisela, Voice of Nightmares",
      "Hanweir, the Writhing Township",
      "Ormendahl, Profane Prince",
      "Ulrich, Uncontested Alpha",
      "Withengar Unbound",
      "Elbrus, the Binding Blade"
  end

  it "is:commander" do
    # Some C14 commanders got reprited
    assert_search_equal_cards "is:commander",
      "(is:primary t:legendary t:creature) OR (t:planeswalker e:c14,c18,bbd,cmr) OR (t:saga e:htr18) OR (Grand Calcutron) OR (Grist Hunger Tide) OR (Shorikai, Genesis Engine)"
  end

  it "is:brawler" do
    assert_search_equal_cards "is:brawler", "(is:primary t:legendary t:creature) OR (is:primary t:legendary t:planeswalker) OR (t:saga e:htr18) OR (Grand Calcutron) OR (Shorikai, Genesis Engine)"
  end

  it "Grist" do
    assert_search_include "is:commander", "Grist, the Hunger Tide", "The Legend of Arena", "The Grand Calcutron"
    assert_search_include "is:brawler", "Grist, the Hunger Tide", "The Legend of Arena", "The Grand Calcutron"
  end
end
