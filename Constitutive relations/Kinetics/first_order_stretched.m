function h = first_order_stretched(tau,beta)
%First order with stretch kinetics rate equation w = exp(-(t^beta)/tau)

h = @(w,u) -(beta/tau)*u.^(beta-1).*w;

end