
close all
clear all

Segelstein = importfile_neu('Segelstein.dat.csv');

Segelstein.eps = (Segelstein.n - 1i .* Segelstein.k).^2;
Segelstein.wn = 10^7 ./ (Segelstein.wl .* 1000);


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

%save('water.dat','out','-ascii')

out = [Segelstein.wn , real(Segelstein.eps),  imag(Segelstein.eps)];
out = sortrows(out(1:ende-1,:));

%semilogx(out(:,1), out(:,3))

save('water_ue.dat','out','-ascii')


