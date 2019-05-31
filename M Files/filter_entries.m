%=========================================================================%
% This function is fed a set of arguments specifying filters and returns 
% the matching entries. Pattern: <filter_parameter>, <filter_value>. 
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
function acct_out=filter_entries(acct_in, varargin)

	%If input account is empty, return an empty account
	if (isempty(acct_in))
		acct_out = acct_in;
	end

	%Create the output account
	matches = Account(acct_in.name, [], acct_in.acct_type);
	matches.acct_number = acct_in.acct_number;
	matches.bank_name = acct_in.bank_name;
	matches.filtered = 1;
	
	%Iterate through filter arguments
	for arg=1:2:length(varargin)
		
		%Ensure a value was passed along with the filter name
		if (arg+1 > length(varargin))
			break;
		end
		
		%Define fltr and val b/c varargin returns cell arrays which are
		%inconvenient to use.
		fltr = varargin(arg);
		fltr = fltr{1};
		val = varargin(arg+1);
		val = val{1};
		
		%Deterime filter type
		if (strcmp(fltr,"Category") == 1)
			for i=1:length(acct_in.entries) %Check each entry
				if (~isempty(find(acct_in.entries(i).categories == val))) %Check to see if categories contains value
					matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
				end
			end
		elseif(strcmp(fltr, "IDGrp") == 1)
			for i=1:length(acct_in.entries) %Check each account
				if (~isempty(find(db_in.entries(i).idgroups == val))) %Check to see if idgroups contains value
					matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
				end
			end
		if(strcmp(fltr, "Memo") == 1)
			for i=1:length(acct_in.entries) %Check each account
				if (contains(acct_in.entries(i).memo, val) == 1)
					matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
				end
			end
		elseif(strcmp(fltr, "Desc") == 1)
			for i=1:length(acct_in.entries) %Check each account
				if (contains(acct_in.entries(i).desc, val) == 1)
					matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
				end
			end
% 		elseif(strcmp(fltr, "TimeS") == 1)
% 			for i=1:length(acct_in.entries) %Check each account
% 				if (contains(acct_in.entries(i).desc, val) == 1)
% 					matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
% 				end
% 			end
% 		elseif(strcmp(fltr, "TimeE") == 1)
% 			for i=1:length(acct_in.entries) %Check each account
% 				if (contains(acct_in.entries(i).desc, val) == 1)
% 					matches.entries = [matches.entries, acct_in.entries(i)]; %Add if it matches
% 				end
% 			end
		else
			disp(['Filter "', char(varargin(i)), '" unrecognized. See comments for options.']);
		end
		
	end
	
	acct_out = matches;
	

end