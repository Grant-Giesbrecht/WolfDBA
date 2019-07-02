%=========================================================================%
% This function merges elements in the input arrays that share common 'x'
% values.
%
% Arguments: 
% 	dates - If two consecutive elements match, the cells of this index in
% 	'dates' and all arrays in 'vals' will be merged.
%	varargin - Values to merge along with 'dates'.
%
% Returns:
%	[merged_dates, merged_vales]
%=========================================================================%
function [md, mv] = merge_dates(dates, vals)

	%Find unique values
	[unique_vals, ind] = unique(dates);
	ind = sort(ind); %Ensure ascending order
	
	for i=1:length(ind)
		dout(i) = dates(ind(i));
		if (i+1 <= length(ind))
			vout(i) = sum(vals( ind(i) : ind(i+1)-1 ));
		else
			vout(i) = sum(vals( ind(i) : end ));
		end
	end

	if (~exist('dout', 'var'))
		dout = [];
	end
	
	if (~exist('vout', 'var'))
		vout = [];
	end
	
	md = dout;
	mv = vout;
end