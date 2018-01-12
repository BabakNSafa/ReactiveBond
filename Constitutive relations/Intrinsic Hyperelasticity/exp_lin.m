function psi = exp_lin(C3,C2,l_c)
C1 = (C3*exp(-C2*(l_c - 1)))/C2;

C4 = -(C3*(exp(-C2*(l_c - 1)) + C2*l_c - 1))/C2;

C5 = (C1*(C2 - 1))/C2;

C6 = (C1*(C2 + exp(C2*(l_c - 1)) - C2*l_c - 1))/C2 ...
    - (C3*l_c^2)/2 - C4*l_c;


%the energy expression
psi.E = @(l) ((C1/C2)*((exp(C2*(l - 1)) - C2*l)) + C5)  .* (1<=l) .* (l<l_c)...
            + (((C3*l.^2)/2 + C4*l)+C6) .* (l_c<=l);

%the incompressible isochoric axial Cauchy stress expression
psi.T = @(l) (C1*((exp(C2*(l - 1)) - 1)))  .* (1<=l) .* (l<l_c)...
            + (C3*l + C4) .* (l_c<=l);
    
end