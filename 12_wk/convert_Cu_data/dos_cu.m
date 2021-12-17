
% digitalisiert von 
%{Svensson et al., 1967, #21923}

close all
clear all
data = load('dos_cu.csv');

x = data(:,1);
y = data(:,2);

[x,id] = sort(x);
y = y (id);

nu = (0:0.01:8); % THZ
dos_Cu = interp1(x,y,nu);
dos_Cu = smooth(dos_Cu);
%nu = nu .* 1e12 ; % Hz

dos_debye = nu.^2;
theta = 343 ; %K
kb = 1.380649E-23;   
hplanck = 1.0545718E-34 .* 2 .* pi; 
nu_debye = kb .* theta / hplanck ;

dos_debye(nu .* 1e12 > nu_debye ) = 0;
dos_debye = dos_debye ./ sum(dos_debye) .* sum(dos_Cu);

temp1 = (nu_debye ./ 1e12) / 10;
BE1 =  1./(exp( nu./ temp1 ) - 1) ;

plot(nu,dos_Cu)
hold on
plot(nu, dos_debye)
plot(nu, BE1 .* 10)
hold off
ylim( [0 50])

out = [nu; dos_Cu'; dos_debye]';

%save('dos_cu_all.dat','out','-ascii')


figure
plot(nu, BE1 )
ylim( [0 1])
