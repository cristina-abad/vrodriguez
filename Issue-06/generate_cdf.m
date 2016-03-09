#! /bin/octave -qf
args = argv();
if (length(args)>=1 & length(args) <= 2)
	delimiter = " ";
	if (length(args) == 2)
    delimiter = args{2};
	endif
	FNAME = args{1};
	fid = fopen(FNAME, "r");
	if(is_valid_file_id(fid))
		# First option
		# [A,B] = textread(FNAME, "%f %f\n");
		# c = sum(B);
		s = 0;
		while(!feof(fid))
			[A,B] = fscanf(fid,"%f %d","C");
			s = s + B;
		endwhile
		fclose(fid);
		fid = fopen(FNAME, "r");
		c = 0;
		while(!feof(fid))
			[A,B] = fscanf(fid,"%f %d","C");
			p = B / s;
			c = c + p;
			printf("%f %d %f %f\n", A, B, p, c);
		endwhile
		fclose(fid);
	else
		printf("No such file or directory\n");
	endif
else 
  printf("amount of parameters: 2\n");
  printf("usage: generate_sdf.py <inputfile> <delimiter>\n");
  exit;
endif