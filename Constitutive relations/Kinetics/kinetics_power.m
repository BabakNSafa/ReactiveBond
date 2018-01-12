function h = kinetics_power(tau,beta)
%First order kinetics rate equation that results in an 

h = @(w,u) -(beta/tau)*(1./(1+u/tau)).*w;

end