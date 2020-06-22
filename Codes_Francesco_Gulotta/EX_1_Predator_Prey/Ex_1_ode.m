clear
clc


showshore=[20 20 52 83 64 68 83 12 36 150 110 60 7 10 70 100 92 70 10 11 137 137 18 22 52 83 18 10 9 65];
canadalynx=[32 50 12 10 13 36 15 12 6 6 65 70 40 9 20 34 45 40 15 15 60 80 26 18 37 50 35 12 12 25];
dt=2;%2years

t_forcast=0:dt:59;

x1=showshore;
x2=canadalynx;
size=numel(x1);
%central difference
%{
for j=2:1:size-1
  x1prime(j-1)=(x1(j+1)-x1(j-1))/(2*dt);
  x2prime(j-1)=(x2(j+1)-x2(j-1))/(2*dt);
end
%}
%{
%forward scheme
for j=2:1:size-1
  x1prime(j-1)=(x1(j+1)-x1(j))/(dt);
  x2prime(j-1)=(x2(j+1)-x2(j))/(dt);
end
%}
%backward scheme
for j=2:1:size-1
  x1prime(j-1)=(x1(j)-x1(j-1))/(dt);
  x2prime(j-1)=(x2(j)-x2(j-1))/(dt);
end
x1s=x1(2:size-1)';
x2s=x2(2:size-1)';

%A=[x1s x2s x1s.^2 x1s.*x2s x2s.^2 x1s.^3 (x2s.^2).*x1s x2s.^3];
%A=[x1s x1s.*x2s x1s.^2  x1s.^3 x2s  x2s.^2  x2s.^3 x2s.^2  x2s.^3];
A=[ x1s (x1s.*x2s)  (x2s)  (x1s.^2)  (x2s.*x1s)  (x2s.^2)  (x2s.^3)  (x2s.^2)  (x2s.^3)];


xi1_inv=A\x1prime.';
xi2_inv=A\x1prime.';

xi1_pinv=pinv(A)*x1prime';
xi2_pinv=pinv(A)*x1prime';

xi1_lasso=lasso(A,x1prime,'Lambda',0.1);
xi2_lasso=lasso(A,x2prime,'Lambda',0.1);

figure (4)
subplot(2,1,1),bar(xi1_lasso),legend('lasso');
subplot(2,1,2), bar(xi2_lasso),legend('lasso');



figure(3)
subplot(2,1,1),bar(xi1_pinv),hold on, bar(xi1_inv), hold on,  legend ('pinv','inv');%bar(xi1_inv), hold on;
subplot(2,1,2),bar(xi2_pinv) ,hold on, bar(xi2_inv), hold on, legend ('pinv','inv'); %bar(xi2_inv), hold on;

%% Time delay ODE
x1=[];
x2=[];

for j=1:10
  x1=[x1;showshore(j:20+j)];
  x2=[x1;canadalynx(j:20+j)];
end 
%central difference
%{
for j=2:1:size-1
  x1prime(j-1)=(x1(j+1)-x1(j-1))/(2*dt);
  x2prime(j-1)=(x2(j+1)-x2(j-1))/(2*dt);
end
%}
%forward scheme
for j=2:1:size-1
  x1prime(j-1)=(x1(j+1)-x1(j))/(dt);
  x2prime(j-1)=(x2(j+1)-x2(j))/(dt);
end


x1s=x1(2:size-1)';
x2s=x2(2:size-1)';

%A=[x1s x2s x1s.^2 x1s.*x2s x2s.^2 x1s.^3 (x2s.^2).*x1s x2s.^3];
A=[x1s x1s.*x2s x1s.^2 x2s x1s.^3 (x1s.^2).*x2s (x2s.^2).*x1s x2s.^3];

%xi1=A\x1prime.';
%xi2=A\x1prime.';
%xi1=pinv(A)*x1prime';
%xi2=pinv(A)*x1prime';
xi1=lasso(A,x1prime,'Lambda',0.1);
xi2=lasso(A,x2prime,'Lambda',0.1);


figure(3)
subplot(2,1,1), bar(xi1)
subplot(2,1,2), bar(xi2)