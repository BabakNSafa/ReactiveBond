%Example of a stress relaxation test on formative bonds:
%
%Input
[t,lam] = StretchProfile(3,100);

% Kinetics equation of bonds
kinetics.name = 'first_order';%type name
kinetics.parameters = 10;%time constant


% Intrinsic hyperelasticity
IntHyper.name = 'neohookean';%type name
IntHyper.parameters= 100;%modulus

T_f = ReactiveBond(t,lam,kinetics,IntHyper);%stress response as a vector

%outpuut
figure
plot(t,T_f)
ylabel('Stress')
xlabel('Time')