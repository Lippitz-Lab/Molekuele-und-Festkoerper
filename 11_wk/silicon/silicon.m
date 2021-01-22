
% % data dffrom http://www.ioffe.ru/SVA/NSM/Semicond/Si/thermal.html
% and
% 
% The thermodynamic and optical properties of germanium, silicon, diamond and gallium arsenide
% To cite this article: G Dolling and R A Cowley 1966 Proc. Phys. Soc. 88 463
% 
% and
% 
% The heat capacity of pure silicon and germanium and properties of their vibrational frequency spectra
% P. Flubacher , A. J. Leadbetter & J. A. Morrison

close all
clear all


dos = load('dos_si.csv');

nu = (0:0.05:16);
dos_si = interp1(dos(:,1), dos(:,2), nu);

dos_si = smooth(dos_si);


dos_debye = nu.^2;
theta = 645 ; %K
kb = 1.380649E-23;   
hplanck = 1.0545718E-34 .* 2 .* pi; 
nu_debye = kb .* theta / hplanck ;

dos_debye(nu .* 1e12 > nu_debye ) = 0;
dos_debye = dos_debye ./ sum(dos_debye) .* sum(dos_si);


plot(nu,dos_si);
hold on
plot(nu,dos_debye);
hold off

data = [nu; dos_si'; dos_debye]';
save('dos_si_all.dat','data','-ascii');

%--------
figure

cv1 = load('cp_si_low.csv');
cv2 = load('cp_si_high.csv'); % T is off by 10 in this file

 % loglog(cv1(:,1), cv1(:,2));
%  hold on
%  loglog(cv2(:,1), cv2(:,2) , 'o');
%  hold off


clipT = 135;
ids = find(cv1(:,1)  < clipT);
cv1 = cv1(ids,:);

cv2(:,1) = cv2(:,1) .* 10;
ids = find(cv2(:,1)  > clipT);
cv2 = cv2(ids,:);

cv_temp = [cv1(:,1); cv2(:,1)];
cv = [cv1(:,2); cv2(:,2)];


t = 10.^(0:0.1:4);

tdebye = 645;
debye = 4 .* pi^4 ./5 .* ( t ./ tdebye).^3 ;

nu0 = 15 ; % THz
kb = 1.380649E-23;   
hplanck = 1.0545718E-34 .* 2 .* pi; 

t0 = nu0 .* 1e12 .* hplanck ./ kb;
einstein1 = 0.95 .* (t0 ./ t).^2 .* exp(t0 ./ t) ./ (exp(t0./t) -1).^2;

nu2 = 10 ; % THz
kb = 1.380649E-23;   
hplanck = 1.0545718E-34 .* 2 .* pi; 

t0 = nu2 .* 1e12 .* hplanck ./ kb;
einstein2 = 0.95 .* (t0 ./ t).^2 .* exp(t0 ./ t) ./ (exp(t0./t) -1).^2;


loglog(cv_temp, cv, 'o');
hold on
loglog(t,debye)
loglog(t, einstein1);
loglog(t, einstein2);
hold off

ylim ([1E-6 1])


data = [cv_temp, cv];
mo = [ debye; einstein1 ; einstein2]';
mo(mo < 1e-6) = 0.9e-6;
mo(mo>2) = 2.2;
mo = [t', mo];

save('cp_si_joined.dat','data','-ascii');
save('cv_si_model.dat','mo','-ascii');

