function [A,I] = bubblesort(A,varargin)
    p = inputParser;
    addRequired(p,'A');
    validType = {'descend','ascend'};
    defaultType = 'ascend';
    checkType = @(x) any(validatestring(x,validType));
    addOptional(p,'type',defaultType,checkType);
    parse(p,A,varargin{:});
    A = p.Results.A;
    type = p.Results.type;
    I = linspace(1,length(A),length(A));
    for ii=1:length(A)
        for k =length(A):-1:(ii+1)
            switch type
                case 'ascend'
                    if (A(k)<A(k-1))
                        A = swap(A,k,k-1);
                        I = swap(I,k,k-1);
                    end
                case 'descend'
                    if (A(k)>A(k-1))
                        A = swap(A,k,k-1);
                        I = swap(I,k,k-1);
                    end
            end 
        end
    end
end