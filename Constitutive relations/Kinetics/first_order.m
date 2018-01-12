function h = first_order(tau)
%First order with one time constants kinetics rate equation that results in
% an exponential decay

h = @(w,u) -w/tau;

end