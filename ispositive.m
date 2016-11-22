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

