
d1 = 0*(0.1564 + 0.1284);
d2 = 0.0054 + 0.0064;
d3 = 0.2104 + 0.2104;
d4 = 0.0064 + 0.0064;
d5 = 0.2084 + 0.1059;
d7 = 0*(0.1059 + 0.0615);

%All link lengths and offsets are measured in m
clear links
%            theta    d           a       alpha
links = [
	    Link([0        -d1           0       pi/2 0 ], 'standard')
		Link([0        0           0       pi/2 0 pi], 'standard')
		Link([0        -d3           0       pi/2 0 pi], 'standard')
		Link([0        0           0       pi/2 0 pi], 'standard')
		Link([0        -d5           0       pi/2 0 pi], 'standard')
		Link([0        0             0       pi/2 0 pi], 'standard')
        Link([0        -d7            0       pi   0 pi], 'standard')

	];


gen3=SerialLink(links, 'name', 'Kinova Gen3');
gen3.base=trotx(pi);

%gen3.plotopt = {'workspace', [-1.5 1.5 -1.5 1.5 -1 2], 'jvec'};
%gen3.plotopt = {'jvec'};
%gen3.plotopt = {'workspace', [-4 4 -4 4 -4 4], 'jvec', 'jointdiam' 2};

qz = [0 0 0 0 0 0 0];
qd = [0 41.4 0 90 0 -41.4 0]*pi/180;
qr = [0 0  0 90 180 0 0]*pi/180;

