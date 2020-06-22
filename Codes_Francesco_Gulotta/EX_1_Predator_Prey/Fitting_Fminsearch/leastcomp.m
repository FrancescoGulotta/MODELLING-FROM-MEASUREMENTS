function J = leastcomp(p,tdata,xdata,ydata)
%Create the least squares error function to be minimized.
n1 = length(tdata);
[t,y] = ode45(@lotvol,tdata,[p(1),p(2)],[],p(3),p(4),p(5),p(6));
errx = y(:,1)-xdata(1:n1)';
erry = y(:,2)-ydata(1:n1)';
J = errx'*errx + erry'*erry;