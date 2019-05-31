load_data("ggiesbrecht.bconf", "db");

visaX = filter_acct(db, "Name", "USAA_Visa");
% visaX = filter_entries(visaX, "Category", "FUEL");

if (isempty(visaX.entries))
	disp('Warning: No transactions satisfied all filter conditions. Exiting.');
	return;
end

[t, v, b, bs] = getVectors(visaX, 1);
% plot(t, b);
bar(t,v)

xlabel("Date");
ylabel("Balance ($)");
title("Fuel Purchases over time");
ylim([min(v)*1.1, 0])



% [x, y]=filterbnk('Account', 'Visa', 'DateS', '04/01/2019', 'DateE', '04/30/2019');