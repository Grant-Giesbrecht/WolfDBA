clear all;
close all;

load_data("ggiesbrecht.bconf", "db");

[times, values, balances, bases] = getVectors(db(1));
plot(times, balances, 'LineStyle', '-', 'Marker', '+');
hold on;

xlabel("Date");
ylabel("Balance ($)");
title("USAA Visa");
% ylim([0, max(balances)*1.1]);
grid on;
% legend("balance", "basis")