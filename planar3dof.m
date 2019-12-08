

clear L

L(1) = Link([ 0 0 0.5	0	0], 'standard');
L(2) = Link([ 0 0 0.5	0	0], 'standard');
L(3) = Link([ 0 0 0.5	0	0], 'standard');


%syms t1 t2 t3;

%x = [1 0 0]';
%y = [0 1 0]';
%z = [0 0 1]';


%h1 = z;
%h2 = z;
%h3 = z;


%R01 = rotz(t1);
%R12 = rotz(t2);
%R23 = rotz(t3);

%R02 = R01 * R12;
%R03 = R02 * R23;

%p01 = 0;
%p12 = 0.5*x;
%p23 = 0.5*x;
%p3E = 0.5*x;

%p3E_0 = R03 * p3E;
%p2E_0 = R02 * p23 + p3E_0;
%p1E_0 = R01 * p12 + p2E_0;

%JE_0 = [ cross(h1, p1E_0) cross(h2, p2E_0) cross(h3, p3E_0); h1 h2 h3 ];


%
% some useful poses
%
qz = [0 0 0]; % zero angles, L shaped pose
qr = [0 pi/2 -pi]; % ready pose, arm up
qstretch = [0 0 -pi/2];
q0 = [pi -pi/2 -pi/2];


%ex2_func = matlabFunction(JE_0);
%JA = ex2_func(qstretch(1), qstretch(2), qstretch(3));


planar = SerialLink(L);

clear L
planar.name = 'Plannar 3DOF';



% trajetória
syms t real;
xd = [0.25*(1 - cos(pi*t)) 0.25*(2 + sin(pi*t)) 0 0 0 sin(t*pi/24)]';
dxd = diff(xd, t);
matlabFunction(xd, 'File', 'xdFunc');
matlabFunction(dxd,  'File', 'dxdFunc');

% manipulabilidade
syms t1 t2 t3 real;
manip = 0.5*(sin(t2)^2 + sin(t3)^2);
manipParc = [diff(manip, t1); diff(manip, t2); diff(manip, t3)];
matlabFunction(manip, manipParc, 'File', 'manipFunc','Vars', [t1 t2 t3]);


% limite das juntas
tm = [-2*pi -pi/2  -3*pi/2];
tM = [2*pi pi/2 -pi/2];
limJun = 0;
ts = [t1 t2 t3];
n = 3;
for i = 1:n
    limJun = limJun + ((ts(i) - (tM(i) + tm(i))/2)/(tM(i) - tm(i)))^2;
end
limJun = -limJun/(2*n);
limJunParc = [diff(limJun, t1); diff(limJun, t2); diff(limJun, t3)];
matlabFunction(limJun, limJunParc, 'File', 'limJunFunc','Vars', [t1 t2 t3]);

K= 50;
