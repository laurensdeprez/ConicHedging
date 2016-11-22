function [bid,bids,delta,deltas] = bid_bin_tree(S_0,u,d,r,T,K,type,delta_range,delta_precision)
% risk neutral up probability
p = (exp(r*T)-d)/(u-d);    
if ((p>1)||(p<0))
    error('choose up and down state differently w.r.t. the interest')
end
% payouts
f_u = payoff(u*S_0,K,type);         % option payout up
f_d = payoff(d*S_0,K,type);         % option payout down
% optimize
n = (delta_range(2)-delta_range(1))/delta_precision;
deltas = linspace(delta_range(1),delta_range(2),n); 
bids = zeros(1,n);
for i=1:n
    pi_u = f_u + deltas(i)*(u - exp(r*T))*S_0;
    pi_d = f_d + deltas(i)*(d - exp(r*T))*S_0;
    if (pi_u >= pi_d)
        bids(i) = exp(-r*T)*((1-distortion(1-p))*pi_u+distortion(1-p)*pi_d);
    else
        bids(i) = exp(-r*T)*(distortion(p)*pi_u+(1-distortion(p))*pi_d);
    end 
end
[bid,i] = max(bids);
delta = deltas(i);
end

