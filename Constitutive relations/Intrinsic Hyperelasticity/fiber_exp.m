function psi= fiber_exp(C3,C4)
% The fiber exponential with two model parameters for intrinsic
% hyperelasticity

%the energy expression
psi.E = @(l) C3*(exp(C4*(l.^2 - 1).^2) - 1).* (l>1);

%the  Cauchy stress expression for isochoric deformation
psi.T = @(l) 2*C3*C4*l.^2.*exp(C4*(l.^2 - 1).^2).*(2*l.^2 - 2) .* (l>1);
end