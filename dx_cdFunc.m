function dx_cd = dx_cdFunc(t)
%DX_CDFUNC
%    DX_CD = DX_CDFUNC(T)

%    This function was generated by the Symbolic Math Toolbox version 7.2.
%    11-Dec-2019 21:41:36

t2 = t.*(3.0./2.0);
dx_cd = [cos(t).*6.0e1+cos(t2).*9.0e1;cos(t+8.0./5.0).*6.0e1+cos(t2+8.0./5.0).*9.0e1];