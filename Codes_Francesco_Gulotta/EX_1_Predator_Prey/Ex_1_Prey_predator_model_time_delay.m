%timesteps are equally spaced
clear;
clc;

showshore=[20 20 52 83 64 68 83 12 36 150 110 60 7 10 70 100 92 70 10 11 137 137 18 22 52 83 18 10 9 65];
canadalynx=[32 50 12 10 13 36 15 12 6 6 65 70 40 9 20 34 45 40 15 15 60 80 26 18 37 50 35 12 12 25];
dt=2;%2years
%{
time_plot=1845:2:1903;
plot(time_plot,showshore),hold on,plot(time_plot,canadalynx)
legend('Showshore','Canada Lynx')
title('Population ')
xlabel('years')
ylabel('Population size [thousands]')
%}
t_forcast=0:dt:59;
time_final=30; 

X(1,:)=showshore(:,1: time_final-1);%Xpreda
X(2,:)=canadalynx(:,1: time_final-1);%Xpredatore

X1(1,:)=showshore(:,2:time_final);%Xprime preda
X1(2,:)=canadalynx(:,2:time_final);%XPrime predatore

%{
plot(X(1,:))
hold on
plot(X(2,:))
legend('preda','predatore')
%}


[U,S,V] = svd(X,'econ'); % SVD economy decomposition using 

figure(1) % plot to evaluate r 
plot(diag(S)/sum(diag(S)),'ro') %
legend('sigma')
xlabel('modes')
ylabel('sigma relative')


r=2;

Ur=U(:,1:r);%truncation
Sr=S(1:r,1:r);
Vr=V(:,1:r);

Atilde=Ur'*X1*Vr*inv(Sr);
[W,Lambda] = eig(Atilde); %Eigenvalue calculation



Phi = X1*Vr*inv(Sr)*W; 
Alpha1=Sr*Vr(1,:)';
b = (W*Lambda)\Alpha1;

mu=diag(Lambda);
omega=log(mu)/dt;

plot(real(omega), imag(omega),'ro') % eigenvalues plot for stability
hold on 
xL = [-1,+1];
yL = [-1,+1];
line([0 0], yL,'Color','black');  %y-axis
line(xL, [0 0],'Color','black'); %x_Axis
legend('Eigenvalues')
xlabel('Real Part')
ylabel('Imaginary Part')
grid on

u(1,1)=X(1,1);
u(2,1)=X(2,1);

y0 = Phi\u; %initial condition

% expansion and future forcast of the system
for iter = 1:numel(t_forcast)
    u_modes(:,iter) =(y0.*exp(omega*(t_forcast(iter))));
end

u_dmd = Phi*u_modes; 

plot(u_dmd(1,:));
hold on
plot(u_dmd(2,:));
 %% Delay Matrix
a=1;

clear X X1
dt=2;
t_forcast=0:dt:59;
time_final=30; 
showshore=[20 20 52 83 64 68 83 12 36 150 110 60 7 10 70 100 92 70 10 11 137 137 18 22 52 83 18 10 9 65];
canadalynx=[32 50 12 10 13 36 15 12 6 6 65 70 40 9 20 34 45 40 15 15 60 80 26 18 37 50 35 12 12 25];

X(1,:)=showshore(:,1: time_final-1);%X prey 
X(2,:)=canadalynx(:,1: time_final-1);%Xpredatot

X1(1,:)=showshore(:,2:time_final);%Xprime prey 
X1(2,:)=canadalynx(:,2:time_final);%XPrime predator

x_size=numel(X);

n_delay=12; %number of time delay

 Xdelay=[];
 X1delay=[];

for j=1:1:n_delay
 Xdelay=[Xdelay;X(1:2,j:time_final-n_delay-1+j)];
 X1delay=[X1delay;X1(1:2,j:time_final-n_delay-1+j)];

 end   

[U,S,V] = svd(Xdelay,'econ');
figure(33)
plot(diag(S)/sum(diag(S)),'ro')
legend('sigma n_{delay}=12')
xlabel('modes')
ylabel('sigma relative')

r=10;
Ur=U(:,1:r); %truncation
Sr=S(1:r,1:r);
Vr=V(:,1:r);

Atilde=Ur'* X1delay*Vr/Sr;
[W,Lambda] = eig(Atilde);

Phi =X1delay*Vr/Sr*W; % Step 4
Alpha1=Sr*Vr(1,:)';
b = (W*Lambda)\Alpha1;

mu=diag(Lambda);
omega=log(mu)/dt;
figure(67)
plot(real(omega), imag(omega),'ro')
hold on 
xL = [-1,+1];
yL = [-2,+2];
line([0 0], yL,'Color','black');  %y-axis
line(xL, [0 0],'Color','black'); %x_Axis
legend('Eigenvalues')
xlabel('Real Part')
ylabel('Imaginary Part')
grid on




y0 = Phi\Xdelay(:,1);

u_modes=[];
%modal expansion and forcast of the system

for iter = 1:numel(t_forcast)
    u_modes(:,iter) =(y0.*exp(omega*(t_forcast(iter))));
end


u_dmd = Phi*u_modes;

%plot for the report

figure(34)
t_plot=1845:2:1903; %real time axis
plot(t_plot,abs(u_dmd(1,:)).'),
hold on
plot(t_plot,showshore(1:numel(t_forcast)))
legend('DMD Forcast','Showshore')
ylabel('Population Size [thousand]')
xlabel('Years [y]')
figure(35)
plot(t_plot,abs(u_dmd(2,:)).'),
hold on
plot(t_plot,canadalynx(1:numel(t_forcast)))
legend('DMD Forcast','Canada lynx')
ylabel('Population Size [thousand]')
xlabel('Years [y]')
