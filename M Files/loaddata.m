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
function load_data(conf_file)

	%Read KV1s
	db = [Account("Test Account", [], "Checking"), Account("Test 2", [], "Savings")];
	db = load_kv1bank("demo2019.KV1", db, 1);
	
	assignin("base", "db", db);
	
	%Format data
	
	
	%Save to workspace
% 	assignin("base", "var_name", "var_value");

end