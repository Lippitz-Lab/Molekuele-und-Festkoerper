close all
clear all


allevec = [];
kabs = [];
for h= 0:4
    for k = 0:h
        for l = 0:k
            allevec = [allevec; [h,k,l]];
            kabs = [kabs; sqrt(h.^2 + k.^2 + l.^2)];
        end
    end
end

   

[kabs, ix] = sort(kabs);
allevec = allevec(ix,:);
    
out = [kabs, kabs.* 0, kabs.*0, allevec];

% simple cubic = all peaks
sc = kabs;


% body centered cubic : sum (hkl) even 
% even
x = sum(allevec,2);
ids = x/2 == fix(x/2);
bcc = kabs(ids);
out(ids,2) = 1;


% face centerd cubic: (hkl) all even or all odd

% even
x = ( (allevec/2) - fix(allevec/2)) == 0;
x = sum(x,2);
ids = ( (x == 0) | (x == 3));
fcc = kabs(ids);
out(ids,3) = 1;


 plot(sc, sc .* 0 , 'o')
hold on
 plot(bcc, bcc .* 0  + 1, 'x')
 plot(fcc, fcc .* 0  + 2, 'o')
 hold off


