% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

clear;
close all;

%% Applied conic finance: Example 5.3
N = 10;                     %number of simulation runs
K = 100;                    %strike
T = 1;                      %maturity
n = 100;                    %number of timesteps
t = linspace(0,T,n);        %time matrix
t = repmat(t,N,1);
r = 0.01;                   %risk free interest
mu = 0.05;                  %trend 
sigma = 0.30;               %volatility
stock_0 = K;                %initial stock price ATM option
dW = normrnd(0,sqrt(T/n),[N,n-1]);%brownian motion increments
W = cumsum(dW,2);           %standard brownian motion
W = cat(2,zeros(N,1),W);
figure()
for i=1:N
    plot(t(i,:),W(i,:))
    hold on
end 
title('standard brownian motion (mu = 0.05, sigma = 0.40)')
hold off
%geometric brownian motion stocks
stocks = stock_0*exp((mu-sigma^2/2)*t+sigma*W);
figure()
for i=1:N
    plot(t(i,:),stocks(i,:))
    hold on
end
title('geometrical brownian motion (mu = 0.05, sigma = 0.40)')
hold off
%pay off function
pay_off = max(0,stocks(:,n)-K);
pay_off_sort = sort(pay_off);
prob = 1/N*ones(1,N);
%cdf
cdf = cumsum(prob);
figure()
scatter(pay_off_sort,cdf)
hold on
%distorted cdf
lambda = 0.25; %distortion param.
dist_cdf = MinMaxVar(cumsum(prob),lambda);
scatter(pay_off_sort,dist_cdf,'r')
%axis([0,max(pay_off),0,1])
hold off
%distorted prob 
prob_bid = zeros(1,N);
for i=1:N
    prob_bid(i) = distortion(i/N,'MinMaxVar',lambda)- distortion((i-1)/N,'MinMaxVar',lambda);
end
prob_ask = zeros(1,N);
for i=1:N
    prob_ask(i) = distortion((N-i+1)/N,'MinMaxVar',lambda)- distortion((N-i)/N,'MinMaxVar',lambda);
end
%price
P = exp(-r*T)*mean(pay_off);
P_bid = exp(-r*T)*sum(prob_bid*pay_off_sort);
P_ask = exp(-r*T)*sum(prob_ask*pay_off_sort);
