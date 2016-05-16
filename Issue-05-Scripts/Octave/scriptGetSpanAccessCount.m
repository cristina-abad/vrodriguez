#! /bin/octave -qf
warning("off");
format long;

args = argv();
filename = args{1};
filename_ds = strcat(filename, "-dataset");
if (length(args) == 1)
	filename_tmp = fopen(filename_ds, "r");
	if(filename_tmp != -1)
		[filename_id, tmp] = fscanf(filename_tmp,"%[^ ] %[^\n]\n","C");
		while(!feof(filename_tmp))
			[filename_id, tmp] = fscanf(filename_tmp,"%[^ ] %[^\n]\n","C");
			filename_id = strcat(filename,"-interarrivals\/it-", filename_id, ".txt");
			interarrivals = 0;
			span = 0;
			f_id = fopen(filename_id, "r");
			while(!feof(f_id))
				[s, tmp] = fscanf(f_id,"%f %[^\n]\n","C");
				interarrivals = interarrivals + 1;
				span = span + s;
			endwhile
			fclose(f_id);
			accessCount = interarrivals + 1;
			printf("%s %.10f %d\n", filename_id, span, accessCount);
		endwhile
		fclose(filename_tmp);
	endif
endif