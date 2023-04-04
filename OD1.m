function OD1 (s,time)
off=[0     0     0     0     0     0     0  ];
next=[1     0     1     0     0    0     0  ];
outputSingleScan(s, next);
pause(time)
outputSingleScan(s, off);%sw
end