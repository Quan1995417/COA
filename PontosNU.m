clc, clear all, close all

% Pontos dispon�veis
meusPontos = 24308;

% Mercado (1-14), Farm�cia (15-16), Netflix (17-23), iFood(24-30)
C = [12490 3116 3221 2556 320 1264 14044 560 640 3182 4632 3488 2044 1183 8856 ...
     319 3672 3032 3032 3032 3032 3032 3032 3888 5192 1720 2560 2879 7712 ...
     8280];

% Defini��o do problema
D = length(C);
lu = [ zeros(1,D); ones(1,D)];
fobj = @(x) (meusPontos-sum(C(x>0.5))  + ...
            (sum(C(x>0.5))>meusPontos) * ...
            (10^9)*(abs(sum(C(x>0.5))-meusPontos)));

% Configura��o do algoritmo
attemps = 5;
NCOY = 10;
NPACKS = 5;
nfevalMAX = 10000*D;
pop = zeros(attemps,D);
val = zeros(attemps,1);
for at=1:attemps
    tini = clock();
    fprintf(1,'Tentativa %d, iniciando...', at);
    [pop(at,:),val(at,1)] = COA(fobj, lu, nfevalMAX, NPACKS, NCOY);                    
    fprintf(1,'\nMenor custo: %.2f', val(at,1));
    fprintf(1,'\nProcesso encerrado com %.2f segundos! \n\n', ...
        etime(clock(),tini));
end

% Melhor solu��o
[~, ind] = min(val);
popBest  = pop(ind, :);

% Apresenta��o do resultado
quais = popBest>0.5;
fprintf(1,'Apagar a compra #%d com %d pontos; \n',...
    [find(quais);C(quais)]);
fprintf(1,'\nTotal de pontos usados: %d', sum(C(quais)));
fprintf(1,'\nSobraram apenas %d pontos! :)\n', ...
    meusPontos - sum(C(quais)));