%=========================================================================%
% This function is NOT intended to be seen or used by the end user. It is
% called by 'filter_entries()' to provide a recursive style filter. Before,
% complying with multiple filters meant getting that one entry returned
% multiple times. This new structure fixes that issue.
%
%	ie. Account --> Account (w/ some entries removed)
%
% Filter options:
%	Category	IDGrp
%	TimeS		Memo		
%	TimeE		Desc
%
% Arguments:
%	
%
%
%=========================================================================%
function acct_out=filter_entries(acct_in, fltr, val)

	%If input account is empty, return an empty account
	if (isempty(acct_in))
		acct_out = acct_in;
	end

	%Create the output account
	matches = Account(acct_in.name, [], acct_in.acct_type);
	matches.acct_number = acct_in.acct_number;
	matches.bank_name = acct_in.bank_name;
	matches.filtered = 1;

	%Deterime filter type
	if (strcmp(fltr,"Category") == 1)
		for i=1:length(acct_in.entries) %Check each entry
			if (~isempty(find(acct_in.entries(i).categories == val))) %Check to see if categories contains value
				matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
			end
		end
	elseif(strcmp(fltr, "IDGrp") == 1)
		for i=1:length(acct_in.entries) %Check each entry
			if (~isempty(find(db_in.entries(i).idgroups == val))) %Check to see if idgroups contains value
				matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
			end
		end
	elseif(strcmp(fltr, "Memo") == 1)
		for i=1:length(acct_in.entries) %Check each entry
			if (contains(acct_in.entries(i).memo, val) == 1)
				matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
			end
		end
	elseif(strcmp(fltr, "Desc") == 1)
		for i=1:length(acct_in.entries) %Check each entry
			if (contains(acct_in.entries(i).desc, val) == 1)
				matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
			end
		end
	elseif(strcmp(fltr, "TimeS") == 1)
		for i=1:length(acct_in.entries) %Check each entry
			if (datetime(acct_in.entries(i).date, 'InputFormat', 'MM/dd/uuuu') >= val)
				matches.entries = [matches.entries, acct_in.entries(i)]; %Add if date occurs on or after start date
			end
		end
	elseif(strcmp(fltr, "TimeE") == 1)
		for i=1:length(acct_in.entries) %Check each entry
			if (datetime(acct_in.entries(i).date, 'InputFormat', 'MM/dd/uuuu') <= val)
				matches.entries = [matches.entries, acct_in.entries(i)]; %Add if date occurs on or before end date
			end
		end
	else
		disp(['Filter "', char(varargin(i)), '" unrecognized. See comments for options.']);
	end
	
	acct_out = matches;

end