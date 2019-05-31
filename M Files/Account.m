%=========================================================================%
% This class represents a single account such as a checking account,
% savings account, credit card, or investement portfolio.
%
% Fields:
%	name - Name of account (eg. USAA Visa)
%	entries - List of 'BankEntry' objects, one for each transaction/event.
%	acct_type - The type of account:
%		* Checking	* Savings	* Credit	* Investment
%	acct_number - The last few digits of the account number (Optional)
%	bank_name - The name of the bank holding the account (Optional)
%	filtered - Indicates whether or not some entries have been removed by a
%		filtering function. 0=not filtered, 1=filtered.
%
%=========================================================================%
classdef Account
	properties
		name = ""; %Name of account
		entries = [] %Contains all entries (ie. transactions) for the account. Contains 'BankEntry' objects.
		acct_type = ""; %Type of account (Checking, savings, credit, investment)
		acct_number = -1; %Last digits of account number (Optional)
		bank_name = "Unspecified"; %Name of bank with account (Optional)
		filtered = 0; %Indicates if the account has been filtered.
		files = []; %Array of file names of the files containing the account's data
	end
	methods
		function obj = Account(nam, ent, typ)
			obj.name = nam;
			obj.entries = ent;
			obj.acct_type = typ;
		end
	end
end