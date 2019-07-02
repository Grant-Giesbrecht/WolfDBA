%=========================================================================%
% Loads a KV1 file much like load_kv1(), except instead of saving all
% variables to the workspace, it groups the variables by name and saves
% them into Account objects.
%
% Arguments:
%	filename - file to read into the workspace
%
% New Rules:
%	* Must have a string called 'datadir' indicating the directory in which
%	  all data files are stored.
%	* Filenames listed in the 'files' field must not contain spaces
%	* Must include all data shown in the below example
%	* Must go in the example's order (because it triggers a write when
%	  t0files (ie. the basis) is read):
% 		s a0name "USAA_Visa";
% 		s a0type "Credit";
% 		d a0num -1;
% 		s a0bank "USAA FSB";
% 		m<s> a0files ["USAA_Visa2018fmt.kv1"]; //		<----- This will trigger a write operation
%=========================================================================%
function [db_new, datadir]=load_kv1bconf(filename, save_header)

	if ~exist('save_header','var')
		save_header = 1;
	end

	database = [];

	atemp = Account("", [], "");

	write_after = 0;
	
    header = "";
    version = -1;
	database_directory = '';
	
    line_num = 0;

    %Open file
    fid = fopen(filename);
	
    %Read file line by line
    while(~feof(fid))
        sline = fgetl(fid);
        line_num = line_num+1;

		%Skip empty lines
        if (isempty(sline))
            continue;
        end
		
        words = strsplit(sline, {' ', ']', '[', ';', ','}, 'CollapseDelimiters', true);
		for i=1:length(words) %Eliminate any 'words' that contain no characters
			if (isempty(words{i}))
				words(i) = [];
			end
		end
        

        %Convert to character array
        cline = char(sline);

        %Scan through line
        if (cline(1) == '#') %Read header
            if (strcmp(cline(2:end),'HEADER') == 1 )
                while(~feof(fid))
                    sline = fgetl(fid);
                    cline = char(sline);
                    line_num = line_num+1;
                    if (strcmp(cline(1:end), '#HEADER') == 1)
                        break;
                    end
                    header = strcat(header, newline, sline);
                end
                continue;

            elseif (strcmp(cline(2:8), 'VERSION') == 1)
                version = str2double(cline(9:end));
            else
                display(['Failed on line ', num2str(line_num), ' because of an unrecognized macro.']);
            end

        elseif (cline(1) == '/')
            continue;
        elseif (cline(1) == ' ')
            continue;
        else
            if (cline(1) == 's')
				namecharar = char(words(2));
				if (namecharar(end-3:end) == 'name')
					ans_cell = (words(3));
					atemp.name = strrep(ans_cell{1}, '"', '');
				elseif (namecharar(end-3:end) == 'type')
					ans_cell = (words(3));
					atemp.acct_type = strrep(ans_cell{1}, '"', '');
				elseif (namecharar(end-3:end) == 'bank')
					ans_cell = (words(3));
					atemp.bank_name = strrep(ans_cell{1}, '"', '');
				elseif (namecharar == 'datadir')
					ans_cell = strcat(words(3:end));
					database_directory = '';
					for ac=ans_cell
						if (~isempty(database_directory))
							database_directory = [database_directory, ' '];
						end
						database_directory = [database_directory, char(strrep(ac, '"', ''))];
					end
				else
					display(['ERROR: Invalid variable name for banking configuration file.']);
					display(['Failed on line ', num2str(line_num), '.']);
					assignin('base', string(words(2)), strcat(words(3:end)));
				end
            elseif(cline(1) == 'd')
				namecharar = char(words(2));
				if (namecharar(end-2:end) == 'num')
					atemp.acct_number = str2double(words(3));
				else
					display(['ERROR: Invalid variable name for banking configuration file.']);
					display(['Failed on line ', num2str(line_num), '.']);
					assignin('base', string(words(2)), str2double(words(3)));
				end
            elseif(cline(1) == 'b')
				display(['ERROR: Invalid data for banking database. No boolean variables expected']);
				display(['Failed on line ', num2str(line_num), '.']);
                assignin('base', string(words(2)), logical(lower((words(3)))));
            elseif(cline(1) == 'm')
                if (cline(3) == 'd')
					display(['ERROR: Invalid data for banking database. No m<d> variables expected']);
					display(['Failed on line ', num2str(line_num), '.']);
                    assignin('base', string(words(2)), str2double(words(3:end)));
                elseif(cline(3) == 's')
					namecharar = char(words(2));
					if (namecharar(end-4:end) == 'files')
% 						atemp.files = words(3:end);
						ans_cells = words(3:end);
						atemp.files = [];
						for i=1:length(ans_cells)
							atemp.files = [atemp.files, string(strrep(ans_cells{i},'"',''))];
						end
						write_after = 1;
						
					else
						display(['ERROR: Invalid variable name for banking database.']);
						display(['Failed on line ', num2str(line_num), '.']);
						assignin('base', string(words(2)), str2double(words(3)));
					end
%                     assignin('base', string(words(2)), words(3:end));
                elseif(cline(3) == 'b')
					display(['ERROR: Invalid data for banking database. No m<b> variables expected']);
					display(['Failed on line ', num2str(line_num), '.']);
                    assignin('base', string(words(2)), logical(lower(words(3:end))));
                else
                    disp(['Failed on line ', num2str(line_num)]);
                end
            else
                disp(['Failed on line ', num2str(line_num)]);
                return
            end
		end
		
		if (write_after == 1)
			database = [database, atemp];
			write_after = 0;
		end
		
	end

	cfn = char(filename);
	j = find(cfn == '/', 1', 'last');
	k = find(cfn == '.', 1, 'last');
	fn_start = cfn(j+1:k(1)-1);
	if (save_header)
		assignin('base', [fn_start, '_header'], (header));
	end
    db_new = database;
	datadir = database_directory;
    
end

%=========================================================================%
%========================= DATABASE STRUCTURE ============================%
%=========================================================================%
%
%			********************************************
%			**** THIS GRAPHIC IS NO LONGER ACCURATE! ***
%			********************************************
%
% +----------------+
% |PARENT DIRECTORY|
% +----------------+-----------------------------------------------------
%		|				|								|				|
%		V				V								V				V
%  +-----------+    +-----------+                  +-------------+	  * ggiesbrecht.kv1 (KV1 configuration file for where to find accounts)
%  | ACCOUNT 1 |    | ACCOUNT 2 |       ...        | ACCOUNT 'N' |
%  +-----------+    +-----------+                  +-------------+
%		|					 |                 			 |
%		V					 V							 V
%	* USAA_VisaConf.KV1		...			    			...		(fills 'Account' obj)
%	 				  			
%	* USAA_Visa2015.KV1		...				  			...		(fills many 'BankEntry' objs)
%	 
%	* USAA_Visa2016.KV1		...				  			...		(fills many 'BankEntry' objs)
%	 
%
%
%=========================================================================%




%=========================================================================%
%==================== WORKSPACE DATABASE STRUCTURE =======================%
%=========================================================================%
% This crude ASCII graphic describes how the database is saved to the
% MATLAB workspace.
% 
%
%  type: "1xn Account"		 type: "Account"			 type: "BankEntry"
% ---------------------		---------------				----------------
%  name ex: db				 name ex: db(2)				 name ex: db(2).entries(5)
%
%		+--+					name = "xxxx"				memo = "xxxx"
%		|  | -> ...				acct_type = "xxxx"			date = "MM/DD/YYYY"
%		+--+					...							balance = x
%       |  | ---------------->  entries = +--+				basis = x
%		+--+							  |  | --------->	value = x
%		|  | -> ...						  +--+				description = "xxxx"
%		...								  |  | -> ...		categories = ["cat1", "cat2", ...]
%		|  | -> ...						  ...				idg = ["Vacation", "DC Trip", "Project X"]
%		+--+							  +--+
%
%=========================================================================%



