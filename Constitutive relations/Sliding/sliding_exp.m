function f_s= sliding_exp(k,l,r0)
% the modified Weibul (sliding exponential) with three model parameters.

    f_s = @(Xi_s) (Xi_s-1) .* (1-exp(-((Xi_s-r0)/(l-1)).^k)) .* ((Xi_s-r0)>0);

end