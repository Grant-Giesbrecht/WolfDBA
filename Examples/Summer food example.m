load_data("ggiesbrecht.bconf", "db");

cards = merge_accts(filter_acct(db, 'Type', 'Credit'));
summer_food = get_entries(cards, 'DateRange', '06/09/2018:08/10/2018', 'Category', 'FOOD');

[time, bal, val, bas] = getVectors(summer_food);
[timeC, valC] = merge_dates(time, val);
[timeA, valA] = getVectors(time_average(summer_food, 'month'));

bar(timeC, valC);
plot(timeA, valA);
