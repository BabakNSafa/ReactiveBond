function f_D = weibull(k,l,r0)
% The Weibull CDF function with three model parameters for damage rule

f_D = @(Xi_D) (1-exp(-((Xi_D-r0)/(l-1)).^k)).*((Xi_D-r0)>0);

end