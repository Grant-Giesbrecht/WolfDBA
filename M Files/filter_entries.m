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
	matches = acct_in;
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
		
		%Filter out non-matching values
		matches = filter_entries_single(matches, fltr, val);
		
	end
	
	acct_out = matches;
	

end