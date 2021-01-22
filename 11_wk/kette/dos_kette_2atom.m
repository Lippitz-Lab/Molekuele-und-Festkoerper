   m1 = 1;
   m2 = 1.5;
   mu = (m1 * m2) / (m1 + m2);
   
   
   k = (0:0.001:1);
   
   omp = sqrt(  ( 1/mu ) + sqrt( (1 / mu^2) - (4 / (m1 * m2))  .* sin(k .* pi/2) .^2));
   omm = sqrt(  ( 1/mu ) - sqrt( (1 / mu^2) - (4 / (m1 * m2))  .* sin(k .* pi/2) .^2));
 
   
   domp = 1 ./ abs(omp- circshift(omp,1));
  domm = 1 ./ abs(omm- circshift(omm,1));

  domp(domp > 3000) = 3100;
  domm(domm > 3000) = 3100;

  plot(k,omp)
  hold on
  plot(k, omm)
  hold off
  
  figure
  plot(-1 .* domp, omp)
  hold on
  plot(-1 .* domm, omm)
  hold off
  
  xlim([-5e3,0])
  
  
  out = [k; omp; omm; domp; domm]';
  
  save('dos_2atom.dat','out','-ascii')
