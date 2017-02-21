def add_random_microseconds_for_date(date)
  to_string = date.strftime('%Y-%m-%d %H:%M:%S.%N')
  comps = to_string.split(".")
  comps_minus_micro = comps[0]
  micro_comp = rand.to_s[2,6]
  date_string = "#{comps_minus_micro}.#{micro_comp}"
  return date_string.to_datetime
end

item = Item.all.last
puts item.updated_at

puts add_random_microseconds_for_date(item.updated_at).strftime('%Y-%m-%d %H:%M:%S.%N')
