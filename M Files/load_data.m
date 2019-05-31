%=========================================================================%
% Loads financial data from a local KV1 database into the workspace for
% analysis with other banking functions.
%
% Arguments:
%	conf_file - Bank configuration file (kv1 format) from which to read database
%	  configuration.
%
%
%
%=========================================================================%
function load_data(conf_file, database_name)

	%----------------------------------------------------------------------
	%- Read configuration file - load all account info except BankEntries -
	
	db = load_kv1bconf(conf_file, 0);
	
	%----------------------------------------------------------------------
	%-------------------------- Load BankEntries --------------------------
	
	for acctnum=1:length(db)
		for filenum=1:length(db(acctnum).files)
			db = load_kv1bank(db(acctnum).files(filenum), db, acctnum, 0);
		end
	end
	
	assignin("base", database_name, db);

end