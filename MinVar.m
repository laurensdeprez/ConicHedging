%% MINVAR distortion function
function p_dist = MinVar(u,lambda)
    if (nargin>2)
        error('function requires at most two argument')
    end
    if (nargin<2)
        lambda = 0.25;
    end 
    if (nargin<1)
        error('function requires at least one argument')
    end 
    if (lambda<0)
        error('second argument should be positive')
    end 
    if (min(u)<0)||(max(u)>1)
        error('first argument should be between 0 and 1')
    end
    p_dist = 1-(1-u).^(1+lambda);
end 