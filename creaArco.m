function [x,y,C] = creaArco(cerchio, punti)
    %Punto A sulla circonferenza
    A = punti(1,1:2);       
    A = [A(1,1);A(1,2)];
    
    %Punto B
    B = punti(2,1:2);       
    B = [B(1,1);B(1,2)];
    
    %Raggio R
    R = cerchio(1,3);       
    
    %Centro del cerchio
    C = cerchio(1,1:2);     
    a = atan2(A(2)-C(2),A(1)-C(1));
    b = atan2(B(2)-C(2),B(1)-C(1));
    
    %L'arco si muoverà in senso antiorario
    b = mod(b-a,2*pi)+a;    
    t = linspace(a,b,1000);
    x = C(1)+R*cos(t);
    y = C(2)+R*sin(t);
end