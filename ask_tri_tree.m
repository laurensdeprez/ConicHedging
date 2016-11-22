%% UNDER CONSTRUCTION: seems oké
function [ask,asks,delta,deltas] = ask_tri_tree(S_0,s,r,T,K,option,delta_range,delta_precision)
%states
u = exp((r-s^2/2)*T+s*sqrt(3*T)); % up state
m = exp((r-s^2/2)*T);             % middle state
d = exp((r-s^2/2)*T-s*sqrt(3*T)); % down state
%payouts
f_u = payoff(u*S_0,K,option);   % option payout up
f_m = payoff(m*S_0,K,option);   % option payout middle
f_d = payoff(d*S_0,K,option);   % option payout down
%jump probabilities
p_u = 1/6;                        % jump up 
p_m = 2/3;                        % jump middle
p_d = 1/6;                        % jump down
%optimize    
n = (delta_range(2)-delta_range(1))/delta_precision;
deltas = linspace(delta_range(1),delta_range(2),n); 
asks = zeros(1,n);
for i=1:n
    pi_u = f_u + deltas(i)*(u - exp(r*T))*S_0;
    pi_m = f_m + deltas(i)*(m - exp(r*T))*S_0;
    pi_d = f_d + deltas(i)*(d - exp(r*T))*S_0;
    check = [(pi_u>=pi_m),(pi_u>=pi_d),(pi_m>=pi_d)];
    % can this be programmed cleaner?
    check = string(double(check));
    check = strcat(check(1),check(2),check(3));
    switch check
        case '111'
            p_ud = distortion(p_u) ;
            p_md = distortion(p_u+p_m)-distortion(p_u);
            p_dd = 1-distortion(p_u+p_m);
        case '110'
            p_ud = distortion(p_u);
            p_dd = distortion(p_u+p_d)-distortion(p_u);
            p_md = 1-distortion(p_u+p_d);
        case '101'
            error('impossible due to transitivity in bid_tri_tree')
        case '011'
            p_md = distortion(p_m);
            p_ud = distortion(p_u+p_m)-distortion(p_m);
            p_dd = 1-distortion(p_u+p_m);
        case '100'
            p_dd = distortion(p_d);
            p_ud = distortion(p_u+p_d)-distortion(p_d);
            p_md = 1-distortion(p_u+p_d);
        case '010'
            error('impossible due to transitivity in bid_tri_tree')
        case '001'
            p_md = distortion(p_m);
            p_dd = distortion(p_m+p_d)-distortion(p_m);
            p_ud = 1-distortion(p_m+p_d);
        case '000'
            p_dd = distortion(p_d);
            p_md = distortion(p_m+p_d)-distortion(p_d);
            p_ud = 1-distortion(p_m+p_d);
        otherwise
            error('something went wrong in bid_tri_tree')
    end 
    asks(i) = exp(-r*T)*(p_ud*pi_u+p_md*pi_m+p_dd*pi_d);
end
[ask,i] = min(asks);
delta = deltas(i);
end

