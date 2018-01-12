function f_s = ConstrucSliding(Const_name)
%This function provides the sliding constitutive relations
%used in reactive inelasticity

if strcmp(Const_name,'sliding_power')
    
    f_s = @(par) sliding_power(par(1),par(2),par(3));
    
elseif strcmp(Const_name,'sliding_exp')
    
    f_s = @(par) sliding_exp(par(1),par(2),par(3));    
    
else
    error(['The designated sliding constitutive relation',Const_name,' is not defined.'])
    
end

end

