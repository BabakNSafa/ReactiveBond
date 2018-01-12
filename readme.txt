%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Writtent by Babak N. Safa 2017- All rights reserved
% An implementation of Reactive Inelasticity model for uniaxial  
% deformations
% v1.1.0 - 01/06/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function outputs are
% T_rb = ReactiveBond(t,lam,kinetics,IntHyper) (default)
% T_rb = ReactiveBond(t,lam,kinetics,IntHyper,sliding,damage)
% [T_rb psi_rb] = ReactiveBond(t,lam,kinetics,IntHyper,sliding,damage)
% [T_rb psi_rb w_alpha Pi_s D] = ReactiveBond(t,lam,kinetics,IntHyper,...
%                                               sliding,damage,kinetcs_record)
%                          ... = ReactiveBond(t,lam,kinetics,IntHyper,...
%                                               sliding,damage,kinetcs_record,warning_report)
%
% t                 specifies the time steps
% 
% lam               is the stretrch input, that is synced to "t"
% 
% kinetics          is a structure that indicate the bond kinetics of the bonds
%                   kinetics.name = kinetics rate equaiton (e.g.,'first_order')
%                   kinetics.parameters = kinetics rate equation parameters (e.g., [tau])
% 
% IntHyper          is a structure that specifiecs the intrinsic hyperelasticity
%                   relation
%                   IntHyper.name = constitutive relation name (e.g., 'fiber_exp')
%                   IntHyper.parameters = constitutive relation parameters, refered
%                                  to each constitutive relations specific parame-
%                                  ter (e.g., for 'fiber_exp' parameters are [C3,C2]
% 
% sliding           is a structure that specifiecs existence of sliding and its rule
%                   sliding.flag = (0 or 1) where 0 is no sliding
%                   sliding.name = Sliding_Rule name (e.g., 'sliding_power')
%                   sliding.parameters = Constitutive parameters of sliding (e.g., for
%                   'sliding_power' [c,b,r0_s])
% 
% damage            is a structure that specifiecs existence of damage and its rule
%                   damage.flag = (0 or 1) where 0 is no damage
%                   damage.name = Damage_Rule name (e.g., 'weibull')
%                   damage.parameters = Constitutive parameters of damage (e.g., for
%                   'weibull' [k,l,r0_D])
%                   damage.max = Maximum allowable damage (default is 1)
%                   (optional)
%
% kinetics_record    is a scalar (0 or 1) that indiciate the user wants the
%                    program to deposit the w_alpha as a matrix or not. When is 1 will
%                    return w_alpha as a matrix that has w_alpha for all times and
%                    generations. Uses significant memory. (default 0)
%
% warning_report     is a scalar (0 or 1) that turns the warning reports for
%                    negative bonds, damage and sliding violations.
%                    (default 1)
%
% T_rb      Cauchy (or other types of stress, depending on the IntHyper contitutive relation) stress as a vector
%
% Psi_rb    Free energy as a vector
%
% w_alpha	returns the number fraction of bonds as a vector. (used to be a
%           matrix, which was not memory efficient.)
% 
% Pi_s      a class that returns the sliding results
% Pi_s{1} = Pi_s
% Pi_s{2} = r_s
% Pi_s{3} = Xi_s
% 
% D         a class that returns the damage results
%   D{1} = D
%   D{2} = r_D
%   D{3} = Xi_D
%
%
%Example of a stress relaxation test on formative bonds:
%
%Input
%[t,lam] = StretchProfile(3,100);
%
%Kinetics equation of bonds
%kinetics.name = 'first_order';%type name
%kinetics.parameters = 10;%time constant
%
%
%Intrinsic hyperelasticity
%IntHyper.name = 'neohookean';%type name
%IntHyper.parameters= 100;%modulus
%
%T_f = ReactiveBond(t,lam,kinetics,IntHyper);%stress response as a vector
%
%Plot result
%figure
%plot(t,T_f)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%