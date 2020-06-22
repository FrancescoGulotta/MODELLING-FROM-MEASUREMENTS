load reaction_diffusion_big
%{
plot(diag(S)/sum(diag(S)),'ro')
legend('sigma')
xlabel('modes')
ylabel('sigma relative')
%}

r=20;
t_test=150;% timesteps used to define the DMD 
t_fin=200;% 200-150 timesteps used to validate the DMD forecast
dt=0.05;

for xspace=1:1:numel(x)

u_x=reshape(u(xspace,:,1:t_test-1),[512 t_test-1]);% the DMD is defined using onlu the first 150 timestps
u_x1=reshape(u(xspace,:,2:t_test),[512 t_test-1]);

[U,S,V] = svd(u_x,'econ'); % first Step of the Algorithm
Ur=U(:,1:r);
Sr=S(1:r,1:r);
Vr=V(:,1:r);

Atilde=Ur'*u_x1*Vr*inv(Sr);
[W,Lambda] = eig(Atilde);

Phi = u_x1*Vr*inv(Sr)*W; % Step 4
Alpha1=Sr*Vr(1,:)';
b = (W*Lambda)\Alpha1;

mu=diag(Lambda);
omega=log(mu)/dt;

y0 = Phi\u_x(:,1);

for iter = 1:t_fin %teh DMD forecasts all the timesteps (form 1 to 200) 
    u_modes(:,iter) =(y0.*exp(omega*(t(iter))));
end

u_dmd(xspace,:,:)= real(Phi*u_modes); 

end

for t=t_test:1:t_fin
    
figure(1)

subplot(2,1,1); 
pcolor(x,y,u(:,:,t)); shading interp; colormap(hot); colorbar; drawnow;%caxis([-1 1]);
xlabel('x')
ylabel('y')
title('Real Data ')
subplot(2,1,2)
pcolor(x,y,u_dmd(:,:,t)); shading interp; colormap(hot); caxis([-1 1]);colorbar; drawnow;
xlabel('x')
ylabel('y')
title('DMD ')
end

