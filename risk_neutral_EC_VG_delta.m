% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% risk neutral pricing delta of european call under VG using fft
function [price,KK,C] = risk_neutral_EC_VG_delta(S_0,s,v,th,r,T,K)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'s',@ispositive);
addRequired(p,'v',@ispositive);
addRequired(p,'th',@isnumeric);
addRequired(p,'r',@ispositive);
addRequired(p,'T',@ispositive);
addRequired(p,'K');
parse(p,S_0,s,v,th,r,T,K);
S_0 = p.Results.S_0;
s = p.Results.s;
v = p.Results.v;
th = p.Results.th;
r = p.Results.r;
T = p.Results.T;
K = p.Results.K;

omega= 1/v*log(1-s^2*v/2-th*v);
[C_VG,G_VG,M_VG] = VG_param(s,v,th);
phi = @(u)(exp(1i*u*(log(S_0)+(r + omega)*T)).*char_function_VG(u,C_VG,G_VG,M_VG).^T);

N = 4096;
a = 1/4*(sqrt(th^2/s^4+2/s^2/v)-th/s^2-1);
eta = 0.25;
lambda = 2*pi/N/eta;
b = lambda*N/2;
k = (-b):lambda:(b-lambda);
KK = exp(k);
vv = 0:eta:(N-1)*eta;
sw =(3+(-1).^(1:1:N));
sw(1) = 1;
sw = sw/3;
rho = exp(-r*T)*phi(vv-(a+1)*1i)./(S_0*(a+1i*vv));
C = exp(-a*k)/pi.*real(fft(rho.*exp(1i*vv*b)*eta.*sw));
%price
price = spline(KK,C,K);
end
