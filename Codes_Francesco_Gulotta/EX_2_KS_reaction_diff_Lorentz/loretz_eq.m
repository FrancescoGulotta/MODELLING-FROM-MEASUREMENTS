function dxdydz = loretz_eq(t,x,sig,rho,b)

    temp1= sig*(x(2)-x(1));
    temp2=rho*x(1)-x(1)*x(3)-x(2);
    temp3=x(1)*x(2)-b*x(3);         

    dxdydz = [temp1; temp2;temp3];


