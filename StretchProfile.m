function [t,lam] = StretchProfile(i,n,varargin)
%[t,lam] = StretchProfile(i,n,varargin)
%% Input argument
%defulats
must_point = 'off';
nInputs = nargin;
if nInputs == 3
    must_point = varargin;
end    

%% switch between default loading cases
switch i
    case 1
        load = [0, 1;
                10,1.15;
                ];
    case 2
        load = [0, 1;
                10, 1.1;
                20, 1];
    case 3
        load = [0, 1;
                10, 1.1;
                100, 1.1];
    case 4
        load = [0, 1;
                10, 1.1;
                20, 1;
                30, 1.1
                40, 1;
                50, 1.1;
                60, 1;
                70, 1.1;
                80, 1;
                90, 1.1;
                100, 1];
    case 5
        load = [0,      1;
                0.001,    1.01;

                15,      1.01;
                15.001,    1.02;

                30,     1.02;
                30.001,   1.04;

                45,     1.04;
                45.001,   1.06;
                
                75,    1.06;];      
    case 6
        load =[0,   1;
               10,  1.1;
               40,  1.1;
               50,  1;
               100,  1];
    case 7
        load =[0,   1;
               10,   1.02;
               20,  1;
               30,  1.04;
               40,  1;
               50,  1.06;
               60,  1;
               70,  1.08;
               80,  1];

    case 8
        load =[0,   1;
               10,  1.04;
               30,  1.04;
               40,  1.08;
               80,  1.08;
               100, 1];
    case 9 
        load = [0, 1;
                6, 1.06;
                906, 1.06;
                912, 1];
    case 10 
        load = [0, 1;
                6, 1.06;
                906, 1.06;
                912, 1
                922,1.1;
                ];

end  
%% Interpolation of the load curve
t = linspace(0, max(load(:,1)),n)';

if strcmp(must_point,'on')
    for i = 1:length(load(:,1))
        [~, index] = min(abs(t-load(i,1)));
        t(index) = load(i,1);
    end
end
lam = interp1(load(:,1),load(:,2),t,'linear');
end