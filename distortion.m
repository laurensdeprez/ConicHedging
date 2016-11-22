function p_dist = distortion(u,label,lambda)
    if (nargin<3)
        lambda = 0.25;
    end 
    if (nargin<2)
        label = 'MinMaxVar';
    end
    %call appropriate distortion function ("NOT" is just for debugging)
    switch label 
        case 'MinVar'
            p_dist = MinVar(u,lambda);
        case 'MaxVar'
            p_dist = MaxVar(u,lambda);
        case 'MinMaxVar'
            p_dist = MinMaxVar(u,lambda);
        case 'MaxMinVar'
            p_dist = MaxVar(u,lambda);
        case 'Wang'
            p_dist = WangTrans(u,lambda);
        case 'NOT' 
            p_dist = u;
        otherwise
            error('label should be one of the following: "MinVar","MaxVar","MinMaxVar","MaxMinVar" or "Wang"')
    end 
end

