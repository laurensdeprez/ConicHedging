%% UNDER CONSTRUCTION
function [bid,bids,delta,deltas] = bid_B_S(S_0,q,s,r,T,N,K,option_type,delta_range,delta_precision,dist_type,lambda)
% Monte Carlo 
W = normrnd(0,sqrt(T),[N,1]);
S_T = S_0*exp((q-s^2/2)*T+s*W);
% payoff
f = payoff(S_T,K,option_type);
% distorted probabilities
prob_dist = zeros(1,N);
for i=1:N
    prob_dist(i) = distortion(i/N,dist_type,lambda)- distortion((i-1)/N,dist_type,lambda);
end
% optimize
n = (delta_range(2)-delta_range(1))/delta_precision;
deltas = linspace(delta_range(1),delta_range(2),n); 
bids = zeros(1,n);
for i=1:n
    pi = sort(f + deltas(i)*(S_T - exp(r*T)*S_0));
    bids(i) = exp(-r*T)*prob_dist*pi;
end
[bid,I] = max(bids);
delta = deltas(I);
end

