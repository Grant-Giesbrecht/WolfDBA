% Gets the start and end dates (to feed into a 'filter_entries' call) for a
% specified time period (eg. last 30 days, year to date, etc). 
%
% Arguments:
%	t - Date to reference
%	val - Value for range. Options:
%		integer - Number of days to go back. (This is slow for large #s
%		of days (goes in batches of 30)).
%			ex. dates_relative(datetime(date), "num", 30); %Gets the
%			past 30 days.
%
function[startdate, enddate] = dates_relative(t, value)
		
	found = 0;
	d_last = t;
	while (~found)

		nd = dateshift(d_last, 'start', 'month', 'previous'); %Set date back about 30 days...
		darr = nd:t; %Turn into array (to get # days)
		d_last = nd;

		if (length(darr) >= value) %See if enough days are found
			found = 1; %Quit loop
			startdate = darr(length(darr)-value+1); %Select start date
			enddate = t; %Mark the end date
		end
	end

end