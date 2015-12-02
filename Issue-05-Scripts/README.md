# EBG - Issue #5
Compile a list of useful scripts to add to our toolbox.

In this issue we will compile a list of programs/scripts to add to our toolbox and discuss them so that we then add them as issues. For example, generate_cdf.sh

#### scriptGetInterarrivalTraces-Animation.py

This script takes the tracefile with three columns like these: 

	1169602866.764024004 0 1890460369ba9e1b2000000002408bcc0407e714badc0779620000002ad6ee00
	1169603076.857360676 0 b0950301da59470520000000000a77acec71750660f8073eb0950301da594700
	1169603076.865715928 0 b0950301da59470520000000028d3897abe44a0100fb07e7b0950301da594700
	1169603076.873845130 0 d5554d0089f4a8052000000001aba9a5e624590cbadc075ed5554d0089f4a800
	...

Obtains the interarrival times and the summary statistics to generate the dataset to be used with the machine learning clustering techniques.

It should be able to read files with a slightly different format like:

	1201639675.424053,READ,HSOw4LO05Ws
	1201639757.082532,READ,1bhOE7xcZyg
	1201639761.780669,READ,3TKi92CP-vc
	1201639762.360242,READ,1bhOE7xcZyg
	...

It also should get the SPAN, the access count number, and the "DELAY" (Delay is the time difference between the first access in the dataset and the fir access of the object) for each object. We currently make this with a different script: scriptGetSpanAccessCount.sh, scriptGetDelayTraces-Animation.py.

There are some additional considerations that should be added to the final script:

- The dataset for clustering includes the object-id and the summary statistics. It should also include the new columns SPAN, and Access Count.
- Summary statistics can only be calculated on "objects" with more than 1 interarrival (> 2 accesses). 
- Some Summary Statistics give "NaN"s and/or warning messages. Objects with NaNs should be excluded from the new dataset, but added to a separate group (see below).
- Besides the dataset for clustering, there should be 2 additional files:
	- Objects with a single access should be included in a separate file, with columns: "object-id, delay". These objects have SPAN = 0, and accessCount = 1
	- Objects with a single interarrival time (2 accesses), and those with "NaN"s values in Summary Statistics should be put together in a separate file, with columns: "object-id, delay, SPAN, AccessCount"
- The fortmat of output files should be as standard as possible.
- Interarrivals should be in miliseconds, instead of seconds.

