function [Pi_s,r,Xi,s_flag] = ReactiveSliding(lam,f_s,r_0,Pi_s0)
% Calculates accumulation of sliding
% the flag that sliding occured in this step at the end it will be changed to 1 if sliding occurs
s_flag = 0;
Xi_s= lam;

D_Pi_s = 0;
beta_s = 0;

h_s = Xi_s(end)-r_0;

if (h_s<0)
  	beta_s = 0;
    r = r_0;
elseif h_s == 0 && (lam(end) <= lam(end-1))
    beta_s = 0;
    r = r_0;
else
    beta_s = 1;
    r = Xi_s(end);
    s_flag = 1;
end

D_Pi_s  = beta_s * (f_s(Xi_s(end))-f_s(Xi_s(end-1)));

if D_Pi_s  < 0 
   error('Error in sliding, negative D_Pi_s');
end

Pi_s    = Pi_s0 + D_Pi_s;
Xi = Xi_s(end);

end
