function [u,m,d] = states_tri_tree(r,s,T)
    u = exp((r-s^2/2)*T+s*sqrt(3*T)); % up state
    m = exp((r-s^2/2)*T);             % middle state
    d = exp((r-s^2/2)*T-s*sqrt(3*T)); % down state
end

