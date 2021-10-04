 close all
clear all

% data from https://www.youtube.com/watch?v=9n1u8ymc8aw

zweitheta = [38.46, 55.54, 69.58, 82.46, 94.94, 107.64, 121.36]; % deg

theta = (zweitheta ./ 2) .* pi / 180;

sintheta = sin(theta);

sinthetasq = sintheta.^2;

sinthetasq ./ sinthetasq(1)

sumhklsq = sinthetasq ./ sinthetasq(1)


%neue Daten

m = (2:2:20);
stsq = sinthetasq(1) .* m ./ 2;

theta_neu = asind(sqrt(stsq))