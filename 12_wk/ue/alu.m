close all
clear all

% ALU


a = 4.05e-10;

k = 0.4 .* pi / a;

omega_L = 3.8E13 ;
omega_T = 2.0E13 ;

v_L = omega_L ./ k 
v_T = omega_T ./ k

uveff3  =  1 /(3 .* v_L.^3) + 2 ./ (3 .*  v_T.^3);
veff = (1 ./ uveff3).^(1/3)

omega_D = veff .* pi / a .* (6/pi).^(1/3)

hbar = 1E-34 ; % Js
kb = 1.38E-23 ; %J /K

theta = hbar .* omega_D ./ kb

% wikipedia 428 K


%--------
% KCl

T2 = (0:0.1:20);

cvt = T2 ./ 20 .* 6;

T = sqrt(T2);

cv = cvt .* T;

plot(T, cv)

alpha = cv(end) ./ T(end).^3  %mj, 

alpha = alpha / 1000; % J

R = 8.31 ; %  J / Mol K

Theta = ((12 * pi.^4)/ 5 * R / alpha).^(1/3)

a = 3.14E-10;

v = kb * Theta / hbar *  (a / pi)  /  (6/ pi).^(1/3)

