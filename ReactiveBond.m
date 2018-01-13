function [T_rb,varargout] = ReactiveBond(t,lam,kinetics,varargin)
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
% T_rb      Cauchy (or other types of stress, depending on the IntHyper contitutive relation) stress
%           as a vector
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

%% Input arguments
% Defaults
sliding.flag = 0;
damage.flag = 0;
kinetics_record = 0;
warning_report = 1;
D_max = 1;

%add the constitutive relations folder
addpath(genpath('Constitutive relations'));

nInputs = nargin;
nOutputs = nargout;

if nInputs == 4
    IntHyper    = varargin{1};
elseif nInputs == 5
    IntHyper    = varargin{1};
    sliding     = varargin{2};
elseif nInputs == 6
    IntHyper    = varargin{1};
    sliding     = varargin{2};
    damage      = varargin{3};
elseif nInputs == 7
    IntHyper    = varargin{1};
    sliding     = varargin{2};
    damage      = varargin{3};
    kinetics_record = varargin{4};    
elseif nInputs == 8
    IntHyper    = varargin{1};
    sliding     = varargin{2};
    damage      = varargin{3};
    kinetics_record = varargin{4};
    warning_report  = varargin{5};    

elseif nInputs > 8
    error('Too many input arguments')
end
%% Preallocation of memory
n = length(lam);
T_rb_nd = zeros(n,1);
Psi_rb_nd = zeros(n,1);
T_rb = zeros(n,1);
Psi_rb = zeros(n,1);

w_alpha_nd = 1; %the number fraction of the zeroth generation (non-damaged)
w_alpha = 1; %the number fraction of the zeroth generation

% bond kinetics constitutive relation
if strcmp(kinetics.name,'step')==0
    fun_temp = ConstructKinetics(kinetics.name);
    GAMMA = fun_temp(kinetics.parameters);
end
% Intrinsic hyperelasticity constitutive relation and energy terms
fun_temp = ConstructIntHyper(IntHyper.name);
psi = fun_temp(IntHyper.parameters);

% sliding behavior and constitutive relations
if isempty(sliding)==0 && sliding.flag == 1
    fun_temp = ConstructSliding(sliding.name);
    f_s = fun_temp(sliding.parameters);    
    r0_s = sliding.parameters(3);
    r_s = r0_s * ones(n,1);
    
    Pi_s(1) = 1;
    Xi_s(1) = 1;
else
    Pi_s = [];
    r_s  = [];
    Xi_s = [];
end

% damage behavior and constitutive relations
if isempty(damage)==0 && damage.flag == 1
    fun_temp = ConstructDamage(damage.name);
    f_D = fun_temp(damage.parameters);
    r0_D = damage.parameters(3);
    if isfield(damage,'max')
        if damage.max>1
            error('D_max cannot be bigger than 1')
        end
        D_max=damage.max;
    end
    D = zeros(n,1);
    r_D = r0_D*ones(n,1);
    Xi_D = ones(n,1);  
else
    D 	 = [];
    r_D  = [];
    Xi_D = [];
end 

%% Bond Kinetics
Pi_alpha(1) = 1; delta_t = diff(t);
gen = 1; %genetation number record
V(1) = 0; %breakage start point of first(-Inf) generation
if kinetics_record 
    W_ALPHA(1,1) = 1;
end
for i=1:length(t)-1
    if isempty(sliding)==0 && sliding.flag == 1
        [Pi_s_temp,r_s(i+1),Xi_s(i+1),s_flag] =...
            ReactiveSliding(lam(1:i+1),f_s,r_s(i),Pi_s(gen));
        if isempty(sliding) == 0 && sliding.flag == 1
                if s_flag && warning_report==1 && Pi_s_temp>lam(i+1)
                    warning(sprintf('Sliding greater than lam is detected Pi-lam = %3f ',...
                                                        Pi_s_temp-lam(i+1)))
                end
         end
        %checks if in this step sliding occured (s_flag=1 indicates
        %sliding) note that s_flag is distinct from user input sliding.flag
        if s_flag == 1 &&  strcmp(kinetics.name,'step')
            gen             = gen+1;
            Pi_s(gen)       = Pi_s_temp;
            Pi_alpha(gen)   = Pi_s(gen);
            V(gen-1)        = t(i+1);
            
            w_alpha_nd(1:gen-1) = 0;
            w_alpha_nd(gen)     = 1;
                        
        elseif s_flag == 0 &&  strcmp(kinetics.name,'step')
            w_alpha_nd(1:gen-1) = 0;
            w_alpha_nd(gen)     = 1;
        
        else
            %The case when a rate equation is used for sliding bond number
            %fraction (not recommended for numerical reasons)
            if s_flag == 1

            gen             = gen+1;
            Pi_s(gen)       = Pi_s_temp;
            Pi_alpha(gen)   = Pi_s(gen);
            V(gen-1)        = t(i+1);
            end
   
            %according to the rate equation. GAMMA gives w_dot.
            Del_w_alpha_nd(1:gen-1) = GAMMA(w_alpha_nd(1:gen-1),t(i+1)-V(1:gen-1)) *delta_t(i);
            w_alpha_nd(1:gen-1) = w_alpha_nd(1:gen-1) + Del_w_alpha_nd(1:gen-1);

            %calculate the number fraction of reforming generation without damage
            w_alpha_nd(gen)     = 1 - sum(w_alpha_nd(1:gen-1));            
        end
    else
        if  lam(i) ~= lam(i+1)
            %detect generation for non-sliding case
            gen     = gen + 1;
            V(gen)  = t(i+1);
            
            %for formative bonds save the current configuration as the reference
            Pi_alpha(gen) = lam(i+1);
        end
        
        %at this step decrease the number fraction of previous generations
        %according to the rate equation. GAMMA gives w_dot.
        Del_w_alpha_nd(1:gen-1) = GAMMA(w_alpha_nd(1:gen-1),t(i+1)-V(1:gen-1)) *delta_t(i);

        w_alpha_nd(1:gen-1) = w_alpha_nd(1:gen-1) + Del_w_alpha_nd(1:gen-1);
        
        %calculate the number fraction of reforming generation without damage
        w_alpha_nd(gen)     = 1 - sum(w_alpha_nd(1:gen-1));
   
    end

    if isempty(damage) == 0 && damage.flag == 1
        [D(i+1), r_D(i+1), Xi_D(i+1)] = ReactiveDamage(lam(1:i+1),f_D,r_D(i),D(i));
        %enforce the maximum allowable damage
        if D(i+1)>D_max
            if warning_report==1
                warning(sprintf('Maximum allowable damage is reached at step: %d',i))
            end
            D(i+1)=D_max;
        end
        if warning_report==1 && D(i+1)>1
            warning(sprintf('Damage greater than one (D-1 = %.4f) is detected at step: %d, Refine the step size.',D(i+1)-1,i))
        end
    end
    
    %check for negative number fraction in non-damaged case, and halt the
    %run if such a number was detected.
    if warning_report==1 && isempty(w_alpha_nd(w_alpha_nd < 0))==0 
       warning(['Negative bond number fraction detected in Non-damage at step: '...
           ,sprintf('%d',i),', refine step size']);
    end
    %% Energy and Stress calculation
    
    if nOutputs>1
        %Energy Calculation
        Psi_rb_nd(i+1) = sum(psi.E(lam(i+1)./Pi_alpha(1:gen)).* w_alpha_nd(1:gen))';
    end

    %Stress Calculation for isochoric deformation
    T_rb_nd(i+1) = sum(psi.T(lam(i+1)./Pi_alpha(1:gen)).* w_alpha_nd(1:gen))';
    
    if isempty(damage)==0 && damage.flag==1
        %apply damage to the number fractions of generation
        w_alpha = (1-D(i+1)) * w_alpha_nd;
        
        %%apply damage to energy and stress
        if nOutputs>1
            Psi_rb (i+1) = (1-D(i+1)) * Psi_rb_nd(i+1);
        end
        
        T_rb (i+1) = (1-D(i+1)) .* T_rb_nd(i+1);
    else
        w_alpha      = w_alpha_nd;
        if nOutputs>1
            Psi_rb (i+1) = Psi_rb_nd (i+1);
        end
        T_rb (i+1) = T_rb_nd(i+1);
    end
    
    if kinetics_record
       W_ALPHA (i+1,1:gen) =  w_alpha;
    end

end

%check for negative number fraction of bonds and warn
if warning_report==1 && isempty(w_alpha(w_alpha < 0))==0
   warning('Negative bond number fraction detected')
end
%% Output arguments
if nOutputs == 2
    varargout = cell(1,nOutputs-1);    
    varargout{1} = Psi_rb;    
elseif nOutputs == 3
    varargout = cell(1,nOutputs-1);    
    varargout{1} = Psi_rb;   
     if kinetics_record
        varargout{2} = W_ALPHA;
     end    
elseif nOutputs == 4
    varargout = cell(1,nOutputs-1);    
    varargout{1} = Psi_rb;   
    if kinetics_record
       varargout{2} = W_ALPHA;
    end    
    varargout{3} = {Pi_alpha,r_s,Xi_s};    
elseif nOutputs == 5    
    varargout = cell(1,nOutputs-1);    
    varargout{1} = Psi_rb;
    if kinetics_record
       varargout{2} = W_ALPHA;
    end    
    varargout{3} = {Pi_alpha,r_s,Xi_s};
    varargout{4} = {D,r_D,Xi_D};
    
elseif nOutputs>5
    error('Too many outputs requested')
end
end