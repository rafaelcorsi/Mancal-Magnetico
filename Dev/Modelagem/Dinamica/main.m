%% exporta os dados ?
global exportar;
exportar = 0;


%% parametriza mancal

parametros_geometricos;
parametros_magneticos;

m_g=derivados_geometricos(m,0,0);


parametrizaMancal;



%% Analise
pole(G)

%% Bode
% analise frequencia
figure
rlocus(G)
title('');
belezura
export_pdf('Dinamica/Resultados/rlocus:pnt:operacao',1);

%%
figure
bode(G)
title('')
export_pdf('Dinamica/Resultados/bode:pnt:operacao',1);

%% simulaçao impacto
load('simualcao:saturacao:mancal.mat')
plot(scope_d.time(1:80), scope_d.signals.values(1:80,:));
xlabel('Tempo (s)');
ylabel('Posicao (m)');
belezura
export_pdf('dinamica:choque:rotor');

%% simulacao com corrente
load('simualcao:corrente:mancal.mat');
t = find(scope_fb.time >= 0.98, 1);

subplot1 = subplot(3,1,1);
plot(scope_vb.time(t:t+1500), scope_vb.signals.values(t:t+1500,:));
title('Tensao aplicada nas bobinas');
xlabel('t (s)')
ylabel('E (V)')
belezura

subplot(3,1,2)
plot(scope_ib.time(t:t+1500), scope_ib.signals.values(t:t+1500,:));
title('Corrente nas bobinas');
xlabel('t (s)')
ylabel('i (A)')
belezura

subplot(3,1,3)
plot(scope_pr.time(t:t+1500), scope_pr.signals.values(t:t+1500,:));
title('Deslocamento do rotor');
xlabel('t (s)')
ylabel('\Delta (m)')
belezura
export_pdf('dinamica:corrente:rotor');
