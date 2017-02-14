function A = swap(A,x,y)
    tmp = A(x);
    A(x) = A(y);
    A(y) = tmp;
end

    