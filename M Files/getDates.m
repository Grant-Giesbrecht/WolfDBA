function [dates, values, balances, bases] = getVectors(account)

	%Create array of dates and values
	for i=1:size(account.entries)
		dstr = [dstr, account.entries(i).date];
		vals = [vals, account.entries(i).value];
		bals = [bals, account.entries(i).balance];
		bass = [bass, account.entries(i).basis];
	end
	
	%Convert date strings to date objects
	d = datetime( dstr , 'InputFormat', 'MM/dd/uuuu');
	
	
	
end