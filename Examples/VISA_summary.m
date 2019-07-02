clear all;
close all;

load_data("ggiesbrecht.bconf", "db");

visa = filter_acct(db, 'Name', 'USAA_Visa');
discover = filter_acct(db, 'Name', 'Discover_It');

[timesV, valuesV, balancesV, basesV] = getVectors(visa);
[timesD, valuesD, balancesD, basesD] = getVectors(discover);
% plot(times, balances, 'LineStyle', '-', 'Marker', '+');
[timescolV, balcolV] = merge_dates(timesV, balancesV);
[timescolD, balcolD] = merge_dates(timesD, balancesD);
hold off;
bar(timescolV, -1.*balcolV);
hold on;
% bar(timescolD, -1.*balcolD);

xlabel("Date");
ylabel("Expenditure ($)");
title("USAA Visa");
% ylim([0, max(balances)*1.1]);
grid on;
% legend("balance", "basis")