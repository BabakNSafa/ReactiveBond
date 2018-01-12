function fun = ConstructKinetics(Const_name)
%This function provides the bond kinetics constitutive relations
%used in reactive inelasticity

if strcmp(Const_name,'first_order')
    %[tau]
    fun = @(par) first_order(par(1));
    
elseif strcmp(Const_name,'first_order_stretched')
    %[tau,beta]
    fun = @(par) first_order_stretched(par(1),par(2));    

elseif strcmp(Const_name,'kinetics_power')
    %[tau,beta]
    fun = @(par) kinetics_power(par(1),par(2));

elseif strcmp(Const_name,'second_order')
    %[k]
    fun = @(par) second_order(par(1));    

elseif strcmp(Const_name,'nth_order')
    %[k,n]
    fun = @(par) nth_order(par(1),par(2));       
    
elseif strcmp(Const_name,'biexponential')
    %[tau1,tau2]
    fun = @(par) biexponential(par(1),par(2));
else
    error(['The designated kinetics constitutive relation ',Const_name,' is not defined.'])
    
end

end

