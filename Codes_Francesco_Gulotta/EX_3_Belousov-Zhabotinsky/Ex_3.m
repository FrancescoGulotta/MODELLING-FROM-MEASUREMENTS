
load ('EX_3_results');
%{
[m,n,k]=size(BZ_tensor); % x vs y vs time data
for j=1:k
A=BZ_tensor(:,:,j);
pcolor(A), shading interp, pause(0.01)
end
%}


for r=10:25:200 %parametetrization of the truncation value (r)
for xspace=1:1:351

u_x=reshape(BZ_tensor(xspace,:,:),[451 1200]);
%u_x1=reshape(BZ_tensor(xspace,:,:),[512 t_test-1]);

[U,S,V] = svd(u_x,'econ'); % first Step of the Algorithm



Ur=U(:,1:r);
Sr=S(1:r,1:r);
Vr=V(:,1:r);

BZ_truncated(xspace,:,:)=Ur*Sr*pinv(Vr);
peaksnr(xspace) = psnr(BZ_truncated(xspace,:,:),BZ_tensor(xspace,:,:));


plot(peaksnr)
hold on

PSNR(r,:)=peaksnr; 


temp=whos('Ur');
temp2=whos('Vr');
temp3=whos('Sr');

size_ur(r)=temp.bytes;
size_vr(r)=temp2.bytes;
size_us(r)=temp3.bytes;

end

end


%{
size_u_new=size_ur(size_ur(:)~=0);
size_v_new=size_vr(size_vr(:)~=0);
size_s_new=size_us(size_us(:)~=0);
size_fin=[];
for i=1:1:numel(size_u_new)
    
   size_fin=[size_fin;size_u_new(i),size_v_new(i),size_v_new(i)];
end
for r=10:25:200
plot(PSNR(r,:));
hold on
end
%}

for j=1:1
A=BZ_tensor(:,:,j);
B=BZ_truncated(:,:,j);
figure(2)
subplot(2,1,1)
pcolor(A), shading interp,
subplot(2,1,2)
pcolor(B), shading interp, pause(0.01)

end


