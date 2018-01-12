function f_s= sliding_power(c,b,r0)
% the power law for sliding with three model parameters.

    f_s = @(Xi_s) c*((Xi_s-r0)).^b .* ((Xi_s-r0)>0);

end