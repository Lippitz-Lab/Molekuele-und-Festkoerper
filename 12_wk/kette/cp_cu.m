
 %https://www.bnl.gov/magnets/Staff/Gupta/cryogenic-data-handbook/Section8.pdf 
 % specific heat of copper
 % page 78 of pdf , page VIII-B-1 of handbook
 
%T °K	C_p (cal / (g K) 
close all
clear all

data = load('cp_cu.dat');

temp = 10.^(0:0.2:2.1);
theta = 343 ; %K

cv_debye = (temp ./ theta).^3;
id = 20;
cv_debye = cv_debye .* data(id,2) ./ (data(id,1) / theta).^3;


temp2 = 10.^(0:0.2:3.5);

loglog(data(:,1), data(:,2),'o-')
hold on
plot(temp, cv_debye)

plot(temp2, temp2 .* 0 + max(data(:,2)))

hold off