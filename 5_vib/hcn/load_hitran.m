function hitran_struct = load_hitran(file_name, wavenumber_1_per_cm, ...
		pressure_atm, partial_pressure_atm, ...
		path_length_cm, isotopologues_, molecular_weight_array_amu)
%%load_hitran
% hitran_struct = load_hitran(file_name, wavenumber_1_per_cm, ...
%		pressure_atm, partial_pressure_atm, ...
%		path_length_cm, isotopologues_, molecular_weight_array_amu)
%
% Loads 2004+ HITRAN format files, and applies a Voigt lineshape to each line 
% within the desired range. Returns data in a structure containing the raw data
% as well as the absorption coefficient spectrum.
%
% Reference for format:
%   L. S. Rothman et al., "The HITRAN 2004 molecular spectroscopic database,"
%   J. Quant. Spectrosc. Radiat. Transfer 96, 139 (2005).
%
% WARNING: This code does *not* take into account the temperature dependence of
% the transitions. Not only does that change several of the formulae below,
% but implementation requires calculation of the molecular partition function
% (think statistical mechanics), which is very involved. Here, we assume 
% the reference temperature of 296 K.
%
% Inspired by:
%   Voigt lineshape spectrum simulation GUI
%   Author: Chong Tao
%   http://www.mathworks.com/matlabcentral/fileexchange/
%   26707-voigt-lineshape-spectrum-simulation-gui
% 
% Inputs:
%   file_name              - String of HITRAN file path to load
%   wavenumber_1_per_cm    - Array of wavenumber samples on which to 
%                            calculate the lineshape and absorption
%   pressure_atm           - Total pressure of gas.
%   partial_pressure_atm   - Pressure of gas if all gas but the molecular species
%                            of interest were evacuated.
%   path_length_cm         - Path length of the cell.
%   isotopologues_         - Array of isotopologue codes to keep in 
%                            the hitran_struct. Meaning is *loosely* defined in 
%                            L. S. Rothman et al., "AFGL atmospheric absorption 
%                            line parameters compilation: 1982 edition," 
%                            Appl. Opt. 22, 2247 (1983).
%                            As far as I can tell, if the molecule is linear,
%                            you take the ones digit of the nuclear weight of 
%                            each atom in order to get the isotopologue code.
%   molecular_weight_amu   - Array of molecular weights of the isotopologues given 
%                            in isotopologues_.
%
% Outputs:
%   hitran_struct          - A structure containing the following fields:
%     absorption_coefficient_1_per_cm    
%              - An array of absorption coefficients    
%                as a function of wavenumber_1_per_cm    
%     molecule_number    
%              - HITRAN "Molecule number"
%     isotopologue_number    
%              - HITRAN "Isotopologue number"
%     line_center_wavenumber_1_per_cm    
%              - HITRAN "Vacuum wavenumber"
%     line_strength_at_reference_temperature_cm_per_molecule    
%              - HITRAN "Intensity"
%     A_coefficient_1_per_s    
%              - HITRAN "Einstein A coefficient"
%     air_broadened_half_width_1_per_cm_per_atm    
%              - HITRAN "Air-broadened half-width"
%     self_broadened_half_width_1_per_cm_per_atm    
%              - HITRAN "Self-broadened half-width"
%     air_pressure_induced_line_shift_1_per_cm_per_atm    
%              - HITRAN "Air pressured-induce line shift"
%     voigt_half_width_1_per_cm    
%              - The Voigt profile as a function of inputs at 296 K, 
%                as calculated using the formulae in:
%                M. Gharavi and S. Buckley, "Single Diode Laser
%                Sensor for Wide-Range H2O Temperature 
%                Measurements," Appl. Spectrosc. 58, 468 (2004).
%     peak_absorbance_    
%              - The peak absorbance of each line, as calculated using the
%                formulae in:
%                M. Gharavi and S. Buckley, "Single Diode Laser 
%                Sensor for Wide-Range H2O Temperature 
%                Measurements," Appl. Spectrosc. 58, 468 (2004).
%
% Author: Peter DeVore
% Email: pdevore@ucla.edu
% v. 0 - 2013-08-19 - Created
% v. 1 - 2014-05-05 - Fixed issue raised by Iliya on 2014-05-05 on 
%                     MATLAB File Exchange related to parsing whitespace 
%                     around molecule_number.


%%%
% Setup
%%%
N = numel(wavenumber_1_per_cm);
number_of_lines_to_read_per_pass = 1000;
number_of_lines_from_previous_passes = 0;
fid = fopen(file_name);
reference_temperature_K = 296;
hitran_struct = struct();
hitran_struct.absorption_coefficient_1_per_cm = zeros(1, N);
hitran_struct.molecule_number = [];
hitran_struct.isotopologue_number = [];
hitran_struct.line_center_wavenumber_1_per_cm = [];
hitran_struct.line_strength_at_reference_temperature_cm_per_molecule = [];
hitran_struct.A_coefficient_1_per_s = [];
hitran_struct.air_broadened_half_width_1_per_cm_per_atm = [];
hitran_struct.self_broadened_half_width_1_per_cm_per_atm = [];
hitran_struct.air_pressure_induced_line_shift_1_per_cm_per_atm = [];
hitran_struct.voigt_half_width_1_per_cm = [];
hitran_struct.peak_absorbance_ = [];
while(true)
	%%%
	% Load data
	%%%
	HITRAN_data = textscan(fid, ...
			['%2c' '%1f' '%12f' '%10f' '%10f' ...
			'%5f' '%5f' '%10f' '%4f' '%8f' ...
			'%15c' '%15c' '%15c' '%15c' '%6c' ...
			'%12c' '%1c' '%7f' '%7f'], ...
			number_of_lines_to_read_per_pass, 'delimiter', '', ...
			'whitespace', '');
			
	%%%
	% Done condition
	%%%
	HITRAN_data{1} = str2num(HITRAN_data{1});
	number_of_lines_read_this_pass = numel(HITRAN_data{1});
	if(number_of_lines_read_this_pass == 0)
		break;
	end
	
	%%%
	% Add lines into datasets
	%%%
	hitran_struct.molecule_number = [hitran_struct.molecule_number ...
			HITRAN_data{1}.'];
	hitran_struct.isotopologue_number = [hitran_struct.isotopologue_number ...
			HITRAN_data{2}.'];
	hitran_struct.line_center_wavenumber_1_per_cm = ...
			[hitran_struct.line_center_wavenumber_1_per_cm ...
			HITRAN_data{3}.'];
	hitran_struct.line_strength_at_reference_temperature_cm_per_molecule = ...
			[hitran_struct.line_strength_at_reference_temperature_cm_per_molecule ...
			HITRAN_data{4}.'];
	hitran_struct.A_coefficient_1_per_s = ...
			[hitran_struct.A_coefficient_1_per_s ...
			HITRAN_data{5}.'];
	hitran_struct.air_broadened_half_width_1_per_cm_per_atm = ...
			[hitran_struct.air_broadened_half_width_1_per_cm_per_atm ...
			HITRAN_data{6}.'];
	hitran_struct.self_broadened_half_width_1_per_cm_per_atm = ...
			[hitran_struct.self_broadened_half_width_1_per_cm_per_atm ...
			HITRAN_data{7}.'];
	hitran_struct.air_pressure_induced_line_shift_1_per_cm_per_atm = ...
			[hitran_struct.air_pressure_induced_line_shift_1_per_cm_per_atm ...
			HITRAN_data{10}.'];
	lines_to_delete = [];
	
	for(set_line_number = 1:number_of_lines_read_this_pass)
		line_number = set_line_number + number_of_lines_from_previous_passes;
		%%%
		% Skip isotopologues that are not of interest
		%%%
		if(~ismember(hitran_struct.isotopologue_number(line_number), ...
				isotopologues_))
			lines_to_delete = union(lines_to_delete, line_number);
			continue;
		end
		%%%
		% Skip lines out of wavenumber range
		%%%
		if(hitran_struct.line_center_wavenumber_1_per_cm(line_number) ...
				< min(wavenumber_1_per_cm) || ...
				max(wavenumber_1_per_cm) < ...
				hitran_struct.line_center_wavenumber_1_per_cm(line_number))
			lines_to_delete = union(lines_to_delete, line_number);
			continue;
		end
			
		%%%
		% Calculate absorption coefficient
		%%%
		% Note that Doppler broadening is a purely thermal effect (i.e. arises due
		% to the thermal velocity distribution)
		% https://en.wikipedia.org/wiki/Doppler_broadening
		% while Lorentzian broadening inherently means homogeneous, (i.e. it affects 
		% all molecules in the same waydepends on collision rate)
		% https://en.wikipedia.org/wiki/Homogeneous_broadening
		
		% L. S. Rothman et al., "THE HITRAN MOLECULAR SPECTROSCOPIC DATABASE
		% AND HAWKS (HITRAN ATMOSPHERIC WORKSTATION): 1996 EDITION"
		% J. Quant. Spectrosc. Radiat. Transfer 60, 665 (1998) 
		% Eq. A12
		% Temperature dependence to be implemented in a future release...
		lorentzian_half_width_1_per_cm = (hitran_struct.air_broadened_half_width_1_per_cm_per_atm(line_number) ...
				* (pressure_atm - partial_pressure_atm)) ...
				+ (hitran_struct.self_broadened_half_width_1_per_cm_per_atm(line_number) * ...
				partial_pressure_atm);

		% M. Gharavi and S. Buckley, "Single Diode Laser Sensor for Wide-Range ..., "
		% Applied Spectroscopy 58, 468 (2004) 
		% Eq. 7
		% Temperature dependence to be implemented in a future release...
		molecular_weight_amu = molecular_weight_array_amu( ...
				hitran_struct.isotopologue_number(line_number) == isotopologues_);
		doppler_half_width_1_per_cm = 3.581e-7 * ...
				hitran_struct.line_center_wavenumber_1_per_cm(line_number) * ...
				sqrt(reference_temperature_K / molecular_weight_amu);
				
		% M. Gharavi and S. Buckley, "Single Diode Laser Sensor for Wide-Range ..., "
		% Applied Spectroscopy 58, 468 (2004) 
		% Eq. 9
		% Temperature dependence to be implemented in a future release...
		hitran_struct.voigt_half_width_1_per_cm ...
				= [hitran_struct.voigt_half_width_1_per_cm ...
				(0.5346 * lorentzian_half_width_1_per_cm) ...
				+ sqrt(0.2166 * (lorentzian_half_width_1_per_cm ^ 2) ...
				+ (doppler_half_width_1_per_cm ^ 2))];
		
		% pV = NkT -> p = nkT -> n = p/kT -> 
		% n (1/cm^3) = n (1/m^3) * 1e-6 (m/cm)^3 = p (Pa) / (1.38e-23 (J/K) * Tref (K)) * 1e-6 (m/cm)^3 
		% = p (atm) * (101325 Pa/atm) / (1.3806e-23 (J/K) * Tref (K)) * 1e-6 (m/cm)^3 
		% = p (atm) * 101325 * 1e-6 / (1.3806e-23 * 296) * (Pa * m^3 / J) * (1/(atm * cm^3))
		% = p (atm) * 2.48e19 * (1/(atm * cm^3))
		% Temperature dependence to be implemented in a future release...
		partial_pressure_molecules_1_per_cm3 = partial_pressure_atm * 2.48e19;
				
		% Combination of
		% L. S. Rothman et al., "THE HITRAN MOLECULAR SPECTROSCOPIC DATABASE
		% AND HAWKS (HITRAN ATMOSPHERIC WORKSTATION): 1996 EDITION"
		% J. Quant. Spectrosc. Radiat. Transfer 60, 665 (1998) 
		% Eq. A13
		% M. Gharavi and S. Buckley, "Single Diode Laser Sensor for Wide-Range ..., "
		% Applied Spectroscopy 58, 468 (2004) 
		% Eq. 8
		% Temperature dependence to be implemented in a future release...
		x = (lorentzian_half_width_1_per_cm / ...
				hitran_struct.voigt_half_width_1_per_cm(end));
		y = (abs(wavenumber_1_per_cm - hitran_struct.line_center_wavenumber_1_per_cm(line_number) ...
				- hitran_struct.air_pressure_induced_line_shift_1_per_cm_per_atm(line_number) * pressure_atm) ...
				/ hitran_struct.voigt_half_width_1_per_cm(end));
		
		% M. Gharavi and S. Buckley, "Single Diode Laser Sensor for Wide-Range ..., "
		% Applied Spectroscopy 58, 468 (2004) 
		% Eq. 10
		% Temperature dependence to be implemented in a future release...
		absorption_cross_section_at_line_center_cm2_per_molecule = ...
				hitran_struct.line_strength_at_reference_temperature_cm_per_molecule(line_number) ...
				./ (2 * hitran_struct.voigt_half_width_1_per_cm(end) * (1.065 + (0.447 * x) + (0.058 * (x .^ 2))));
				
		% M. Gharavi and S. Buckley, "Single Diode Laser Sensor for Wide-Range ..., "
		% Applied Spectroscopy 58, 468 (2004) 
		% Eq. 8
		% Temperature dependence to be implemented in a future release...
		absorption_cross_section_cm2_per_molecule = ...
				absorption_cross_section_at_line_center_cm2_per_molecule ...
				.* ( ((1 - x) .* exp(-0.693 .* (y .^ 2))) + ...
				x ./ (1 + (y .^ 2)) + (0.016 * ...
				(1 - x) .* x .* ...
				(exp( -0.0841 .* (y .^ 2.25)) - 1 ./ (1 + 0.021 .* (y .^ 2.25)))) );

		% M. Gharavi and S. Buckley, "Single Diode Laser Sensor for Wide-Range ..., "
		% Applied Spectroscopy 58, 468 (2004) 
		% Eq. 2
		% Temperature dependence to be implemented in a future release...
		hitran_struct.absorption_coefficient_1_per_cm = hitran_struct.absorption_coefficient_1_per_cm ...
				+ partial_pressure_molecules_1_per_cm3 ...
				.* absorption_cross_section_cm2_per_molecule;
				
		% Putting previous results together
		hitran_struct.peak_absorbance_ = [hitran_struct.peak_absorbance_ ...
				partial_pressure_molecules_1_per_cm3 * ...
				absorption_cross_section_at_line_center_cm2_per_molecule * path_length_cm];
		
		% Latest partition sum seems to be from
		% HITRAN 1996 page 31 "The HITRAN molecular spectroscopic database and HAWKS"
		% Q(T) = a + b * T + c * T ^ 2 + d * T ^3
		% Temperature dependence to be implemented in a future release...
	end
	%%%
	% Delete lines not in set of desired isotopologues
	%%%
	hitran_struct.molecule_number(lines_to_delete) = [];
	hitran_struct.isotopologue_number(lines_to_delete) = [];
	hitran_struct.line_center_wavenumber_1_per_cm(lines_to_delete) = [];
	hitran_struct.line_strength_at_reference_temperature_cm_per_molecule(lines_to_delete) = [];
	hitran_struct.A_coefficient_1_per_s(lines_to_delete) = [];
	hitran_struct.air_broadened_half_width_1_per_cm_per_atm(lines_to_delete) = [];
	hitran_struct.self_broadened_half_width_1_per_cm_per_atm(lines_to_delete) = [];
	hitran_struct.air_pressure_induced_line_shift_1_per_cm_per_atm(lines_to_delete) = [];
	number_of_lines_from_previous_passes = numel(hitran_struct.molecule_number);
end

hitran_struct.absorbance_ = ...
		hitran_struct.absorption_coefficient_1_per_cm * path_length_cm;
hitran_struct.transmission_ = exp(-hitran_struct.absorbance_);

%%%
% Clean up
%%%
fclose(fid);
end