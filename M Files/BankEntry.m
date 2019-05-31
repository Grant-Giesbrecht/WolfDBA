%=========================================================================%
% This class represents a single entry in the banking database - a single 
% transaction or a single data point. 
%
% Fields:
%	memo - Transaction memo provided by bank
%	desc - Transaction description provided by user (optional)
%	value - Amount of funds moved in transaction
%	balance - Net worth of account after this transaction occured
%	basis - Amound of funds added by owner to account (ie. balance -
%     interest)
%	date - Date transaction occurred (MM/DD/YYYY)
%	categories - Array of strings of category names (eg. Fuel, food,
%     entertainment, lab eq.)
%	idgroups - Array of strings of listing ID Groups the entry belongs to.
%     An ID group is an easy way to identify many related transaction, for
%     example all of the transaction from one trip or for one project.
%
%=========================================================================%
classdef BankEntry
	properties
		memo = "";
		desc = "";
		value = 0;
		balance = 0;
		basis = 0;
		date = "";
		categories = [""];
		idgroups = [""];
	end
	
	methods
		function obj = BankEntry(mem, des, val, bal, bas, dat, cat, idg)
			obj.memo = mem;
			obj.desc = des;
			obj.value = val;
			obj.date = dat;
			obj.categories = cat;
			obj.balance = bal;
			obj.basis = bas;
			obj.idgroups = idg;
		end
	end
end