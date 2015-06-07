%% Circuito Ativo, modelagem nao linear
% Rafael Corsi
% 4/15
% Mancal Magnético
clc
clear all

%% Parametros

load iron;

parametros_geometricos;
parametros_magneticos;

%% inicializacao
% Deslocamentos relativos
dx = 0;
dy = 0;
I  = [10 0 0 0 0 0 0 0 0 0];

% Forcas eletromotriz
F = I*m.nnb;

% derivados
m = derivados_geometricos(m,dx,dy);

% Permeabilidade inicial do rotor
ufr0 = 4E4;
ufn0 = 4E4;
uff0 = 4E4;

%      AB    BC   CD   DE   EF   FG   GH   HA
ufr = [ufr0 ufr0 ufr0 ufr0 ufr0 ufr0 ufr0 ufr0]';
ufn = [ufn0 ufn0 ufn0 ufn0 ufn0 ufn0 ufn0 ufn0]';
uff = [uff0 uff0 uff0 uff0 uff0 uff0 uff0 uff0]';
% Relutancais

% calcula gap com base no deslocamento x e y do rotor
lg =lgap(m);
lr = m.prr/8;
lf = m.peie/8;
ln = m.wnb;

% calcula relutancia gaps
Rg = Rm(lg,m.Snbe,mag.u0);

%% inicio interação
ufn0 = ufn;
ufr0 = ufr;
uff0 = uff;

% loop para convergencia
% método de Newton
for i=1:300
    
    if(i>1)
        Hn0 = Hn;
        Hr0 = Hr;
        Hf0 = Hf;
    end;
    
    % calcula relutancais rotor
    Rr = Rm(lr,m.Srr, ufr);
    
    % calcula relutancais nucleo
    Rn = Rm(ln, m.Snbe, ufn);
    
    % calcula retorno estator
    Rf = Rm(lf, m.Sei, uff);
    
    % resolve malhas
    malhas;
    
    % Vetor campo mag. calcula campos nos componentes
    Bg = abs(phi/m.Sgi/1.1);
    Bn = abs(phi/m.Snbe);
    Br = abs(I/m.Srrr);
    Bf = abs(I/m.Sei);
    
    Hg = Bg/mag.u0;
    Hn = Bn'/diag(ufn);
    Hr = Br'/diag(ufr);
    Hf = Bf'/diag(uff);
    
    % Atualiza permeabilidades
    % via método de newton-rapson
    if i==1
        ufn = iron.MuH(Hn)/2 + ufn/2;
        ufr = iron.MuH(Hr)/2 + ufr/2;
        uff = iron.MuH(Hf)/2 + uff/2;
    else
        ufn = ufn + (Hn-Hn0)'./(ufn-ufn0);
        ufr = ufr + (Hr-Hr0)'./(ufr-ufr0);
        uff = uff + (Hf-Hf0)'./(uff-uff0);
    end;

    auxHr(i) = Hr(1);
    auxHn(i) = Hn(1);
    auxHf(i) = Hf(1);
    
end;

%% Força

projecao = diag([1 0.7071 1 0.7071 1 0.7071 1 0.7071]);

Fmag = ((Bg.^2*m.Sgi)/(2*mag.u0))'*projecao;

Fx = Fmag(1) + Fmag(2) - Fmag(4) - Fmag(5) -Fmag(6) + Fmag(8)

Fy = -Fmag(2)-Fmag(3)-Fmag(4)+Fmag(6)+Fmag(7)+Fmag(8)

figure; plot(auxHr)
figure; plot(auxHn, 'g')
figure; plot(auxHf, 'b')

