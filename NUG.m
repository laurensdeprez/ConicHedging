% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

% Generates a non homogeneous grid ss
function [vv,ss] = NUG(pv,uv,bv,var,N)
p = inputParser;
addRequired(p,'pv');
addRequired(p,'uv');
addRequired(p,'bv');
addRequired(p,'var');
addRequired(p,'N');
parse(p,pv,uv,bv,var,N);

pv = p.Results.pv;
uv = p.Results.uv;
bv = p.Results.bv;
var = p.Results.var;
N = p.Results.N;
s=log(pv);
b=log(uv);
a=log(bv);
gg=var;
g1=gg;
g2=(b-s)/(s-a)*g1;
c1=asinh((a-s)./g1);
c2=asinh((b-s)./g2);
xv=zeros(N/2,1);
yv=zeros(N/2,1);
for ik=1:N/2
    x=s+g1.*sinh(c1.*(1-(ik-1)./(N/2-1)));
    y=s+g2.*sinh(c2.*2.*ik./N);
    xv(ik)=x;
    yv(ik)=y;
end
vv=[xv' yv']';
ss=exp(vv);
return