clear all, close all, clc

% Simulate Lorenz system
dt=0.01; T=2; t=0:dt:T;
b=8/3; sig=10;
rho_test=[10:2:40];
%rho_test=[10*ones(50,1),28*ones(50,1),40*ones(50,1)];    
ode_options = odeset('RelTol',1e-10, 'AbsTol',1e-11);


input=[];
output=[];
k=0;
%{
for j=1:numel(rho_test)  % training trajectories
    j
    rho=rho_test(j);

    x0=30*ones(3,1)+(rand(3,1));
    
    [t,y] = ode45(@loretz_eq,t,x0,[],sig,rho,b);
    input=[input; rho*ones(1,3) ; y(1:end-1,:)];
    output=[output; rho*ones(1,3) ; y(2:end,:)];
    plot3(y(:,1),y(:,2),y(:,3)), hold on
    plot3(x0(1),x0(2),x0(3),'ro')
    
end
%}

for j=1:1% training trajectories
    j
    x0=30*ones(3,1);
    
    rho=rho_test(j);
    
    [t,y] = ode45(@loretz_eq,t,x0,[],sig,rho,b);
    input=[input; y(1:end-1,:)];
    output=[output; y(2:end,:)];
    plot3(y(:,1),y(:,2),y(:,3)), hold on
    plot3(x0(1),x0(2),x0(3),'ro')
end

grid on, view(-23,18)
rho_tested=[];
for l=1:numel(rho_test)
rho_tested=[rho_tested;rho_test(l)*ones(numel(t)-1,1)];
end
input_NN(:,1)=rho_tested;
input_NN(:,2:4)=input;
output_NN(:,1)=rho_tested;
output_NN(:,2:4)=output;



%% train the Neural Network
net = feedforwardnet([15 15 15]);
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'radbas';
net.layers{3}.transferFcn = 'purelin';
net = train(net,input_NN.',output_NN.');
%%

set(gcf,'color','w');
rho_try=17;
x0=30*(ones(3,1));
figure(22)
dt=0.01; T=8; t=0:dt:T;
[t,y] = ode45(@loretz_eq,t,x0,[],sig,rho_try,b);

grid on
%rho is used as a input
x0=[rho_try;30*(ones(3,1))];
clear ynn
ynn(1,:)=x0;
for jj=2:length(t)
    y0=net(x0);
    ynn(jj,:)=y0.'; 
    x0=[rho_try;y0(2:4)];
end
plot3(y(:,1),y(:,2),y(:,3)), hold on
plot3(ynn(:,2),ynn(:,3),ynn(:,4),':','Linewidth',[2])
legend('ODE45','NN')
xlabel('x');
ylabel('y');
zlabel('z');

figure(3)
subplot(3,2,1), plot(t,y(:,1),t,ynn(:,2),'Linewidth',[2]),legend('ODE45','NN'),xlabel('t'); ylabel('x');
subplot(3,2,2), plot(t,y(:,2),t,ynn(:,3),'Linewidth',[2]),legend('ODE45','NN'),xlabel('t'); ylabel('y');
subplot(3,2,3), plot(t,y(:,3),t,ynn(:,4),'Linewidth',[2]),legend('ODE45','NN'),xlabel('t'); ylabel('z');

