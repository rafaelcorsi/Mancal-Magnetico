%% Circuito Ativo, modelagem nao linear
% Rafael Corsi
% 4/15
% Mancal Magnético
clc
%clear all

%% load dados
load Bobinas-eq-10A;

%%
parametros_geometricos;
parametros_magneticos;

%% inicializacao
% Deslocamentos relativos
dy = 0;
x=1;
for Im=0:0.5:4
    I  = [Im -Im/2 0 0 0 0 0 -Im/2];
    for dx=-0.3E-3:0.1E-3:0.3E-3
        [Fx(x) Fy(x) L(x)] = resolve_ativo(dx,dy,I);
        x = x+1;
    end;
end;

%% Gera vetor comsol
c = 1;
xx =1;
yy =1;

for y=0:0.5:4
    for x=-0.3:0.1:0.3
        if y == 0 
            Comsolf(xx,yy) = 0;
        else
            Comsolf(xx,yy) = Comsol(c,3);
            c = c+1;
        end
        xx = xx +1;
    end
    yy = yy + 1;
    xx = 1;
end

%% Gera vetor analitico
c = 1;
xx =1;
yy =1;

for y=0:0.5:4
    for x=-0.3:0.1:0.3
        if y == 0 
            Corsif(xx,yy) = 0;
        else
            Corsif(xx,yy) = Fx(c);
            c = c+1;
        end
        xx = xx +1;
    end
    yy = yy + 1;
    xx = 1;
end

%% Plota 

[X Y] = meshgrid(0:0.5:4,-0.3:0.1:0.3);
    subplot(1,2,1)
    surf(X,Y,Corsif*1.1);
    title('Analitico');
    ylabel('dx [mm]');
    xlabel('I [A]');
    zlabel('F [N]');
    belezura;
subplot(1,2,2)
    surf(X,Y,Comsolf);
    title('FEM');
    colormap(jet)    % change color map
    ylabel('dx [mm]');
    xlabel('I [A]');
    zlabel('F [N]');
    belezura;
    
export_pdf('Resultados/validacao_ativo_map.pdf',0); 

%title('Force (N) x current (A) x displacment (mm)')

%%
[X Y] = meshgrid(0:0.5:4,-0.3:0.1:0.3);
figure
surf(X,Y,Corsif*1.1);
title('Analitico');
ylabel('dx [mm]');
xlabel('I [A]');
zlabel('F [N]');
export_pdf('Resultados/validacao_ativo_map_analitico.pdf',0); 

figure
surf(X,Y,Comsolf);
title('FEM');
colormap(jet)    % change color map
ylabel('dx [mm]');
xlabel('I [A]');
zlabel('F [N]');
export_pdf('Resultados/validacao_ativo_map_fem.pdf',0); 

    
%%
figure
plot(Comsol(:,3));
hold
plot(Fx(7:end), 'r');
legend('FEM', 'Analitico', 'Location','NorthWest');  
xlabel('Modelo'); 
ylabel('F (N)')
belezura
export_pdf('Eletromagnetica/Resultados/validacao_ativo_2d.pdf',1); 
