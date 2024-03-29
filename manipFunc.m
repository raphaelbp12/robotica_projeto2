function [manip,manipParc] = manipFunc(t1,t2,t3)
%MANIPFUNC
%    [MANIP,MANIPPARC] = MANIPFUNC(T1,T2,T3)

%    This function was generated by the Symbolic Math Toolbox version 7.2.
%    11-Dec-2019 03:42:11

t4 = sin(t2);
t5 = sin(t3);
manip = t4.^2.*(1.0./2.0)+t5.^2.*(1.0./2.0);
if nargout > 1
    manipParc = [0.0;t4.*cos(t2);t5.*cos(t3)];
end
