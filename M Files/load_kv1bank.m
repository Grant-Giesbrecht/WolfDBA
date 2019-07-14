%=========================================================================%
% Loads a KV1 file much like load_kv1(), except instead of saving all
% variables to the workspace, it groups the variables by name and saves
% them into BankEntry objects.
%
% Arguments:
%	filename - file to read into the workspace
%	database - database struct in the workspace (to which to add (in returned variable))
%	account - account in the database to which to add the BankEntries
%
% New Rules:
%	*
%	* Must include all data shown in the below example
%	* Must go in the example's order (because it triggers a write when
%	  t0bas (ie. the basis) is read):
% 		m<s> t0dd ["04/28/2019", "JAMECO/JIMPAK ELECTRONICS650-5928097 CA", ""];
% 		m<s> t0cats ["ELECTRONICS"];
% 		m<s> t0idg ["California Adventure"];
% 		d t0val -24.63;
% 		d t0bal 1000;
% 		d t0bas 1000;		//		<----- This will trigger a write operation
%=========================================================================%
function db_new=load_kv1bank(filename, database, account, save_header)

	if ~exist('save_header','var')
		save_header = 1;
	end

	betemp = BankEntry("", "", 0, 0, 0, "00/00/0000", [""], [""]);

	write_after = 0;
	
    header = "";
    version = -1;

    line_num = 0;

    %Open file
    [fid,errmsg] = fopen(filename);
	if (fid < 0) %Quit if can't open file
		disp(['Failed to open file "', char(filename), '".']);
		disp(errmsg);
		db_new = database;
		return;
	end
	
	
    %Read file line by line
    while(~feof(fid))
        sline = fgetl(fid);
        line_num = line_num+1;

        words = strsplit(sline, {' ', ']', '[', ';', ','}, 'CollapseDelimiters', true);
		strwords = strsplit(sline, {'"'}, 'CollapseDelimiters', true);

        %Skip empty lines
        if (isempty(sline))
            continue;
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
				display(['ERROR: Invalid data for banking database. No string variables expected']);
				display(['Failed on line ', num2str(line_num), '.']);
                assignin('base', string(words(2)), strcat(words(3:end)));
            elseif(cline(1) == 'd')
				namecharar = char(words(2));
				if (namecharar(end-2:end) == 'bas')
					betemp.basis = str2double(words(3));
					write_after = 1;
				elseif (namecharar(end-2:end) == 'bal')
					betemp.balance = str2double(words(3));
				elseif (namecharar(end-2:end) == 'val')
					betemp.value = str2double(words(3));
				else
					display(['ERROR: Invalid variable name for banking database.']);
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
					if (namecharar(end-2:end) == 'idg')
						cells = strrep(words(3:end),'"','');
						betemp.idgroups = [];
						for c=1:length(cells)
							if (cells{c} ~= "")
								betemp.idgruops = [betemp.idgroups, cells{c}];
							end
						end
					elseif (namecharar(end-3:end) == 'cats')
						cells = strrep(words(3:end),'"','');
						betemp.categories = [];
						for c=1:length(cells)
							if (cells{c} ~= "")
								betemp.categories = [betemp.categories, cells{c}];
							end
						end
					elseif (namecharar(end-1:end) == 'dd')
						temp = strrep(words(3),'"','');
						betemp.date = temp{1};
						temp = strrep(strwords(4),'"','');
						betemp.memo = temp{1};
						if (length(strwords) > 6)
							temp = strrep(strwords(6),'"','');
							betemp.desc = temp{1};
						else
							betemp.desc = "";
						end
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
			database(account).entries = [database(account).entries, betemp];
			write_after = 0;
		end
		
	end

	cfn = char(filename);
	k = find(cfn == '.');
	fn_start = cfn(1:k(1)-1);
	if (save_header)
		assignin('base', [fn_start, '_header'], (header));
	end
    db_new = database;
    
end

%=========================================================================%
%========================= DATABASE STRUCTURE ============================%
%=========================================================================%
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



