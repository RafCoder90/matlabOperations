function [xunit, yunit] = circle(cerchio)

    x = cerchio(1,1);
    y = cerchio(1,2);
    r = cerchio(1,3);

    hold on
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    
end