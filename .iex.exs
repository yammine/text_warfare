alias TextWarfare.Domain.Province

b =
  Province.new()
  |> Province.add_turns(1_000)
  |> Province.add_money(1_000_000)
  |> Province.add_land(1_000_000)
