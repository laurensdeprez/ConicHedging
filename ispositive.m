% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% 
function bool = ispositive(u)
    p = inputParser;
    addRequired(p,'u',@isnumeric);
    parse(p,u);
    
    if min(p.Results.u) >= 0
        bool = true;
    else
        bool = false;
    end 
end

