%%load_hitran_test
%
% Just type "load_hitran_test" to demonstrate load_hitran.m.
%
% Tests load_hitran.m using the HITRAN 2012 data for NIST SRM 2517a (56 lines 
% of the nu_1 + nu_3 rotational-vibrational band of acetylene ^{12}C_2H_2).
%
% Author: Peter DeVore
% Email: pdevore@ucla.edu
% v. 0 - 2013-08-19 - Created

close all
clear all

%%%
% Setup
%%%
colors = discrete_plot_colors_2();
% NIST SRM 2517a
%load_file_name = '26_hit12 - 1550 region.out';
load_file_name ='5f7dd41a.par';

const = phys_const_2();

% N = 2^14;
% wavelength_max_nm = 1545;
% wavelength_min_nm = 1510;
% frequency_samples_THz = const.c ./ [wavelength_max_nm wavelength_min_nm] * 1e-3;
% df_THz = (frequency_samples_THz(2) - frequency_samples_THz(1)) / (N - 1);
% frequency_samples_THz = frequency_samples_THz(1): ...
% 		df_THz: ...
% 		frequency_samples_THz(2);
% wavelength_samples_nm = const.c ./ frequency_samples_THz * 1e-3;
% wavenumber_samples_1_per_cm = 1 ./ wavelength_samples_nm * 1e7;
wavenumber_samples_1_per_cm = (600:0.01:3800) ;

resolution = 2;
convolution_function = (exp( -(wavenumber_samples_1_per_cm - mean(wavenumber_samples_1_per_cm)) .^ 2 / (resolution ^ 2))) ;
convolution_function = convolution_function ./ sum(convolution_function);


%resolution_THz = 0.002;
%f0_THz = min(frequency_samples_THz) + (df_THz * N / 2);
% A convolution should conserve energy
% Thus the integral of the function should be 1
%convolution_function = (1 / (0.3940625)) * ifftshift(exp( -(frequency_samples_THz - f0_THz) .^ 2 / (resolution_THz ^ 2))) / (N * resolution_THz);
% sum(convolution_function_) % = 1
% sum(ifft(fft(convolution_function_) .* conj(fft(convolution_function_)))) % = 1
pressure_atm = 50 / 760;
partial_pressure_atm = pressure_atm;
path_length_cm = 1;
if(1) % 12C2H2
	isotopologues_array_ = [1];
	molecular_weight_array_amu = [1 + 12 + 12 + 1];
else % 1H13C12C1H
	isotopologues_array_ = [2]; 
	molecular_weight_array_amu = [1 + 12 + 13 + 1];
end


%%%
% Execute
%%%
if(1)
	hitran_struct = load_hitran(load_file_name, wavenumber_samples_1_per_cm, ...
			pressure_atm, partial_pressure_atm, ...
			path_length_cm, isotopologues_array_, molecular_weight_array_amu);
end	
	
%%%
% Plot vs. wavelength
%%%
transmission_16_times_ = exp(16 * log(hitran_struct.transmission_));
blurred_transmission = conv(transmission_16_times_, convolution_function, 'same');
absorbance =  -1 .* log10(blurred_transmission);

plot(wavenumber_samples_1_per_cm, absorbance)


x = (600:2:3800) ;
y = interp1(wavenumber_samples_1_per_cm, absorbance, x);
figure
plot(x,y)

 out = [x; y]';
 save('hcn-lowres.dat','out','-ascii')

% x1 = (620:0.05:820) ;
% x2 = (1320:0.05:1520) ;
% x3 = (3200:0.05:3400) ;
% 
% y1 = interp1(wavenumber_samples_1_per_cm, absorbance, x1);
% y2 = interp1(wavenumber_samples_1_per_cm, absorbance, x2);
% y3 = interp1(wavenumber_samples_1_per_cm, absorbance, x3);
% 
% % [~, a] = min(abs(wavenumber_samples_1_per_cm));
% % [~, b] = min(abs(wavenumber_samples_1_per_cm - 500));
% % 
% % wavenumber_samples_1_per_cm = wavenumber_samples_1_per_cm(a:b);
% % blurred_transmission = blurred_transmission(a:b);
%     
% 	figure;
%     subplot(1,3,1)
% 	plot(x1, y1);
%    
%        subplot(1,3,2)
% 	plot(x2, y2);
%    
%    subplot(1,3,3)
% 	plot(x3, y3);
% 
% out = [x1; y1; x2; y2; x3; y3]';
% save('hcn.dat','out','-ascii')
