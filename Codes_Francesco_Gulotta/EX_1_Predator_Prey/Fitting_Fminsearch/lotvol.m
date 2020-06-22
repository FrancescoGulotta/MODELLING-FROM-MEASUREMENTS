function dydt = lotvol(t,y,a1,a2,b1,b2)
% Predator and Prey Model
tmp1 = a1*y(1) - a2*y(1)*y(2);
tmp2 = -b1*y(2) + b2*y(1)*y(2);
dydt = [tmp1; tmp2];