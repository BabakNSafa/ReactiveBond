function [D,r,Xi] = ReactiveDamage(lam,f_D,r_0,D_0)
% Calculates accumulation of damage
% the flag that damage occured in this step at the end it will be changed to 1 if sliding occurs

Xi_D= lam;

D_D = 0;
beta_D = 0;

h_D = Xi_D(end)-r_0;

if (h_D < 0)
   beta_D = 0;
   r = r_0;
elseif (h_D == 0) && (Xi_D(end) <= Xi_D(end-1))
   beta_D = 0;
   r = r_0;
else
   beta_D = 1;
   r = Xi_D(end);
end

D_D =   beta_D * (f_D(Xi_D(end))-f_D(Xi_D(end-1)));
D   =   D_0 + D_D;

Xi = Xi_D(end);
end
