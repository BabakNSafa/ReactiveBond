function h = second_order(k)
%second order reaction kinetics rate equation

h = @(w,u) -k*w.^2;

end