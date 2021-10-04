function cmap = discrete_plot_colors()
%%DISCRETE_PLOT_COLORS
% cmap = discrete_plot_colors()
%
% cmap is matrix whose rows represent colors, convenient for plotting, e.g.
% cmap(1, :) is blue, cmap(2, :) is dark green, etc.
%
% Inputs:
%
% Outputs:
%   cmap     - (8, 3) Matrix. Each row specifies RGB values of a color.
%
% Author: Peter DeVore
% Email: peterdevore@gmail.com
% v.  0 - 2012-04-XX - Created
% v.  1 - 2014-02-03 - Green is now darker
cmap = [[0 0 1];
		[0 0.5 0];
		[1 0 0];
		[1 0.5 0]; 
		[0.6 0 0.4];
		[0.5 0.5 1];
		[0.4 0.8 0.4];
		[1 0.5 0.5]];