function h = nth_order(k,n)
%general nth order reaction kinetics rate equation

h = @(w,u) -k*w.^n;

end