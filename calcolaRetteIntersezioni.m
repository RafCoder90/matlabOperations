function calcolaRetteIntersezioni(xP,yP,xS,yS)

    global totInfoInt;
    global totInfoIn;
    global totInfoIntIn;
    global nPunti;
    global vettoreIntersezioneX;
    global verroteIntersezioneY;
    
    poly1 = polyshape(xP,yP);
    poly2 = polyshape(xS,yS);
     
    figure(2)
    subplot(2,3,3)
    fill(xP,yP,'g','EdgeColor','g')
    fill(xS,yS,'g','EdgeColor','g')
    hold on
    axis([0 10 0 10]);
    title('Xor')

    intersezioneX = [];
    intersezioneY = [];
    
    for i = 1:length(xP)
        if i == length(xP)
            fFXP = xP(length(xP));
            fSXP = xP(1);
            fFYP = yP(length(yP));
            fSYP = yP(1);
        else
            fFXP = xP(i);
            fSXP = xP(i+1);
            fFYP = yP(i);
            fSYP = yP(i+1);
        end

        % Equazione della prima retta
        if fFXP == fSXP && fFYP == fSYP
            %disp("Non è una retta ma un punto")
        end
        if fFXP == fSXP && fFYP ~= fSYP
            q1 = fFXP;
            m1 = 1;
            y1 = 0;
            %disp("Equazione x = x1")
        end
        if fFYP == fSYP && fFXP ~= fSXP
            q1 = fSYP;
            m1 = 0;
            y1 = 1;
            %disp("Equazione y = y1")
        end
        if fFYP ~= fSYP && fFXP ~= fSXP
            m1 = (fFYP - fSYP)/(fFXP - fSXP);
            m1 = -1 * m1;
            q1 = ((fFXP*fSYP) - (fSXP*fFYP))/(fFXP - fSXP);
            y1 = 1;      
            %disp("Equazione y = mx + q")
        end 

        %controllo del primo punto se è interno
        primoInterno = 0;
        fFV = [fFXP fFYP];
        fFVIS = isinterior(poly2, fFV);
        if fFVIS == 1
            for k = 1:length(intersezioneX)
                if intersezioneX(k) == fFV(1) && intersezioneY(k) == fFV(2)
                    primoInterno = 1;
                end    
            end
            if primoInterno == 0
                intersezioneX(end+1) = fFV(1);
                intersezioneY(end+1) = fFV(2);
            end
        end

        %controllo del secondo punto se è interno
        secondoInterno = 0;
        fSV = [fSXP fSYP];
        fSVIS = isinterior(poly2, fSV);
        if fSVIS == 1
            for k = 1:length(intersezioneX)
                if intersezioneX(k) == fSV(1) && intersezioneY(k) == fSV(2)
                    secondoInterno = 1;
                end    
            end
            if secondoInterno == 0
                intersezioneX(end+1) = fSV(1);
                intersezioneY(end+1) = fSV(2);
            end
        end

        if fSVIS == 1 && fFVIS == 1
%             disp("Retta interna");
%             disp( fSXP + "," +  fSYP + " - " + fFXP + "," + fFYP);
              totInfoIn = [totInfoIn; fSXP fSYP fFXP fFYP];
        end  

        % Seconda retta
        for j = 1:length(xS)
            if j == length(xS)

                sSXP = xS(length(xS));
                sFXP = xS(1);
                sSYP = yS(length(yS));
                sFYP = yS(1); 

            else

                sSXP = xS(j);
                sFXP = xS(j+1);
                sSYP = yS(j);
                sFYP = yS(j+1);

            end

            % Equazione della seconda retta
            if sFXP == sSXP && sFYP == sSYP
                %disp("Non è una retta ma un punto")
            end
            if sFXP == sSXP && sFYP ~= sSYP
                q2 = sFXP;
                m2 = 1;
                y2 = 0;
                %disp("2 -Equazione x = x1")
            end
            if sFYP == sSYP && sFXP ~= sSXP
                q2 = sSYP;
                m2 = 0;
                y2 = 1;
                %disp("2 -Equazione y = y1")
            end
            if sFYP ~= sSYP && sFXP ~= sSXP
                m2 = (sFYP - sSYP)/(sFXP - sSXP);
                m2 = -1 * m2;
                q2 = ((sFXP*sSYP) - (sSXP*sFYP))/(sFXP - sSXP);
                y2 = 1;
            end

            sFV = [sFXP sFYP];
            sFVIS = isinterior(poly1, sFV);

            sSV = [sSXP sSYP];
            sSVIS = isinterior(poly1, sSV);

            if sSVIS == 1 && sFVIS == 1
%                 disp("Retta interna");
%                 disp( sSXP + "," +  sSYP + " - " + sFXP + "," + sFYP);
                  totInfoIn = [totInfoIn; sSXP sSYP sFXP sFYP];
            end  

           A = [m1 y1; m2 y2];
           B = [q1 q2];

           C = inv(A);
           C = C';
           X = B*C;

           estremiFX = [fFXP fSXP];
           estremiFY = [fFYP fSYP];
           minFX = min(estremiFX);
           maxFX = max(estremiFX);
           minFY = min(estremiFY);
           maxFY = max(estremiFY);

           estremiSX = [sFXP sSXP];
           estremiSY = [sFYP sSYP];
           minSX = min(estremiSX);
           maxSX = max(estremiSX);
           minSY = min(estremiSY);
           maxSY = max(estremiSY);

           if (X(1) >= minFX && X(1) <= maxFX) && (X(2) >= minFY && X(2) <= maxFY)
               if (X(1) >= minSX && X(1) <= maxSX) && (X(2) >= minSY && X(2) <= maxSY)
                   controllo = 0;

                    P = [X(1) X(2)];

                    TF = isinterior(poly1, P);
                    TS = isinterior(poly2, P);

                    if TF == 1 && TS == 1
                        controllo = 0;
                    else 
                        controllo = 1;
                    end 

                   for f = 1:length(intersezioneX)
                       if intersezioneX(f) == X(1) && intersezioneY(f) == X(2)
                           controllo = 1;
                       end    
                   end
                   
                   if fFVIS == 1
                       disp("fFVIS Retta del poligono intersezione")
                       disp(fFXP + "," + fFYP);
                       disp(X(1) + " " + X(2));
                       disp("Fine------");
                        totInfoIntIn = [totInfoIntIn; fFXP fFYP P]
%                         totInfoInt = [totInfoInt; P fSXP fSYP fFXP fFYP]
                        totInfoInt = [totInfoInt;fFXP fFYP P fSXP fSYP]
                   end   
                   if fSVIS == 1
                       disp("fSVIS Retta del poligono intersezione")                 
                       disp(X(1) + " " + X(2));
                       disp( fSXP + "," +  fSYP);
                       disp("Fine------");
                        totInfoIntIn = [totInfoIntIn; P fSXP fSYP]
%                         totInfoInt = [totInfoInt; P fSXP fSYP fFXP fFYP]
                        totInfoInt = [totInfoInt;fSXP fSYP P fFXP fFYP]
                   end
                   if fFVIS == 0 && fSVIS == 0 && sFVIS == 0 && sSVIS == 0            
                       disp("Punto di intersezione che termina in un punto di intersezione")    
                       P;
                       totInfoInt = [totInfoInt; P fSXP fSYP fFXP fFYP]
                       totInfoInt = [totInfoInt; P sSXP sSYP sFXP sFYP]
                       disp( fSXP + "," +  fSYP + " - " + fFXP + "," + fFYP);
                       disp( sSXP + "," +  sSYP + " - " + sFXP + "," + sFYP);
                   end
                   if (fFVIS == 1 || fSVIS == 1) && (sFVIS == 0 || sSVIS == 0)            
                       disp("Punto di intersezione che termina in un punto di intersezione")    
                       P;
                       totInfoInt = [totInfoInt; P fSXP fSYP fFXP fFYP]
                       totInfoInt = [totInfoInt; P sSXP sSYP sFXP sFYP]
                       disp( fSXP + "," +  fSYP + " - " + fFXP + "," + fFYP);
                       disp( sSXP + "," +  sSYP + " - " + sFXP + "," + sFYP);
                   end 
                   if controllo == 0
                       intersezioneX(end+1) = X(1);
                       intersezioneY(end+1) = X(2);
                   end
               end

           end

        end
    end
    
    if nPunti < length(intersezioneX)
        nPunti = length(intersezioneX);
        vettoreIntersezioneX = intersezioneX;
        verroteIntersezioneY = intersezioneY;
    end    

end
