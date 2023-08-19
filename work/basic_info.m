clear all
dep=load('depth_1001x801_1m.txt');

[n m]=size(dep);


f2m=0.3048;
dx1=100.0*f2m;
dy1=100.0*f2m;
dx=dx1/30;
dy=dy1/30;

x=[0:m-1]*dx;
y=[0:n-1]*dy;
[X,Y]=meshgrid(x,y);

x0=50.0;
y0=550.0;
x2=1000.0;
y2=75.0;

dis=sqrt((x2-x0)^2+(y2-y0)^2); % dis=1062.1
% 20 mph = 8.9408;
v=8.9408;
time=dis/v

sta=load('gauges.txt');


figure(1)
clf
colormap jet
pcolor(x,y,-dep),shading flat
hold on
plot([x0 x2],[y0 y2],'w--','LineWidth',2)
text(x0,y0,['time= ' num2str(0)])
text(x2,y2,['time= ' num2str(time)])
title(['speed = 20 mph or 8.94 m/s'])
for k=1:length(sta)
i=sta(k,1);
j=sta(k,2);
plot(X(j,i),Y(j,i),'ko')
text(X(j,i)+5,Y(j,i), ['G ' num2str(k)])
end

print -djpeg100 info.jpg

axis([0 600 200 800])
print -djpeg100 info1.jpg



