function psi = holmes_mow(E,v,C0)
% This is a simple Holmes-Mow material for incompressible uniaxial
% tension
lambda = E.*v./((1+v).*(1-2.*v));
mu = E./(2.*(1+v));

C2 = 1./C0.*(lambda./4);%lamda = 4*C2*C0
C1 = mu./(2.*C0)-C2;%mu = 2(C1+C2)*C0
%the  energy expression
psi.E = @(l) C0*(exp(C1*(2./l + l.^2 - 3) - C2*(1./l.^2 - (2./l + l.^2).^2/2 + l.^4/2 + 3)) - 1);

%the Cauchy stress expression
psi.T = @(l) 2.*C0.*exp(((l - 1).^2.*(C2 + 2.*C1.*l + 2.*C2.*l + C1.*l.^2))./l.^2).*(l - 1).*(C1 + 2.*C2 + C1.*l);

end