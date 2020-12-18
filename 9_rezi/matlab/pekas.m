close all
clear all

a = [0, 21.5, 43.5, 69.5, 104.5] - 21.5;
b = [0, 20, 55, 87, 121, 170] - 20;

plot(a .* 1.2,'o')
hold on
plot(b,'x')
hold off