clear all

fdir='/Volumes/BigSur_2022/Scott_shipwake/draft_02/';
%fdir='../work/output/';
fdep='../work/';

mask=load([fdir 'eta_00001']);
m2in=39.3701;

%ns=input('input plot start number: ns=');
%ne=input('input plot end number:ne=');
ns=38;  % 38
ne=158; % 159

dep1=load([fdep 'depth_1001x801_1m.txt']);

[n m]=size(dep1);
x0=0.0;
dx=1.016;
y0=0.0;

x=x0+[0:m-1]*dx;
y=y0+[0:n-1]*dx;

[X Y]=meshgrid(x,y);

% VESSEL


% define movie file and parameters
myVideo = VideoWriter('videoOut.mp4','MPEG-4');
myVideo.FrameRate = 10;  
myVideo.Quality = 100;
%vidHeight = 576; %this is the value in which it should reproduce
%vidWidth = 1024; %this is the value in which it should reproduce
open(myVideo);
h=figure(1);
%set(h, 'Visible', 'off');
colormap jet

wid=16;
len=8;
set(h,'units','inches','paperunits','inches','papersize', [wid len],'position',[1 1 wid len],'paperposition',[0 0 wid len]);

sta1=load([fdir 'sta_0001']);
sta2=load([fdir 'sta_0002']);
sta3=load([fdir 'sta_0003']);
sta4=load([fdir 'sta_0004']);

sta=load([fdep 'gauges.txt']);

for num=ns:ne
    
fnum=sprintf('%.5d',num);
eta=load([fdir 'eta_' fnum]);


eta(eta>1.0)=NaN;

clf

subplot(4,3,[1 2 4 5 7 8 10 11])
pcolor(x,y,eta*m2in),shading interp;
%caxis([-10 10])
caxis([-5 5])
hold on
contour(x,y,-dep1,[-14:0])
axis([50 600 210 800])

xlabel('x(m)');
ylabel('y(m)');

hour=sprintf('%.1f',(num-1)*0.5);
title(['Time =', hour, ' sec']);
cbar=colorbar;
set(get(cbar,'ylabel'),'String','\eta (inch)  ')

for k=1:length(sta)
i=sta(k,1);
j=sta(k,2);
plot(X(j,i),Y(j,i),'ko','MarkerFaceColor','k')
text(X(j,i)+5,Y(j,i), ['G ' num2str(k)])
end

subplot(4,3,[3])
plot(sta1(:,1),sta1(:,2)*m2in,'LineWidth',1)
axis([20 80 -5 5])
hold on
plot(sta1(num*5,1),sta1(num*5,2)*m2in,'ro','MarkerFaceColor','r')
%xlabel('time (s)')
ylabel('\eta (inch)')
title('G 1')
grid

subplot(4,3,[6])
plot(sta2(:,1),sta2(:,2)*m2in,'LineWidth',1)
axis([20 80 -5 5])
hold on
plot(sta2(num*5,1),sta2(num*5,2)*m2in,'ro','MarkerFaceColor','r')
%xlabel('time (s)')
ylabel('\eta (inch)')
title('G 2')
grid

subplot(4,3,[9])
plot(sta3(:,1),sta3(:,2)*m2in,'LineWidth',1)
axis([20 80 -5 5])
hold on
plot(sta3(num*5,1),sta3(num*5,2)*m2in,'ro','MarkerFaceColor','r')
%xlabel('time (s)')
ylabel('\eta (inch)')
title('G 3')
grid

subplot(4,3,[12])
plot(sta4(:,1),sta4(:,2)*m2in,'LineWidth',1)
axis([20 80 -5 5])
hold on
plot(sta4(num*5,1),sta4(num*5,2)*m2in,'ro','MarkerFaceColor','r')
xlabel('time (s)')
ylabel('\eta (inch)')
title('G 4')
grid

pause(0.1)

% save image
F = print('-RGBImage','-r300');
%J = imresize(F,[vidHeight vidWidth]);
%mov(k).cdata = J;
mov(num).cdata = F;

writeVideo(myVideo,mov(num).cdata);

end
close(myVideo)
