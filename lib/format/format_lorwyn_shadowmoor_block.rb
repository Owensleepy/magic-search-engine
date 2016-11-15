class FormatLorwynShadowmoorBlock < Format
  def format_pretty_name
    "Lorwyn-Shadowmoor Block"
  end

  def build_included_sets
    Set["lw", "mt", "shm", "eve"]
  end
end
