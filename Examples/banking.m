

dates = ["04/20/2019", "04/20/2019", "05/01/2019", "05/05/2019", "05/06/2019"];
datesf = datetime(dates, 'InputFormat', 'MM/dd/uuuu');

balances = [1e3, 1100, 1150, 900, 930];

plot(datesf, balances);
xlabel('Date');
ylabel('Balance (USD)');
ylim([0, 1.2e3]);
title(['Balance of Accounts']);
legend();