clear all;
close all;

db = [Account("NASDAQ", [], "Investment")];
db = load_kv1bank("NASDAQ2015.KV1", db, 1);
db = load_kv1bank("NASDAQ2017.KV1", db, 1);
db = load_kv1bank("NASDAQ2018.KV1", db, 1);
db = load_kv1bank("NASDAQ2019.KV1", db, 1);

[times, values, balances, bases] = getVectors(db(1));
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