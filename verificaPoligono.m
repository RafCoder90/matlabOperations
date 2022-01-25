function poligono = verificaPoligono(polDaVerificare)
    if isempty(polDaVerificare)
        fprintf("NO\n");
        poligono = false;
    else
        fprintf("SI\n");
        poligono = true;
    end
end