load_data("ggiesbrecht.bconf", "db");

visaX = filter_acct(db, "Name", "USAA_Visa");
db = merge_groups("EDUCATION", "ELECTRONICS", "EDUCATION");
[sums, sum_labels] = sum_groups(db);

if (isempty(visaX.entries))
	disp('Warning: No transactions satisfied all filter conditions. Exiting.');
	return;
end

pie(sums, sum_labels);


xlabel("Date");
ylabel("Balance ($)");
title("Fuel Purchases over time");
ylim([min(v)*1.1, 0])



% [x, y]=filterbnk('Account', 'Visa', 'DateS', '04/01/2019', 'DateE', '04/30/2019');