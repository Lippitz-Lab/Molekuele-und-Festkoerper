function const = phys_const_2()
%%PHYS_CONST_2
% const = phys_const_2()
%
% Create a structure containing fundamental constants in SI.
% Values taken from: http://physics.nist.gov/cuu/Constants/index.html
% which are the 2010 CODATA recommended values.
%
% Input:
%
% Output:
%   const is a structure containing:
%      c is the speed of light (m/s)
%      mu0 is the permeability of free space (H/m)
%      epsilon0 is the permittivity of free space (F/m)
%      e is the electron charge (C)
%      h is the Planck's constant (J.s)
%      k_B is the Boltzmann's constant (J/K)
%      ""_unc is the absolute uncertainty of the constant, e.g.
%        c_unc 
% 
% Author: Peter DeVore
% Email: peterdevore@gmail.com
% Date: 2012
% v. 1 - 2012-06-23 - Added Boltzmann Constant
% v. 2 - 2012-10-02 - Added permeability and permittivity of free space

const.c = 299792458; % (m/s) (exact)
const.c_unc = 0; % (m/s) (exact)
const.mu0 = 4 * pi * 1e-7; % (H/m) (exact)
const.mu0_unc = 0; % (H/m) (exact)
const.epsilon0 = 1 / (const.mu0 * const.c^2); % (F/m) (exact)
const.epsilon0_unc = 0; % (F/m) (exact)
const.e = 1.60217665e-19; % (C) 
const.e_unc =  0.000000035e-19; % (C) 
const.h = 6.62606957e-34; % (J.s)
const.h_unc = 0.00000029e-34; % (J.s)
const.k_B = 1.3806488e-23; % (J/K)
const.k_B_unc = 0.0000013e-34; % (J.s)