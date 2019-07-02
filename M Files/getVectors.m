%=========================================================================%
% This function takes the data stored in the entries of an 'Account' obj
% and saves their values in arrays. In other words, this function changes
% the way data are stored from an array of objects w/ multiple fields  to 
% set of multiple arrays (s.t. each array contains the data for one field).
%
% Arguments: 
% 	account - The account whose data you wish to extract into vector form
%	merge_common_Xs (opt) - Determines if two consecutive cells with the
% 		same time value should be merged. This is designed to accomodate
% 		bar graphs. Default is 0. 0=off, 1=on.
%
% Returns:
%	[date_vector, value_vector, balance_vector, basis_vector]
%=========================================================================%
function [dates, values, balances, bases] = getVectors(account, merge_common_Xs)

	%Check to see if optional argument was provided
	if ~exist('merge_common_Xs','var')
		merge_common_Xs = 0;
	end

	dstr = string.empty();
	vals = double.empty();
	bals = double.empty();
	bass = double.empty();

	%Create array of dates and values
	for i=1:length(account.entries)
		dstr = [dstr, account.entries(i).date];
		vals = [vals, account.entries(i).value];
		bals = [bals, account.entries(i).balance];
		bass = [bass, account.entries(i).basis];
	end
	
	%(If opted for,) merge data points
	incr = 1;
	if (merge_common_Xs)
		while (incr <= (length(dstr)-1)) %For each data point
			if (dstr(incr) == dstr(incr+1)) %See if X and next X match
				vals(incr) = vals(incr)+vals(incr+1); 
				bals(incr) = bals(incr)+bals(incr+1);
				bass(incr) = bass(incr)+bass(incr+1);
				dstr(incr+1) = [];
				vals(incr+1) = [];
				bass(incr+1) = [];
				bals(incr+1) = [];
			else
				incr = incr + 1;
			end
		end
	end
	
	%Convert date strings to date objects
	d = datetime( dstr , 'InputFormat', "MM/dd/uuuu");
	dates = d;
	values = vals;
	balances = bals;
	bases = bass;
	
end