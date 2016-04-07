#! /bin/octave -qf
args = argv();
if (length(args) == 1)
	filename = args{1};
	while(!feof(filename))
		[filename_id, tmp] = fscanf(filename,"%[^ ] %[^\n]\n","C");
		filename_id = strcat("Animation-traces/it-", filename_id, ".txt");
		interarrivals = 0;
		span = 0;
		while(!feof(filename_id))
			[s, tmp] = fscanf(filename,"%f %[^\n]\n","C");
			interarrivals = interarrivals + 1;
			span = span + s;
		endwhile
		accessCount = interarrivals + 1;
		printf("%s %.10f %d\n", filename_id, span, accessCount);
	endwhile
else
	printf("Need 1 parameter\n");
endif