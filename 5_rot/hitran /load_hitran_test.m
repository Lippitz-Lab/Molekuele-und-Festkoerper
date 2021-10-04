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


%%%
% Setup
%%%
colors = discrete_plot_colors_2();
% NIST SRM 2517a
load_file_name = '26_hit12 - 1550 region.out';
const = phys_const_2();
N = 2^14;
wavelength_max_nm = 1545;
wavelength_min_nm = 1510;
frequency_samples_THz = const.c ./ [wavelength_max_nm wavelength_min_nm] * 1e-3;
df_THz = (frequency_samples_THz(2) - frequency_samples_THz(1)) / (N - 1);
frequency_samples_THz = frequency_samples_THz(1): ...
		df_THz: ...
		frequency_samples_THz(2);
wavelength_samples_nm = const.c ./ frequency_samples_THz * 1e-3;
wavenumber_samples_1_per_cm = 1 ./ wavelength_samples_nm * 1e7;
resolution_THz = 0.002;
f0_THz = min(frequency_samples_THz) + (df_THz * N / 2);
% A convolution should conserve energy
% Thus the integral of the function should be 1
convolution_function_ = (1 / (0.3940625)) * ifftshift(exp( -(frequency_samples_THz - f0_THz) .^ 2 / (resolution_THz ^ 2))) / (N * resolution_THz);
% sum(convolution_function_) % = 1
% sum(ifft(fft(convolution_function_) .* conj(fft(convolution_function_)))) % = 1
pressure_atm = 50 / 760;
partial_pressure_atm = pressure_atm;
path_length_cm = 5;
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
blurred_transmission_ = ifft(fft(transmission_16_times_) ...
		.* conj(fft(convolution_function_)));
if(1)
	figure;
	plot(frequency_samples_THz, 10 * log10(blurred_transmission_));
	xlabel('Frequency (THz)');
	ylabel('-Absorbance (80 cm) (convolved) (dB)');
	title('Acetylene (^{13}C_2H_2) Absorbance');
else
	figure;
	plot(frequency_samples_THz, transmission_16_times_);
	xlabel('Frequency (THz)');
	ylabel('Transmission (80 cm) (W/W)');
	figure;
	plot(frequency_samples_THz, 10 * log10(transmission_16_times_));
	xlabel('Frequency (THz)');
	ylabel('-Absorbance (80 cm) (dB)');
	figure; hold on;
	plot(wavelength_samples_nm, transmission_16_times_, ...
			'color', colors(1, :));
	plot(wavelength_samples_nm, blurred_transmission_, ...
			'color', colors(2, :));
	xlabel('Wavelength (nm)');
	ylabel('Transmission (80 cm) (HITRAN, convolved) (W/W)');
	figure;
	plot(wavenumber_samples_1_per_cm, hitran_struct.transmission_);
	xlabel('Wavenumber (cm^-1)');
	ylabel('Transmission (W/W)');
	figure;
	plot(wavelength_samples_nm, hitran_struct.transmission_);
	xlabel('Wavelength (nm)');
	ylabel('Transmission (W/W)');
	figure;
	plot(frequency_samples_THz, hitran_struct.transmission_);
	xlabel('Frequency (THz)');
	ylabel('Transmission (W/W)');
end
% hitran_struct.air_pressure_induced_line_shift_1_per_cm_per_atm(...
		% hitran_struct.line_center_wavenumber_1_per_cm == 6534.363450) * pressure_atm
