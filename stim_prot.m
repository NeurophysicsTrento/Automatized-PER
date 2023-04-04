function stim_prot (s,CS,US,t_CS,t_overlap, t_US)
%CS is controlling the odor valves hence the pin must be high for the time of odor delivery
%US is just the trigger for the feeder which is under control of the
%arduino, and needs just a pulse
off=[0     0     0     0     0    0     0  ];
outputSingleScan(s, CS);
pause(t_CS-t_overlap)%wait wit odor on for t_CS- overlap time

%trigger the feeder keeping the odor valve on
outputSingleScan(s, CS+US);
outputSingleScan(s, CS);%return to the the valve only 
pause(t_overlap)%wait for the time of overlap so the total CS time is complete
outputSingleScan(s, off);%turn off the odor (CS)

pause(t_US-t_overlap)% wait for the feeding time to be over

