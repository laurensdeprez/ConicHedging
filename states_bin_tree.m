function [u,d] = states_bin_tree(s,T)
    u = exp(s*sqrt(T)); % up state
    d = exp(-s*sqrt(T)); % down state
end

