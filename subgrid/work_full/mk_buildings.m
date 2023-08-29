clear all
% beach
nx_total=250; % total coarse grid
ny_total=10;
dx=20.0;
dy=20.0;
dep_offshore=10.0;
slope=0.025;
slope_land=0.001;
X_toe=700.0;
X_land = X_toe+450;;
land=-1.0;
house=-5.0;
x=[0:nx_total-1]*dx;
y=[0:ny_total-1]*dy; 
dep=zeros(ny_total,nx_total)+dep_offshore;
for j=1:ny_total
for i=1:nx_total
if x(i)>X_toe
dep(j,i)=dep_offshore-slope*(x(i)-X_toe);
end
if x(i)>X_land
dep(j,i)=land-slope_land*(x(i)-X_land);
end
end
end

% cell info
cell_m=10;
cell_n=10;
obs_m=6;
obs_n=6;
dep_bottom=9999.0;
dep_top=house;

% grid info
m=nx_total*cell_m;
n=ny_total*cell_n;
m_start=60;
n_start=1;
nx_blocks=30;
ny_blocks=10;

m_obs1=1+floor((cell_m-obs_m)/2);
m_obs2=1+floor((cell_m-obs_m)/2)+obs_m-1;
n_obs1=1+floor((cell_n-obs_n)/2);
n_obs2=1+floor((cell_n-obs_n)/2)+obs_n-1;

dep_cell=zeros(cell_n,cell_m);
dep_cell(n_obs1:n_obs2,m_obs1:m_obs2)=dep_top;

dep_full=zeros([n,m]);
for j=1:n
for i=1:m
jj=floor((j-1)/cell_n)+1;
ii=floor((i-1)/cell_m)+1;
dep_full(j,i)=dep(jj,ii);
end
end

icount=0;
for j=1:ny_blocks
for i=1:nx_blocks
m1=(m_start-1)*cell_m+(i-1)*cell_m+1;
m2=m1+cell_m-1;
n1=(n_start-1)*cell_n+(j-1)*cell_n+1;
n2=n1+cell_n-1;

j_coarse=n_start+(j-1);
i_coarse=m_start+(i-1);
dep_cell_add(:,:)=dep(j_coarse,i_coarse)+dep_cell(:,:);
dep_full(n1:n2,m1:m2)=dep_cell_add(:,:);

icount=icount+1;
for jj=1:cell_n
for ii=1:cell_m
dep_sub_writeout(icount,1)=i+m_start-1;
dep_sub_writeout(icount,2)=j+n_start-1;
dep_sub_writeout(icount,2+(jj-1)*cell_n+ii)=dep_cell_add(jj,ii);
end
end

end
end

dep_level=dep_full;
dep_level(dep_full<0.0)=0.0;
dep_has_land=dep_full;

% output subgrid
for j=1:ny_total
for i=1:nx_total
n1=(j-1)*cell_n+1;
n2=n1+cell_n-1;
m1=(i-1)*cell_m+1;
m2=m1+cell_m-1;
dep_sub(j,i)=sum(sum(dep_level(n1:n2,m1:m2)))/cell_m/cell_m;
dep_sub_has_land(j,i)=sum(sum(dep_has_land(n1:n2,m1:m2)))/cell_m/cell_m;
end
end

h=figure(1);
wid=12;
len=12;
set(h,'units','inches','paperunits','inches','papersize', [wid len],'position',[1 1 wid len],'paperposition',[0 0 wid len]);
clf
colormap jet
subplot(3,2,1)
pcolor(-dep_full),shading flat
colorbar
tit=['m x n = ' num2str(m) 'x' num2str(n)];
title(tit)

subplot(3,2,2)
pcolor(-dep_full),shading flat
colorbar
tit=['m x n = ' num2str(m) 'x' num2str(n)];
title(tit)
axis([550 700 1 100])

subplot(3,2,3)
pcolor(-dep_sub),shading flat
colorbar
tit=['sub m x n = ' num2str(nx_total) 'x' num2str(ny_total)];
title(tit)

subplot(3,2,4)
pcolor(-dep_sub_has_land),shading flat
colorbar
tit=['sub m x n = ' num2str(nx_total) 'x' num2str(ny_total)];
title(tit)

subplot(3,2,5)
plot(-dep_sub_has_land'),shading flat
grid
tit=['sub m x n = ' num2str(nx_total) 'x' num2str(ny_total)];
title(tit)
subplot(3,2,6)
plot(-dep_sub'),shading flat
grid
tit=['sub m x n = ' num2str(nx_total) 'x' num2str(ny_total)];
title(tit)


print('-djpeg',['plots/all_info.jpg'])

name_full=['dep_full_' num2str(m) 'x' num2str(n) '.txt'];
name_sub=['dep_sub_' num2str(nx_total) 'x' num2str(ny_total) '.txt'];
name_sub_land=['dep_sub_has_land_' num2str(nx_total) 'x' num2str(ny_total) '.txt'];

save('-ASCII', name_sub, 'dep_sub');
save('-ASCII', name_sub_land, 'dep_sub_has_land');
save('-ASCII', name_full, 'dep_full');
fid = fopen('dep_sub_info.txt', 'wt');
  fprintf(fid, ['%5d','%5d', repmat('%6.1f',1,cell_m*cell_n),'\n'], dep_sub_writeout');
fclose(fid);






