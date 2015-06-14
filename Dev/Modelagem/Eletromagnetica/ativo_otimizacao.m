%% Otimização dos parâmetros
% Etapas : 
%   a. definir funcional
%   b. definir parametros e range e stap
%   c. realizar interações
%
% usando o método Simplex (sem derivadas) para otimizar
%
% a. Funcional 
%   - Fx >>
%               Queremos uma força de atração Fx na maior excursão
%
%   - L  <<
%               Queremos uma indutancia pequena
%
%   - Volume_m  <<
%               Queremos um volume menor -> menor peso
%

clear all;
clc; 

% variáveis globais para armazenamento dos valores intermediaários
global Fx;
global L;
global V;

% versao da funcao merito a ser utilizada
global version;

% carrega valore iniciais
parametros_geometricos;

%  [wgi     nnb     hnb     lnb    wei      rnb
V0=[0.6E-3  300     10E-3   22E-3  6E-3     12E-3];
LO=[0.4E-3  50      5E-3    10E-3  3E-3     6E-3];
UB=[1.2E-3  600     20E-3   30E-3  10E-3    22E-3];
po = V0;

% configura otimizacao
options = optimset( 'Display', 'iter',  ...
                   'TolX',0.1,'TolFun',0.1, ...
                   'MaxIter', inf);

% contador para armazenameto dos resultados
in = 1;

%% Executa otimização

%define funcao merito
version = 4;        

% executa otmizacao
[x,fval] = fminsearchbnd('funcional', po, LO, UB, options);


%% Resultados
figure
h1 = subplot(2,1,1); 

subplot(2,2,1); 
    plot(1:in-1, Fx,'o'); 
    title('F_x');
    belezura;
subplot(2,2,2); 
    plot(1:in-1, Fy,'o');
    title('F_y');
    belezura;
subplot(2,2,3); 
    plot(1:in-1, V,'o');
    title('Volume');
    belezura;
subplot(2,2,4); 
    plot(1:in-1, dBef, 'o ');
    title('$$\Delta B_{ef}$$', 'Interpreter','latex');
    belezura;
    
export_pdf('Resultados/otimizacao_passivo_parametros',1);
    
%% pesos funcionais

[F, P1, P2, P3, P4 ] = merito( Fx, Fy, V, dBef, m, version );

figure
    plot(P1)
hold on
    plot(P2, 'r')
    plot(P3, 'g')
    plot(P4, 'c')
    plot(F,  'm')
title('pesos');
legend('P1', 'P2', 'P3', 'P4', 'F'); 
belezura

export_pdf('Resultados/otimizacao_passivo_pesos',1);

