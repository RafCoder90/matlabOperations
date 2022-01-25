function [cerchioInterno, cerchioEsterno] = cerchiConcentrici(cerchio1, cerchio2)
    xCentro1 = cerchio1(:,1);
    xCentro2 = cerchio2(:,1);
    yCentro1 = cerchio1(:,2);
    yCentro2 = cerchio2(:,2);
    r1 = cerchio1(:,3);
    r2 = cerchio2(:,3);
    
    xMin1 = xCentro1 - r1;
    xMin2 = xCentro2 - r2;
    xMax1 = xCentro1 + r1;
    xMax2 = xCentro2 + r2;
    
    yMin1 = yCentro1 - r1;
    yMin2 = yCentro2 - r2;
    yMax1 = yCentro1 + r1;
    yMax2 = yCentro2 + r2;

    if xMax1 < xMax2 && xMin1 > xMin2 && yMax1 < yMax2 && yMin1 > yMin2
        fprintf("Il cerchio blu con centro (" + xCentro1 + ", " + yCentro1 + "), e raggio " + r1 + ...
                " è interno al cerchio rosso con centro (" + xCentro2 + ", " + yCentro2 + "), e raggio " + r2 + "\n");
        cerchioInterno = cerchio1;
        cerchioEsterno = cerchio2;
    elseif xMax1 > xMax2 && xMin1 < xMin2 && yMax1 > yMax2 && yMin1 < yMin2
        fprintf("Il cerchio rosso con centro (" + xCentro2 + ", " + yCentro2 + "), e raggio " + r2 + ...
                " è interno al cerchio blu con centro (" + xCentro1 + ", " + yCentro1 + "), e raggio " + r1 + "\n");
        cerchioInterno = cerchio2;
        cerchioEsterno = cerchio1;
    else 
        cerchioInterno = [NaN,NaN,NaN];
        cerchioEsterno = [NaN,NaN,NaN];
    end

end