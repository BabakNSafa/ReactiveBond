function psi = ConstructIntHyper(Const_name)
%This function provides the sliding constitutive relations
%used in reactive inelasticity

if strcmp(Const_name,'fiber_exp')
    
    psi = @(par) fiber_exp(par(1),par(2));

elseif strcmp(Const_name,'fiber_exp_Babak')
    
    psi = @(par) fiber_exp_Babak(par(1),par(2));    
    
elseif strcmp(Const_name,'linear_elastic')
    
    psi = @(par) linear_elastic(par);
       
elseif strcmp(Const_name,'exp_lin')

    psi = @(par) exp_lin(par(1),par(2),par(3));    

elseif strcmp(Const_name,'neohookean')

    psi = @(par) neohookean(par(1));

elseif strcmp(Const_name,'mooney_rivlin')

    psi = @(par) mooney_rivlin(par(1),par(2));
    
elseif strcmp(Const_name,'holmes_mow')

    psi = @(par) holmes_mow(par(1),par(2),par(3));
    
else
    error(['The designated constitutive relation',Const_name,' is not defined.'])
    
end

end

