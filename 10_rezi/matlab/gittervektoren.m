function veclist = gittervektoren( index, zentrierung)


    % simple
    veclist = [index];   
    
    % face centered
    if (zentrierung == 1)
        veclist = [veclist; index + [0.5, 0.5, 0]; index + [0.5, 0, 0.5 ]; index + [0, 0.5, 0.5] ];
    end
    
    % body centered
    if (zentrierung == 2)
        veclist = [veclist; index + [0.5, 0.5, 0.5] ];
    end
  
end