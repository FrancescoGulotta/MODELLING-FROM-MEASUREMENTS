function dydt = rhs_volterra(t,y,a1,a2,b1,b2)
% Predator and Prey Model
tmp1 = a1*y(1) - a2*y(1)*y(2);
tmp2 = -b1*y(2) + b2*y(1)*y(2);
dydt = [tmp1; tmp2];

%{
function rhs=rhs_volterra(t,x,dummy,b,p,r,d)
rhs=[b*x(1)-p*x(2)*x(1); r*x(2)*x(1)-d*x(2)];
%}