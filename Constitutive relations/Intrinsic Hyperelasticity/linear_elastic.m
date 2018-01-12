function psi = linear_elastic(E)
%the zeroth order derivative of energy expression.  Only valid for
%small strains.

psi.E = @(l) 1/2 * E * (l-1).^2;

%the first order derivative of energy expression
psi.T = @(l) E * (l-1);

end