clear
clc
% showshore prey
showshore=[20 20 52 83 64 68 83 12 36 150 110 60 7 10 70 100 92 70 10 11 137 137 18 22 52 83 18 10 9 65];
canadalynx=[32 50 12 10 13 36 15 12 6 6 65 70 40 9 20 34 45 40 15 15 60 80 26 18 37 50 35 12 12 25];
%canadalynx predator 
canada_t=canadalynx';
show_t=showshore';
%h
t=1:2:30*2;
%x initial solution
x0=[20; 32];
%optimal parameter found with fminsearch

%parameters=[b,p,r,d]
parameters_opt=[0.6156    0.0301    0.5706    0.0114];

[~,y]=ode45(@rhs_volterra,t,x0,0,parameters_opt(1),parameters_opt(2),parameters_opt(3),parameters_opt(4));


figure(1), plot(y(:,1)), hold on, plot(showshore),legend('showshore');
figure(2), plot(y(:,2)), hold on, plot(canadalynx),legend('canadalynx');

%% Parameter optimization using Artificial Bee Colony algorithm

D=4;
n_bee=75;
n_cycle=200;
lim_scoute=D*n_bee;

%x(1) preda
%x(2) prendatore


parameters=zeros(n_bee,4);

inf_lim=[0   0   0    0]; % lower limits for the parameters

sup_lim=[1  1  1   1   ]; % upper limits for the parameters
y=[];



%initial solutions
for ii=1:1:n_bee
    ii
    
   for j=1:1:4
   parameters(ii,j)=inf_lim(j)+(sup_lim(j)-inf_lim(j))*rand(1,1);
   end
   par=parameters(ii,:);
   

   [t1,y]=ode45(@rhs_volterra,t,x0,[],par(1),par(2),par(3),par(4));
 %  numel(y),numel(t1),
 
   f_obj_value(ii,1)=sum((y(:,1)-show_t).^2)+sum((y(:,2)-canada_t).^2);
   %objective function for the initial solutions
   % the obj function reduces the difference between the population under
   % analysys and the real data

 y=[]; par=[];
   
 
   
end

[best.obj,index]=min(f_obj_value);
best.par(1,1:4)=parameters(index,:);
%ABC algorithm
a=1;
for cycle=1:1:n_cycle
 tic;
  y=[]; par_empl=[]; 
    %employ bee
    for i=1:1:n_bee
      y=[]; par_empl=[];    
     i  
    dim=randi([1,D],1,1);
    k= randi([1 n_bee],1,1);
    
    phi=rand(1,1);
    while k==i
        k= randi([1 n_bee],1,1);
    end
    par_empl(1,:)=parameters(i,:);
    par_empl(i,dim)=parameters(i,dim)+phi*(parameters(i,dim)-parameters(k,dim));  
    
    par_empl(1,:)=min(sup_lim(1,:),max(par_empl(1,:),inf_lim(1,:)));
   
   [~,y]=ode45(@rhs_volterra,t,x0,[],par_empl(1),par_empl(2),par_empl(3),par_empl(4));

   f_obj_emp=sum((y(:,1)-show_t).^2)+sum((y(:,2)-canada_t).^2);

        if f_obj_emp<=f_obj_value(i,1)
            parameters(i,:)=par_empl(1,:); 
            f_obj_value(i,1)=f_obj_emp;
            a=a+1;
        end
        
      y=[]; par_empl=[]; 
    end
    
  

    %onlooker bee phase
 fitness(:)=1./f_obj_value(:,1);
  den=sum(fitness(:));
  
   for i=1:1:n_bee
     probab(i)=fitness(i)/den;
   end       
    
    for onlk=1:1:n_bee
        npop(1,onlk)=poolextraxtion(probab(:));
    end

      
    for e=1:1:n_bee
          
            k_rnd=randi(n_bee);%extraction of the K-th population
            
            while(npop(e)==k_rnd)
                k_rnd=randi(n_bee);
        % the solution k_th should be different 
            end
            
    dim=randi([1,D],1,1);

     phi_onl=-1+(2)*rand(1,1);
     y=[]; par_onk=[];
    par_onk(1,:)=parameters(npop(e),:);
    par_onk(i,dim)=parameters(npop(e),dim)+ phi_onl*(parameters(npop(e),dim)-parameters(k_rnd,dim));  
    par_onk(1,:)=min(sup_lim(1,:),max(par_onk(1,:),inf_lim(1,:)));

    [~,y]=ode45(@rhs_volterra,t,x0,[],par_onk(1),par_onk(2),par_onk(3),par_onk(4));

   f_obj_onk=sum((y(:,1)-show_t).^2)+sum((y(:,2)-canada_t).^2);

        if f_obj_onk<=f_obj_value(npop(e),1)
            parameters(npop(e),:)=par_onk(1,:); 
            f_obj_value(npop(e),1)=f_obj_onk;
        end
      y=[]; par_onk=[]; 
    
    
    
    end
       
    if f_obj_value(:,1)<=best.obj
    [best.obj,index]=min(f_obj_value);
     best.par(1,1:4)=parameters(index,:);
    end
    
toc
cycle  
    
end

%[~,y]=ode45(@rhs_volterra,t,x0,[],best.par(1),best.par(2),best.par(3),best.par(4));


%% Figures
%optimal parameter found with the ABC algorithm
abc_parameter=[0.602273612936284,0.0308957409735782,0.603391876341654,0.0116673920546052];

time_plot=1845:2:1903;


%optimal parameter found with the fminsearch
parameters_opt=[0.6156    0.0301    0.5706    0.0114];

 [~,y_abc]=ode45(@rhs_volterra,t,x0,[],abc_parameter(1),abc_parameter(2),abc_parameter(3),abc_parameter(4));
[~,y_min]=ode45(@rhs_volterra,t,x0,[],parameters_opt(1),parameters_opt(2),parameters_opt(3),parameters_opt(4))

 figure(34)
 plot(time_plot,y_abc(:,1)), hold on, plot(time_plot,showshore),plot(time_plot,y_min(:,1)),title('Showshore'),legend('ABC','Real Data','fminsearch');
  figure(35)
 plot(time_plot,y_abc(:,2)), hold on, plot(time_plot,canadalynx),plot(time_plot,y_min(:,1)),title('Canada Lynx'),legend('ABC','Real Data','fminsearch');
 
 