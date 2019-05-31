%=========================================================================%
% This function is fed a set of arguments specifying filters and returns 
% the matching accounts. Pattern: <filter_parameter>, <filter_value>. 
%
%	ie. database (array of 'Account's) --> single 'Account'
%
% Filter options:
%	Name
%	Type
%
% Arguments: 
%	
%
%
%=========================================================================%
function accts_out=filter_acct(db_in, varargin)

	%If input database is empty, return an empty account
	if (isempty(db_in))
		accts_out = db_in;
	end

	matches = [];

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
		if (strcmp(fltr,"Name") == 1)
			for i=1:length(db_in) %Check each account
				if (strcmp(db_in(i).name, val) == 1)
					matches = [matches, db_in(i)]; %Add if it matches
				end
			end
		elseif(strcmp(fltr, "Type") == 1)
			for i=1:length(db_in) %Check each account
				if (strcmp(db_in(i).acct_type, val) == 1)
					matches = [matches, db_in(i)]; %Add if it matches
				end
			end
		elseif(strcmp(fltr, "Bank") == 1)
			for i=1:length(db_in) %Check each account
				if (strcmp(db_in(i).bank_name, val) == 1)
					matches = [matches, db_in(i)]; %Add if it matches
				end
			end
		else
			disp(['Filter "', char(varargin(i)), '" unrecognized. See comments for options.']);
		end
		
	end
	
	accts_out = matches;
	

end

