alias TextWarfare.Domain.Province

p =
  Province.new()
  |> Province.add_turns(1_000)
  |> Province.add_money(1_000_000)
  |> Province.add_land(1_000_000)

{:ok, p} = Province.build(p, :barracks, 100)
{:ok, p} = Province.build(p, :armory, 100)
{:ok, p} = Province.build(p, :shipyard, 100)
{:ok, p} = Province.build(p, :airfield, 100)

{:ok, p} = Province.train(p, :destroyer, 1_000)
{:ok, p} = Province.train(p, :carrier, 1_000)
{:ok, p} = Province.train(p, :heavy_tank, 1_000)
