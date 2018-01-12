function psi= fiber_exp_simple(C1,C2)
%the energy expression
psi.E = @(l) (C1/C2)*(exp(C2*(l-1))-C2*(l-1)-1).* (l>1);

%the  Cauchy stress expression for isochoric deformation
psi.T = @(l) C1*(exp(C2*(l-1))-1) .* (l>1);


end