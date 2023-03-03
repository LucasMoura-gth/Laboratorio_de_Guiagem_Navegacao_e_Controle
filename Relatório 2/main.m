%Problema de dois corpos

%Constantes
mi_Terra = 3.986*(10^5); %km3/s2

%-----------------------------------------------------------

%Resolucoes

%Item a
%two lines: 2 07276 64.2707 228.5762 6489050 281.4937 16.8767 2.45097347248963

%Convers?o da anomalia media para verdadeira
%theta_a = 16.8767
theta_a = converter_anomalia_media_verdadeira(deg2rad(16.8767), 0.6489050);

%Semieixo maior
[semieixo_a, n_a] = semieixoMaior(mi_Terra, 2.4509);

%Coordenada Orbital
[xo_a, yo_a, zo_a] = dirOrbital(deg2rad(theta_a), 0.6489050, semieixo_a);

%Coordenada Inercial
coordInercial_a = matrizTranspostaRotacao(deg2rad(64.2707), deg2rad(281.4937), deg2rad(228.5762)) * [xo_a; yo_a; zo_a];

%Velocidade Orbital
[vx_a, vy_a, vz_a] = velOrbital(n_a, 0.6489, deg2rad(theta_a),semieixo_a);

%Velocidade Inercial
velocidadeInercial_a = matrizTranspostaRotacao(deg2rad(64.2707), deg2rad(281.4937), deg2rad(228.5762)) * [vx_a; vy_a; vz_a];

%--------------------------------------------------------

%item b
%two lines: 2 02717 0.7404 32.0789 0014515 234.9766 357.1212 1.00360058109167

%Convers?o da anomalia media para verdadeira
%theta_b = 357.1212
theta_b = converter_anomalia_media_verdadeira(deg2rad(357.1212),0.0014515);

%Semieixo maior
[semieixo_b, n_b] = semieixoMaior(mi_Terra, 1.0036);


%Coordenada Orbital
[xo_b, yo_b, zo_b] = dirOrbital(deg2rad(theta_b), 0.0014515, semieixo_b);

%Coordenada Inercial
coordInercial_b = matrizTranspostaRotacao(deg2rad(0.7404), deg2rad(234.9766), deg2rad(32.0789)) * [xo_b; yo_b; zo_b];

%Velocidade Orbital
[vx_b, vy_b, vz_b] = velOrbital(n_b, 0.0014515, deg2rad(theta_b), semieixo_b);

%Velocidade Inercial
velocidadeInercial_b = matrizTranspostaRotacao(deg2rad(0.7404), deg2rad(234.9766), deg2rad(32.0789)) * [vx_b; vy_b; vz_b];

%Aplicacaoo do processo de integracao
%ODE 45

%Dados do Item a
T_a = 2*pi/n_a;
r_a = coordInercial_a';
v_a = velocidadeInercial_a';

%Dados do Item b
T_b = 2*pi/n_b;
r_b = coordInercial_b';
v_b = velocidadeInercial_b';

%Condicao inicial do item A
InitCond = [r_a v_a];

%Condicao inicial do item B
InitCond2 = [r_b v_b];

%Solucoes ODE45 (Possivel modificar e multiplicar T_a e T_b (quantidade de periodos))
options = odeset('RelTol',1e-12); %minimizacao do erro 

%Item a:
[Times,Out] = ode45(@edos, [0 1*T_a], InitCond, options);

%Solucao para o item b
[Times2,Out2] = ode45(@edos, [0 1*T_b], InitCond2, options);

%N = length(Out2);
%j = (1:N-1)';
%w = 0.00007272; %rad/s
%delta_t = T_b/(N-1);


r1 = Out(:,1);
r2 = Out(:,2);
r3 = Out(:,3);
lat = asin(r3./(sqrt(r1.^2 + r2.^2 + r3.^2)));
long = atan(r2./r1);

geoplot(rad2deg(lat), rad2deg(long),'.')



