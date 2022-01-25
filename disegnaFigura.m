function figura = disegnaFigura(colore, scelta)
    if scelta == 0
        grid on;
        axis([0 10 0 10]);
        c = drawcircle('Color', colore);
        c.InteractionsAllowed = 'none';
        figura = [c.Center, c.Radius];
    end
    if scelta == 1
        grid on;
        axis([0 10 0 10]);
        p = drawpolygon('Color', colore);
        p.InteractionsAllowed = 'none';
        figura = p.Position; 
    end
end