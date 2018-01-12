function f_D = ConstructDamage(Const_name)
%This function provides the damage constitutive relations
%used in reactive inelasticity

if strcmp(Const_name,'weibull')
    
    f_D = @(par) weibull(par(1),par(2),par(3));
    
else
    error(['The designated damage constitutive relation',Const_name,' is not defined.'])
    
end

end

