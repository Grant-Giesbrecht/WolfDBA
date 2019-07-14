clear all;
close all;

load_data("ggiesbrecht.bconf", "db")

nasdaq = filter_acct(db, 'Name', 'NASDAQ');

[times, values, balances, bases] = getVectors(nasdaq);
plot(times, balances, 'LineStyle', ':', 'Marker', '+');
hold on;
plot(times, bases, 'LineStyle', '--', 'Marker', 'o');
hold off;

xlabel("Date");
ylabel("Balance ($)");
title("NASDAQ");
ylim([0, max(balances)*1.1]);
grid on;
legend("balance", "basis")