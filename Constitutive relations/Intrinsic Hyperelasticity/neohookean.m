function psi = neohookean(C1)
% This is a simple neoHookean material for incompressible uniaxial
% tension
%the energy expression
psi.E = @(l) C1*(2./l + l.^2 - 3);

%the incompressible isochoric axial Cauchy stress expression
psi.T = @(l) (2*C1*(l.^3 - 1))./l;

end