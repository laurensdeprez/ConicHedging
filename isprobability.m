function bool = isprobability(u)
    p = inputParser;
    addRequired(p,'u',@isnumeric);
    parse(p,u);
    if (min(p.Results.u) >= 0) && (max(p.Results.u)<= 1)
        bool = true;
    else
        bool = false;
    end 
end

