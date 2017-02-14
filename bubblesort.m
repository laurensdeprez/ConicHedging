function [A,I] = bubblesort(A)
    I = linspace(1,length(A),length(A));
    for ii=1:length(A)
        for k =length(A):-1:(ii+1)
            if (A(k)<A(k-1))
                A = swap(A,k,k-1);
                I = swap(I,k,k-1);
            end
        end
    end
end