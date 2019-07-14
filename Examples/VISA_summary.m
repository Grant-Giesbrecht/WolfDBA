%Load banking data (if not already loaded)
if (~exist("db", "var"))
	load_data("ggiesbrecht.bconf", "db");
end

%Select Visa
visa = filter_acct(db, 'Name', 'USAA_Visa');
if (length(disc) < 1)
	disp('Warning: No Accounts satisfied the filter conditions. Exiting.');
	return;
end

%Plot balance over time
[times, values, balances, bases] = getVectors(visa);
figure(1);
hold off;
plot(times, balances, 'LineStyle', '-', 'Marker', '+');
grid on;
xlabel("Date");
ylabel("Balance ($)");
title("USAA Visa Balance");

%Show bar graph of expenditure
[timescol, balcol] = merge_dates(times, balances);
figure(2);
hold off;
bar(timescol, -1.*balcol);
grid on;
xlabel("Date");
ylabel("Expenditure ($)");
title("USAA Visa Expenditure");