#! /bin/octave -qf

function median = mad(data, axis)
	median = median(abs(data - median(data, axis), axis);
endfunction

args = argv();
traceFilename = "";
try
	
catch
	printf('scriptParseYoutubeTraces.py -f <tracefile>');
	exit(0);
end_try_catch