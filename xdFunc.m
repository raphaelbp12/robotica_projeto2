function xd = xdFunc(t)
%XDFUNC
%    XD = XDFUNC(T)

%    This function was generated by the Symbolic Math Toolbox version 7.2.
%    09-Dec-2019 01:54:42

t2 = t.*pi;
xd = [cos(t2).*(-1.0./4.0)+1.0./4.0;sin(t2).*(1.0./4.0)+1.0./2.0;0.0;0.0;0.0;sin(t.*pi.*(1.0./2.4e1))];