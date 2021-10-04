
close all
clear all

Segelstein = importfile_neu('Segelstein.dat.csv');

Segelstein.eps = (Segelstein.n - 1i .* Segelstein.k).^2;
Segelstein.wn = 10^7 ./ (Segelstein.wl .* 1000);


% 
% Hale = importfile_neu('Hale.dat.csv');
% 
% Hale.eps = (Hale.n - 1i .* Hale.k).^2;
% Hale.wn = 10^7 ./ (Hale.wl .* 1000);
% 
% 
% asfar = importfile_neu('Asfar.dat.csv');
% 
% asfar.eps = (asfar.n - 1i .* asfar.k).^2;
% asfar.wn = 10^7 ./ (asfar.wl .* 1000);



% loglog(Segelstein.wn, real(Segelstein.eps))
%  hold on
% % 
% loglog(Segelstein.wn, -imag(Segelstein.eps))
% 
% hold off

% figure
% subplot(1,2,1)
% semilogx(Segelstein.wn, real(Segelstein.eps))
%  hold on
% semilogx(Segelstein.wn, -imag(Segelstein.eps))
% hold off
% xlim([1e-1 3e1 ])
% 
% subplot(1,2,2)
% semilogx(Segelstein.wn, real(Segelstein.eps))
%  hold on
% semilogx(Segelstein.wn, -imag(Segelstein.eps))
% hold off
% xlim([3e1 3e5 ])
% 

ende = find(isnan(Segelstein.wn), 1 );
scalefac = Segelstein.wn .* 0 + 1;
%scalefac(Segelstein.wn < 3e1) = 20;
[a, b] = min(abs(Segelstein.wn - 3e1));
scalefac(b:end) = 20;
scalefac(b) = nan;

figure
semilogx(Segelstein.wn, real(Segelstein.eps)./ scalefac)
 hold on
semilogx(Segelstein.wn, -imag(Segelstein.eps) ./ scalefac)
hold off
xlim([1e-1 3e5 ])


out = [Segelstein.wn , real(Segelstein.eps)./ scalefac, - imag(Segelstein.eps)./ scalefac];
out = out(1:ende-1,:);

save('water.dat','out','-ascii')