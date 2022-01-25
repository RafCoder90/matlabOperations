close all;
clear all;
clc;

global totInfoInt;
global totInfoIn;
global totInfoIntIn;
global nPunti;
global vettoreIntersezioneX;
global verroteIntersezioneY;

%Informazioni su come disegnare le figure
fprintf("-----   Operazioni booleane in 2d   -----\n" + ...
        "Prima Figura\n");
scelta = comandiFigura;
errore = "**Errore** Inserire 0 o 1 per effettuare la scelta\n";
while isempty(scelta) 
    clc;
    fprintf(errore);
    scelta = comandiFigura;
end

%Nel caso di un cerchio avremo centro e raggio
%Nel caso di un poligono avremo il vettore delle x e il vettore delle y
figure(1)
figura1 = disegnaFigura('b', scelta);

fprintf("Seconda Figura\n");
scelta = comandiFigura;
while isempty(scelta)
    clc;
    fprintf(errore);
    scelta = comandiFigura;
end
figura2 = disegnaFigura('r', scelta);

%Comando di controllo se si desidera ripetere il disegno
ripeti = "Se si desidera ripretere il disegno premere 0, altrimenti premere qualsiasi tasto per confermare\n";
conferma = input(ripeti);
while conferma == 0
    close all;
    figura1 = disegnaFigura('b', scelta);
    figura2 = disegnaFigura('r', scelta);
    conferma = input(ripeti);
end

%Verifichiamo se abbiamo a che fare con cerchi o poligoni
cerchio1 = [];
poligono1 = [];
cerchio2 = [];
poligono2 = [];

dimC1=size(figura1);
dimC2=size(figura2);

if dimC1(1,1) == 1 && dimC1(1,2) == 3
    cerchio1 = figura1;
else 
    poligono1 = figura1;
end

if dimC2(1,1) == 1 && dimC2(1,2) == 3
    cerchio2 = figura2;
else 
    poligono2 = figura2;
end    


%Verifico se le figure sono cerchi o poligoni con la funzione
%"VerificaPoligono.m" e ne stampo l'output
fprintf("Prima figura CERCHIO?: ");
vC1 = verificaPoligono(cerchio1);
fprintf("Prima figura POLIGONO?: ");
vP1 = verificaPoligono(poligono1);
fprintf("Seconda figura CERCHIO?: ");
vC2 = verificaPoligono(cerchio2);
fprintf("Seconda figura POLIGONO?: ");
vP2 = verificaPoligono(poligono2);

if vC1 == true && vC2 == true
    %Calcolo le intersezioni con la funzione "intersectCircles.m"
    %intersezione tra cerchi
    puntiIntersezione = intersectCircles(cerchio1, cerchio2);
    if ~isnan(puntiIntersezione)
        fprintf("Punti di intersezione trovati: \n");
        for p = 1:size(puntiIntersezione,1)
            fprintf("(" + puntiIntersezione(p,1) + ", " + puntiIntersezione(p,2) + ")\n");
        end
        
        [x1,y1,C1] = creaArco(cerchio1, puntiIntersezione);
        puntiInversi = [puntiIntersezione(2,1:2); puntiIntersezione(1,1:2)];
        [x2,y2,C2] = creaArco(cerchio2, puntiInversi);
        
        figure(2)
        subplot(2,3,1);
        plot(x1,y1,'g-',C1(1),C1(2),'w*', 'LineWidth',2);
        hold on
        plot(x2,y2,'g-',C2(1),C2(2),'w*', 'LineWidth',2);
        hold on
        fill(x1,y1, 'g', 'LineStyle','none');
        fill(x2,y2, 'g', 'LineStyle','none');
        axis([0 10 0 10]);
        title("intersezione");
        
        [x3,y3,C3] = creaArco(cerchio2, puntiIntersezione);
        puntiInversi = [puntiIntersezione(2,1:2); puntiIntersezione(1,1:2)];
        [x4,y4,C4] = creaArco(cerchio1, puntiInversi);
        
        subplot(2,3,2);
        plot(x3,y3,'g-',C3(1),C3(2),'w*', 'LineWidth',2);
        hold on
        plot(x4,y4,'g-',C4(1),C4(2),'w*', 'LineWidth',2);
        hold on
        fill(x3,y3, 'g', 'LineStyle','none');
        fill(x4,y4, 'g', 'LineStyle','none');
        axis([0 10 0 10]);
        title("Unione");
        
        subplot(2,3,3);
        plot(x1,y1,'g-',C1(1),C1(2),'w*', 'LineWidth',2);
        hold on
        plot(x2,y2,'g-',C2(1),C2(2),'w*', 'LineWidth',2);
        hold on
        plot(x3,y3,'g-',C3(1),C3(2),'w*', 'LineWidth',2);
        hold on
        plot(x4,y4,'g-',C4(1),C4(2),'w*', 'LineWidth',2);
        hold on
        fill(x3,y3, 'g', 'LineStyle','none');
        fill(x4,y4, 'g', 'LineStyle','none');
        fill(x1,y1, 'w', 'LineStyle','none');
        fill(x2,y2, 'w', 'LineStyle','none');
        axis([0 10 0 10]);
        title("Xor");
        
        subplot(2,3,4);
        plot(x4,y4,'g-',C4(1),C4(2),'w*', 'LineWidth',2);
        hold on
        plot(x2,y2,'g-',C2(1),C2(2),'w*', 'LineWidth',2);
        hold on
        fill(x4,y4, 'g', 'LineStyle','none');
        fill(x2,y2, 'w', 'LineStyle','none');
        axis([0 10 0 10]);
        title("Differenza A(blu) - B(rosso)");
        
        subplot(2,3,5);
        plot(x3,y3,'g-',C3(1),C3(2),'w*', 'LineWidth',2);
        hold on
        plot(x1,y1,'g-',C1(1),C1(2),'w*', 'LineWidth',2);
        hold on
        fill(x3,y3, 'g', 'LineStyle','none');
        fill(x1,y1, 'w', 'LineStyle','none');
        axis([0 10 0 10]);
        title("Differenza B(rosso) - A(blu)");

    else
        fprintf("Non ci sono intersezioni, cerchiamo i punti interni\n");
        [cerchioInterno, cerchioEsterno] = cerchiConcentrici(cerchio1, cerchio2);
        
        if isnan(cerchioInterno)
            fprintf("Non ci sono nè intersezioni nè punti interni tra i due cerchi\n");
            return;
        end
        
        [xint, yint] = circle(cerchioInterno);
        [xout, yout] = circle(cerchioEsterno);
        
        figure(2)
        subplot(2,3,1);
        plot(xint,yint);
        fill(xint,yint, 'g', 'LineWidth',2, 'EdgeColor', 'g');
        axis([0 10 0 10]);
        title("intersezione");
        
        subplot(2,3,2);
        plot(xout,yout);
        fill(xout,yout, 'g', 'LineWidth',2, 'EdgeColor', 'g');
        axis([0 10 0 10]);
        title("Unione");
        
        subplot(2,3,3);
        plot(xout,yout);
        fill(xout,yout, 'g', 'LineWidth',2, 'EdgeColor', 'g');
        hold on
        plot(xint,yint);
        fill(xint,yint, 'w', 'LineWidth',2, 'EdgeColor', 'g');
        axis([0 10 0 10]);
        title("Xor");
        
        %cerchio1 - cerchio2 
        if cerchio1(1,1) == cerchioInterno(1,1) && ... 
           cerchio1(1,2) == cerchioInterno(1,2) && ...
           cerchio1(1,3) == cerchioInterno(1,3)
            subplot(2,3,4);
            plot([],[]);
            axis([0 10 0 10]);
            title("Differenza A(blu) - B(rosso)");
        else
            subplot(2,3,4);
            plot(xout,yout);
            fill(xout,yout, 'g', 'LineWidth',2, 'EdgeColor', 'g');
            hold on
            plot(xint,yint);
            fill(xint,yint, 'w', 'LineWidth',2, 'EdgeColor', 'g');
            axis([0 10 0 10]);
            title("Differenza A(blu) - B(rosso)");
        end
        
        %cerchio2 - cerchio1 
        if cerchio2(1,1) == cerchioInterno(1,1) && ... 
           cerchio2(1,2) == cerchioInterno(1,2) && ...
           cerchio2(1,3) == cerchioInterno(1,3)
            subplot(2,3,5);
            plot([],[]);
            axis([0 10 0 10]);
            title("Differenza B(rosso) - A(blu)");
        else
            subplot(2,3,5);
            plot(xout,yout);
            fill(xout,yout, 'g', 'LineWidth',2, 'EdgeColor', 'g');
            hold on
            plot(xint,yint);
            fill(xint,yint, 'w', 'LineWidth',2, 'EdgeColor', 'g');
            axis([0 10 0 10]);
            title("Differenza B(rosso) - A(blu)");
        end
    end
    
elseif (vC1 == true && vP2 == true) || (vP1 == true && vC2 == true)
    %intersezione tra cerchio e poligono
    ang=0:0.1:2*pi;
    xyr = [];
    if vC1 == true
        xyr = cerchio1;
        f1 = 0;
    else
        xyr = cerchio2;
        f2 = 0;
    end

    xp=xyr(:,3)*cos(ang) + repmat(xyr(:,1),1,numel(ang)); 
    yp=xyr(:,3)*sin(ang) + repmat(xyr(:,2),1,numel(ang));

    if vP1 == true
        vertici = poligono1;
        f1 = 1;
    else
        vertici = poligono2;
        f2 = 1;
    end
    vertici = [vertici; vertici(1,1:2)];
    xln = [];
    yln = [];
    for i = 1:length(vertici)
        xln = [xln, vertici(i, 1)]; 
        yln = [yln, vertici(i, 2)]; 
    end

    %Punti di intersezione
    xi = [];
    yi = [];
    for i = 1:length(vertici)-1
        [xtmp,ytmp] = polyxpoly(xp,yp,xln(1, i:i+1),yln(1, i:i+1));
        xi = [xi; xtmp];
        yi = [yi; ytmp];
    end
    puntiIntersezione = [xi, yi];
    
    %Punti interni
    puntiInterni = [];
    for i = 1:length(vertici)-1
        vx = vertici(i,1);
        vy = vertici(i,2);
        cx = xyr(1,1);
        cy = xyr(1,2);
        cr = xyr(1,3);
        dist = abs(sqrt((cx-vx)*(cx-vx)+(cy-vy)*(cy-vy)));
        if dist <= cr
            puntiInterni = [puntiInterni; vertici(i,1:2)]; 
        end
    end
    
    verticiX = vertici(:,1);
    verticiY = vertici(:,2);
    
    [cerchioX, cerchioY] = circle(xyr);
    
    if ~isempty(puntiIntersezione)
        if isempty(puntiInterni)
            vettoreX = [puntiIntersezione(1,1); puntiIntersezione(2,1)];
            vettoreY = [puntiIntersezione(1,2); puntiIntersezione(2,2)];
        else
            vettoreX = [puntiIntersezione(1,1); puntiInterni(:,1); puntiIntersezione(2,1)];
            vettoreY = [puntiIntersezione(1,2); puntiInterni(:,2); puntiIntersezione(2,2)];
        end

        %Intersezione
        [x1,y1,C1] = creaArco(xyr, puntiIntersezione);

        figure(2)
        subplot(2,3,1);
        plot(x1,y1,'g-',C1(1),C1(2),'w*', 'LineWidth',2);
        hold on
        fill(x1,y1, 'g', 'LineStyle','none');
        fill(vettoreX,vettoreY, 'g', 'LineStyle','none');
        axis([0 10 0 10]);
        title("intersezione");

        subplot(2,3,2);
        plot(cerchioX, cerchioY);
        fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g');
        hold on;
        fill(verticiX, verticiY, 'g', 'LineStyle','none');
        axis([0 10 0 10]);
        title("Unione");

        subplot(2,3,3);
        plot(cerchioX, cerchioY);
        fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g');
        hold on;
        fill(verticiX, verticiY, 'g', 'LineStyle','none');
        hold on;
        plot(x1,y1,'g-',C1(1),C1(2),'w*', 'LineWidth',2, 'LineStyle','none');
        hold on
        fill(x1,y1, 'w', 'LineStyle','none');
        fill(vettoreX,vettoreY, 'w', 'LineStyle','none');
        axis([0 10 0 10]);
        title("Xor");

        if f1 == 0
            subplot(2,3,4);
            plot(cerchioX, cerchioY);
            fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g', 'LineStyle','none');
            hold on;
            plot(x1,y1,'g-',C1(1),C1(2),'w*', 'LineWidth',2, 'LineStyle','none');
            hold on
            fill(x1,y1, 'w', 'LineStyle','none');
            fill(vettoreX,vettoreY, 'w', 'LineStyle','none');
            axis([0 10 0 10]);
            title("Differenza A(blu) - B(rosso)");
        else
            subplot(2,3,4);
            fill(verticiX, verticiY, 'g', 'LineStyle','none');
            hold on;
            plot(x1,y1,'g-',C1(1),C1(2),'w*', 'LineWidth',2, 'LineStyle','none');
            hold on
            fill(x1,y1, 'w', 'LineStyle','none');
            fill(vettoreX,vettoreY, 'w', 'LineStyle','none');
            axis([0 10 0 10]);
            title("Differenza A(blu) - B(rosso)");
        end

        if f2 == 1
            subplot(2,3,5);
            fill(verticiX, verticiY, 'g', 'LineStyle','none');
            hold on;
            plot(x1,y1,'g-',C1(1),C1(2),'w*', 'LineWidth',2, 'LineStyle','none');
            hold on
            fill(x1,y1, 'w', 'LineStyle','none');
            fill(vettoreX,vettoreY, 'w', 'LineStyle','none');
            axis([0 10 0 10]);
            title("Differenza B(rosso) - A(blu)");
        else
            subplot(2,3,5);
            plot(cerchioX, cerchioY);
            fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g', 'LineStyle','none');
            hold on;
            plot(x1,y1,'g-',C1(1),C1(2),'w*', 'LineWidth',2, 'LineStyle','none');
            hold on
            fill(x1,y1, 'w', 'LineStyle','none');
            fill(vettoreX,vettoreY, 'w', 'LineStyle','none');
            axis([0 10 0 10]);
            title("Differenza B(rosso) - A(blu)");
        end
    else 
        
        if ~isempty(puntiInterni)
            %se non ci sono intersezioni ma solo punti interni, il poligono è
            %nel cerchio
            figure(2)
            subplot(2,3,1)
            fill(verticiX, verticiY, 'g', 'LineStyle','none');
            axis([0 10 0 10]);
            title("intersezione");

            subplot(2,3,2);
            plot(cerchioX, cerchioY);
            fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g');
            axis([0 10 0 10]);
            title("Unione");

            subplot(2,3,3);
            plot(cerchioX, cerchioY);
            fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g');
            hold on;
            fill(verticiX, verticiY, 'w', 'LineStyle','none');
            axis([0 10 0 10]);
            title("Xor");

            if f1 == 0
                subplot(2,3,4);
                plot(cerchioX, cerchioY);
                fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g');
                hold on;
                fill(verticiX, verticiY, 'w', 'LineStyle','none');
                axis([0 10 0 10]);
                title("Differenza A(blu) - B(rosso)");
            else
                subplot(2,3,4);
                plot([],[]);
                axis([0 10 0 10]);
                title("Differenza A(blu) - B(rosso)");
            end

            if f2 == 1
                subplot(2,3,5);
                plot([],[]);
                axis([0 10 0 10]);
                title("Differenza B(rosso) - A(blu)");
            else
                subplot(2,3,5);
                plot(cerchioX, cerchioY);
                fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g');
                hold on;
                fill(verticiX, verticiY, 'w', 'LineStyle','none');
                axis([0 10 0 10]);
                title("Differenza B(rosso) - A(blu)");
            end
            
        else
            %se non ci sono punti interni, se il cerchio si trova tra le x e y
            %del poligono, il cerchio è nel poligono
            xMax = vertici(1,1);
            xMin = vertici(1,1);
            yMax = vertici(1,2);
            yMin = vertici(1,2);
            for i = 1:length(vertici)-1
                if vertici(i,1) > xMax
                    xMax = vertici(i,1);
                end
                if vertici(i,1) < xMin
                    xMin = vertici(i,1);
                end
                if vertici(i,2) > yMax
                    yMax = vertici(i,2);
                end
                if vertici(i,2) < yMin
                    yMin = vertici(i,2);
                end
            end
            if xyr(1,1) < xMax && xyr(1,1) > xMin && xyr(1,2) < yMax && xyr(1,2) > yMin
                %il cerchio è dentro il poligono
                figure(2)
                subplot(2,3,1)
                plot(cerchioX, cerchioY);
                fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g');
                axis([0 10 0 10]);
                title("intersezione");

                subplot(2,3,2);
                fill(verticiX, verticiY, 'g', 'LineStyle','none');
                axis([0 10 0 10]);
                title("Unione");

                subplot(2,3,3);
                fill(verticiX, verticiY, 'g', 'LineStyle','none');
                hold on;
                plot(cerchioX, cerchioY);
                fill(cerchioX, cerchioY, 'w', 'LineWidth',2, 'EdgeColor', 'w');
                axis([0 10 0 10]);
                title("Xor");

                if f1 == 0
                    subplot(2,3,4);
                    plot([],[]);
                    axis([0 10 0 10]);
                    title("Differenza A(blu) - B(rosso)");
                else
                    subplot(2,3,4);
                    fill(verticiX, verticiY, 'g', 'LineStyle','none');
                    hold on
                    plot(cerchioX, cerchioY);
                    fill(cerchioX, cerchioY, 'w', 'LineWidth',2, 'EdgeColor', 'w');
                    axis([0 10 0 10]);
                    title("Differenza A(blu) - B(rosso)");
                end

                if f2 == 1
                    subplot(2,3,5);
                    plot(cerchioX, cerchioY);
                    fill(cerchioX, cerchioY, 'g', 'LineWidth',2, 'EdgeColor', 'g');
                    hold on;
                    fill(verticiX, verticiY, 'w', 'LineStyle','none');
                    axis([0 10 0 10]);
                    title("Differenza B(rosso) - A(blu)");
                else
                    subplot(2,3,5);
                    plot([],[]);
                    axis([0 10 0 10]);
                    title("Differenza B(rosso) - A(blu)");
                end
            end
            %se nemmeno questo vale, sono distanti
            fprintf("Non ci sono nè intersezioni nè punti interni tra i due cerchi\n");
            return;
        end
    end
    
elseif vP1 == true && vP2 == true
    %intersezione tra poligoni
    
    xP = poligono1(:, 1);
    yP = poligono1(:, 2);
    xS = poligono2(:, 1);
    yS = poligono2(:, 2);
    
    totInfoInt = [];
    totInfoIn = [];
    totInfoIntIn = [];

    nPunti = 0;

    vettoreIntersezioneX = [];
    verroteIntersezioneY = [];

    calcolaRetteIntersezioni(xP,yP,xS,yS)
    calcolaRetteIntersezioni(xS,yS,xP,yP)

    disp("Rette formate da punto intersezione - punto intersezione")
    totInfoInt
    disp("Rette interne")
    totInfoIn
    disp("Rette formate da punto intersezione - retta interna")
    totInfoIntIn

     rette = []
     for k = 1:height(totInfoInt)
         disp(totInfoInt(k,1) + " - " + totInfoInt(k,2))
         for j = 1:height(totInfoInt) 
             %controllo delle con uguali estremi per k
             continua = 0;
             if totInfoInt(k,3) == totInfoInt(k,5) && totInfoInt(k,4) == totInfoInt(k,6)
                 continua = 1;
             end
                 %controllo delle con uguali estremi per j
                 if totInfoInt(j,3) == totInfoInt(j,5) && totInfoInt(j,4) == totInfoInt(j,6)
                     continua = 1;
                 end
                 if continua == 0
                     if k ~= j
                         if ((totInfoInt(k,3) == totInfoInt(j,3) && totInfoInt(k,4) == totInfoInt(j,4))  && (totInfoInt(k,5) == totInfoInt(j,5) && totInfoInt(k,6) == totInfoInt(j,6)))
                             unito = 1;
                             disp("Il punto " + totInfoInt(k,1) + "," + totInfoInt(k,2) + " termina in " + totInfoInt(j,1) + "," + totInfoInt(j,2))
                             inserisci = 0;
                             for h = 1:height(rette)
                                 x1 = rette(h,1);
                                 y1 = rette(h,2);
                                 x2 = rette(h,3);
                                 y2 = rette(h,4);
                                 if( x1 == totInfoInt(k,1) && y1 == totInfoInt(k,2) && x2 == totInfoInt(j,1) && y2 == totInfoInt(j,2))      
                                     inserisci = 1;
                                 end
                                 if( x2 == totInfoInt(k,1) && y2 == totInfoInt(k,2) && x1 == totInfoInt(j,1) && y1 == totInfoInt(j,2))      
                                     inserisci = 1;
                                 end                    
                             end
                             if inserisci == 0
                                rette = [rette; totInfoInt(k,1) totInfoInt(k,2) totInfoInt(j,1) totInfoInt(j,2)];
                             end    
                         end   
                     end
                 end
         end
     end

    clearTotInfoIn = []

    %eliminazione dei punti
    for i = 1:height(totInfoIn)
        count = 0;
        x1 = totInfoIn(i,1);
        y1 = totInfoIn(i,2);
        x2 = totInfoIn(i,3);
        y2 = totInfoIn(i,4);
        if(x1 == x2 && y1 == y2)
            count = count + 1;
        end   
        for k = 1:height(clearTotInfoIn)
            if x1 == clearTotInfoIn(k,1) && y1 == clearTotInfoIn(k,2) && x2 == clearTotInfoIn(k,3) && y2 == clearTotInfoIn(k,4)
                count = count + 1;
            end    
        end  
        for k = 1:height(clearTotInfoIn)
            if x2 == clearTotInfoIn(k,1) && y2 == clearTotInfoIn(k,2) && x1 == clearTotInfoIn(k,3) && y1 == clearTotInfoIn(k,4)
                count = count + 1;
            end    
        end 
        if count == 0
            clearTotInfoIn = [clearTotInfoIn; x1 y1 x2 y2];
        end    
    end

    clearTotInfoIn

    clearTotInfoIntIn = [];

    %eliminazione dei punti
    for i = 1:height(totInfoIntIn)
        count = 0;
        x1 = totInfoIntIn(i,1);
        y1 = totInfoIntIn(i,2);
        x2 = totInfoIntIn(i,3);
        y2 = totInfoIntIn(i,4);
        if(x1 == x2 && y1 == y2)
            count = count + 1;
        end   
        for k = 1:height(clearTotInfoIntIn)
            if x1 == clearTotInfoIntIn(k,1) && y1 == clearTotInfoIntIn(k,2) && x2 == clearTotInfoIntIn(k,3) && y2 == clearTotInfoIntIn(k,4)
                count = count + 1;
            end    
        end  
        for k = 1:height(clearTotInfoIntIn)
            if x2 == clearTotInfoIntIn(k,1) && y2 == clearTotInfoIntIn(k,2) && x1 == clearTotInfoIntIn(k,3) && y1 == clearTotInfoIntIn(k,4)
                count = count + 1;
            end    
        end 
        if count == 0
            clearTotInfoIntIn = [clearTotInfoIntIn; x1 y1 x2 y2];
        end    
    end

    clearTotInfoIntIn

    %add in rette
    for i = 1:height(clearTotInfoIntIn)
        count = 0;
        x1 = clearTotInfoIntIn(i,1);
        y1 = clearTotInfoIntIn(i,2);
        x2 = clearTotInfoIntIn(i,3);
        y2 = clearTotInfoIntIn(i,4);
        rette = [rette;x1 y1 x2 y2];
        rette
    end

    %add in rette
    for i = 1:height(clearTotInfoIn)
        count = 0;
        x1 = clearTotInfoIn(i,1);
        y1 = clearTotInfoIn(i,2);
        x2 = clearTotInfoIn(i,3);
        y2 = clearTotInfoIn(i,4);
        rette = [rette;x1 y1 x2 y2];
    end

    %matrice con rette di intersezione
    rette

    retteTmpDuplicati = [];

    for i = 1:height(rette)
        x1 = rette(i,1);
        y1 = rette(i,2);
        x2 = rette(i,3);
        y2 = rette(i,4);
        ins = -1;
        for k = 1:height(rette)
            if i ~= k
                xk1 = rette(k,1);
                yk1 = rette(k,2);
                xk2 = rette(k,3);
                yk2 = rette(k,4);
                if x1 == xk1 && x2 == xk2 && y1 == yk1 && y2 == yk2
                    disp("valore duplicato per")
                    disp(x1 + "-" + y1 + "-------" + x2 + "-" + y2)
                    ins = k;
                end

                if x1 == xk2 && x2 == xk1 && y1 == yk2 && y2 == yk1
                    disp("valore duplicato per")
                    disp(x1 + "-" + y1 + "-------" + x2 + "-" + y2)
                    ins = k;
                end
            end    
        end
        retteTmpDuplicati = [retteTmpDuplicati; x1 y1 x2 y2 ins];
    end

    retteTmpDuplicati
    retteRipulite = [];

    for k = 1:height(retteTmpDuplicati)
        if retteTmpDuplicati(k,5) == -1
            x1 = retteTmpDuplicati(k,1);
            y1 = retteTmpDuplicati(k,2);
            x2 = retteTmpDuplicati(k,3);
            y2 = retteTmpDuplicati(k,4);
            retteRipulite = [retteRipulite; x1 y1 x2 y2];
        end    
    end 

    for k = 1:height(retteTmpDuplicati)
        if retteTmpDuplicati(k,5) ~= -1
            x1 = retteTmpDuplicati(k,1);
            y1 = retteTmpDuplicati(k,2);
            x2 = retteTmpDuplicati(k,3);
            y2 = retteTmpDuplicati(k,4);
            inserisci = 0;
            for j = 1:height(retteRipulite)
                xj1 = retteRipulite(j,1);
                yj1 = retteRipulite(j,2);
                xj2 = retteRipulite(j,3);
                yj2 = retteRipulite(j,4);
                if x1 == xj1 && y1 == yj1 && x2 == xj2 && y2 == yj2
                    inserisci = inserisci + 1;
                end

                if x2 == xj1 && y2 == yj1 && x1 == xj2 && y1 == yj2
                    inserisci = inserisci + 1;
                end
            end    
            if inserisci == 0
                retteRipulite = [retteRipulite; x1 y1 x2 y2];
            end    
        end    
    end 

    totInfoIntIn
    totInfoIn
    retteRipulite

    retteWithoutPoint = [];

    for k = 1:height(rette)
        x1 = rette(k,1);
        y1 = rette(k,2);
        x2 = rette(k,3);
        y2 = rette(k,4);
        if x1 == x2 && y1 == y2
            disp("esiste un duplicato")
        else
            retteWithoutPoint = [retteWithoutPoint;x1 y1 x2 y2];
        end    
    end    

    retteMenoUno = [];

    for k = 1:height(retteRipulite)
        x1 = retteRipulite(k,1);
        y1 = retteRipulite(k,2);
        x2 = retteRipulite(k,3);
        y2 = retteRipulite(k,4);
        if x1 == x2 && y1 == y2
            disp("esiste un duplicato")
        else
            retteMenoUno = [retteMenoUno;x1 y1 x2 y2];
        end    
    end  

    retteMenoUno

    totInfoTmp = [];

    corrispondenzaKH = [];

    totInfoInt

    for k = 1:height(totInfoInt)
        x = totInfoInt(k,1);
        y = totInfoInt(k,2);
        for h = 1:height(totInfoInt)
            if k ~= h
                permesso = 0;
                if ((totInfoInt(k,3) == totInfoInt(k,5)) && (totInfoInt(k,4) == totInfoInt(k,6)))
                    permesso = 1;
                end
                if ((totInfoInt(h,3) == totInfoInt(h,5)) && (totInfoInt(h,4) == totInfoInt(h,6)))
                    permesso = 1;
                end
                if x == totInfoInt(h,1) && y == totInfoInt(h,2)
                    permesso = 1;
                end
                if ((totInfoInt(k,3) == totInfoInt(k,4)) || (totInfoInt(k,5) == totInfoInt(k,6)))
                    permesso = 1;
                end
                if ((totInfoInt(h,3) == totInfoInt(h,4)) || (totInfoInt(h,5) == totInfoInt(h,6)))
                    permesso = 1;
                end
                if permesso == 0
                    if ((totInfoInt(k,3) == totInfoInt(h,3)) && (totInfoInt(k,4) == totInfoInt(h,4)) && (totInfoInt(k,5) == totInfoInt(h,5)) && (totInfoInt(k,6) == totInfoInt(h,6)))
                        presente = 0;
                        for i = 1:height(corrispondenzaKH)                       
                            elementoK = corrispondenzaKH(i,1);
                            elementoH = corrispondenzaKH(i,2);
                            if (elementoK == k && elementoH == h)
                                presente = 1;
                            end
                            if (elementoK == h && elementoH == k)
                                presente = 1;
                            end
                            if (corrispondenzaKH(i,3) == x && corrispondenzaKH(i,4) == y) && (corrispondenzaKH(i,5) == totInfoInt(h,1) && corrispondenzaKH(i,6) == totInfoInt(h,2))
                                presente = 1;
                            end
                            if (corrispondenzaKH(i,5) == x && corrispondenzaKH(i,6) == y) && (corrispondenzaKH(i,3) == totInfoInt(h,1) && corrispondenzaKH(i,4) == totInfoInt(h,2))
                                presente = 1;
                            end
                        end
                        if presente == 0
                            corrispondenzaKH = [corrispondenzaKH;k h totInfoInt(k,1) totInfoInt(k,2) totInfoInt(h,1) totInfoInt(h,2) totInfoInt(k,3) totInfoInt(k,4) totInfoInt(k,5) totInfoInt(k,6)];
                        end
                    end
                end    
            end     
        end    
    end   

    corrispondenzaKH

    for k = 1:height(corrispondenzaKH)
        fx = corrispondenzaKH(k,7);
        fy = corrispondenzaKH(k,8);
        sx = corrispondenzaKH(k,9);
        sy = corrispondenzaKH(k,10);
        disp("Confronto gli estremi (" + fx + "," + fy + ") e (" + sx + "," + sy + ")")
        for j = 1:height(corrispondenzaKH)
            if corrispondenzaKH(j,3) == fx && corrispondenzaKH(j,4) == fy
                disp("(" + corrispondenzaKH(j,3) + "," + corrispondenzaKH(j,4) + ") punto di interesse")
                disp("(" + corrispondenzaKH(j,3) + "," + corrispondenzaKH(j,4) + ")" + "(" + corrispondenzaKH(j,5) + "," + corrispondenzaKH(j,6) + ") retta di interesse")
            end
            if corrispondenzaKH(j,5) == fx && corrispondenzaKH(j,6) == fy
                disp("(" + corrispondenzaKH(j,5) + "," + corrispondenzaKH(j,6) + ") punto di interesse")
                disp("(" + corrispondenzaKH(j,3) + "," + corrispondenzaKH(j,4) + ")" + "(" + corrispondenzaKH(j,5) + "," + corrispondenzaKH(j,6) + ") retta di interesse")
            end
            if corrispondenzaKH(j,3) == sx && corrispondenzaKH(j,4) == sy
                disp("(" + corrispondenzaKH(j,3) + "," + corrispondenzaKH(j,4) + ") punto di interesse")
                disp("(" + corrispondenzaKH(j,3) + "," + corrispondenzaKH(j,4) + ")" + "(" + corrispondenzaKH(j,5) + "," + corrispondenzaKH(j,6) + ") retta di interesse")
            end
            if corrispondenzaKH(j,5) == sx && corrispondenzaKH(j,6) == sy
                disp("(" + corrispondenzaKH(j,5) + "," + corrispondenzaKH(j,6) + ") punto di interesse")
                disp("(" + corrispondenzaKH(j,3) + "," + corrispondenzaKH(j,4) + ")" + "(" + corrispondenzaKH(j,5) + "," + corrispondenzaKH(j,6) + ") retta di interesse")
            end
        end
    end

    disp("Readme")
    disp(height(retteMenoUno))

    disp("Punti di intersezione")
    disp("(x,y)")

    for k = 1:length(vettoreIntersezioneX)
        x = vettoreIntersezioneX(k);
        y = verroteIntersezioneY(k);
        disp("(" + x + "," + y + ")");
    end

    retteDaEliminare = [];

    %ricerca delle rette inutili
    for k = 1:height(retteMenoUno)
        fx = retteMenoUno(k,1);
        fy = retteMenoUno(k,2);
        sx = retteMenoUno(k,3);
        sy = retteMenoUno(k,4);
        for j = 1:height(retteMenoUno)
            if j ~= k
                fjx = retteMenoUno(j,1);
                fjy = retteMenoUno(j,2);
                sjx = retteMenoUno(j,3);
                sjy = retteMenoUno(j,4);
                controllo = 0;
                test = [];
                if fy == sy
                    controllo = 1;
                    test = polyshape([fx sx sx fx],[fy sy sy+0.001 fy+0.001]);
                end
                if fx == sx 
                    controllo = 1;
                    test = polyshape([fx sx sx+0.001 fx+0.001],[fy sy sy fy]);
                end
                if controllo == 0
                    test = polyshape([fx sx sx+0.001 fx+0.001],[fy sy sy fy]);
                end
                fP = isinterior(test,[fjx fjy]);
                sP = isinterior(test,[sjx sjy]);
                if fP == 1 && sP == 1
                    disp("Ho trovato una retta ridondante")
                    disp(fx + "," + fy + "-------" + sx + "," + sy)
                    retteDaEliminare = [retteDaEliminare; fx fy sx sy];
                end
            end
        end
    end

    retteDaRipulire = [];

    for h = 1:height(retteMenoUno)
        count = 0;
        fx = retteMenoUno(h,1);
        fy = retteMenoUno(h,2);
        sx = retteMenoUno(h,3);
        sy = retteMenoUno(h,4);
        for k = 1:height(retteDaEliminare)
            fkx = retteDaEliminare(k,1);
            fky = retteDaEliminare(k,2);
            skx = retteDaEliminare(k,3);
            sky = retteDaEliminare(k,4);
            if fx == fkx && fy == fky && sx == skx && sy == sky
                count = count + 1;
            end
        end
        if count == 0
            retteDaRipulire = [retteDaRipulire; fx fy sx sy];
        end
    end

    retteDaRipulire
    ripulisci = 0
    numeroCicli = 0

    while ripulisci == 0
        for k = 1:height(retteDaRipulire)
            countF = 0;
            countS = 0;
            ripulisci = 1;
            fx = retteDaRipulire(k,1);
            fy = retteDaRipulire(k,2);
            sx = retteDaRipulire(k,3);
            sy = retteDaRipulire(k,4);
            for t = 1:height(retteDaRipulire)
                if t ~= k
                    ftx = retteDaRipulire(t,1);
                    fty = retteDaRipulire(t,2);
                    stx = retteDaRipulire(t,3);
                    sty = retteDaRipulire(t,4);
                if fx == ftx && fy == fty
                    countF = countF + 1;
                end
                if fx == stx && fy == sty
                    countF = countF + 1;
                end 
                if sx == ftx && sy == fty
                    countS = countS + 1;
                end
                if sx == stx && sy == sty
                    countS = countS + 1;
                end 
                end
            end
            if countF == 0 || countS == 0
                disp("Retta con cardinalità 1 " + fx + "," + fy + " ------- " + sx + "," + sy)
                retteDaRipulire(k,:) = [];
                ripulisci = 0;
                numeroCicli = numeroCicli + 1;
                break;
            end
        end
    end


    %variabili per disegno interserzione
    vettoreX = [];
    vettoreY = [];
    nRette = height(retteDaRipulire-numeroCicli);
    continua = 0;
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;

    %controllo ordine disegno dei punti
    while continua == 0
        if length(vettoreX) == nRette
            continua = 1;
            break;
        end       
        if length(vettoreX) == 0
            x1 = retteDaRipulire(1,1);
            y1 = retteDaRipulire(1,2);
            x2 = retteDaRipulire(1,3);
            y2 = retteDaRipulire(1,4);
            vettoreX(end+1) = x1;
            vettoreY(end+1) = y1;
            vettoreX(end+1) = x2;
            vettoreY(end+1) = y2;
            retteDaRipulire(1,:) = [];
            continue;
        end

        for u = 1:height(retteDaRipulire)
            tmpX1 = retteDaRipulire(u,1);
            tmpY1 = retteDaRipulire(u,2);
            tmpX2 = retteDaRipulire(u,3);
            tmpY2 = retteDaRipulire(u,4);
            if (tmpX1 == x2 && tmpY1 == y2) || (tmpX2 == x2 && tmpY2 == y2) 
                if (tmpX1 == x2 && tmpY1 == y2)
                    vettoreX(end+1) = tmpX2;
                    vettoreY(end+1) = tmpY2;
                    x2 = tmpX2;
                    y2 = tmpY2;
                    retteDaRipulire(u,:) = [];
                    break;
                else
                    vettoreX(end+1) = tmpX1;
                    vettoreY(end+1) = tmpY1;
                    x2 = tmpX1;
                    y2 = tmpY1;
                    retteDaRipulire(u,:) = [];
                    break;
                end    
            end    
       end

    end


    vettoreX
    vettoreY

    intersezione = polyshape(vettoreX,vettoreY)
    fill(vettoreX,vettoreY,'w','EdgeColor','w')

    figure(2)
    subplot(2,3,1)
    fill(vettoreX,vettoreY,'g','EdgeColor','w')
    axis([0 10 0 10]);
    title('Intersezione')

    subplot(2,3,2)
    fill(xP,yP,'g','EdgeColor','g')
    hold on
    fill(xS,yS,'g','EdgeColor','g')
    hold on
    fill(vettoreX,vettoreY,'g','EdgeColor','g')
    axis([0 10 0 10]);
    title('Unione')

    subplot(2,3,4)
    fill(xP,yP,'g','EdgeColor','g')
    hold on
    fill(vettoreX,vettoreY,'w','EdgeColor','w')
    axis([0 10 0 10]);
    title('Differenza A(blu) - B(rosso)')

    subplot(2,3,5)
    fill(xS,yS,'g','EdgeColor','g')
    hold on
    fill(vettoreX,vettoreY,'w','EdgeColor','w')
    axis([0 10 0 10]);
    title('Differenza B(rosso) - A(blu)')
    
end


