% Prints a summary of the data for a specific date.
%
% acct - accounts who's data for that date to print
% date - date to print (in dd-MON-uuuu format or as datetime obj). (ex. 07-JUL-2019)
%
function date_summary(accts, date)

	d = datetime(date);

	disp(['Summary for date: ', char(string(date))]);
	
	for ia = 1:length(accts)
		ent = filter_entries(accts(ia), 'TimeE', d, 'TimeS', d);
		for ie = 1:length(ent.entries)
			disp(['[', num2str(ie), ']']);
			disp(['  Memo: ', char(ent.entries(ie).memo)]);
			disp(['  Desc: ', char(ent.entries(ie).desc)]);
			disp(['  Value: ', char(num2str(ent.entries(ie).value))]);
			disp(['  Balance: ', char(num2str(ent.entries(ie).balance))]);
			disp(['  basis: ', char(num2str(ent.entries(ie).basis))]);
			disp('  Categories: ');
			for c=ent.entries(ie).categories
				if (c~="")
					disp(['    ', char(c)]);
				end
			end
			disp('  ID Groups: ');
			for g=ent.entries(ie).idgroups
				if (g~="")
					disp(['    ', char(g)]);
				end
			end
		end
	end

end