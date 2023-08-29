clear all

% folder of results
fdir_results='output/';


m=2500;
n=100;
DimsX={[m n]};

dx=2.0;
dy=2.0;

% dimensions
x=[0:m-1]*dx;
y=[0:n-1]*dy;
files=[1:1];

% define movie file and parameters
myVideo = VideoWriter(['videoOut.mp4'],'MPEG-4');
myVideo.FrameRate = 10;  
myVideo.Quality = 100;
%vidHeight = 576; %this is the value in which it should reproduce
%vidWidth = 1024; %this is the value in which it should reproduce
open(myVideo);

fig=figure(1);
colormap jet

wid=16;
len=4;
set(fig,'units','inches','paperunits','inches','papersize', [wid len],'position',[1 1 wid len],'paperposition',[1 1 wid len]);

for k=1:length(files) 

numb=files(k);

fnum=sprintf('%.5d',numb);

% read files -----------------------
fname=[fdir_results 'eta_' fnum];
fileID=fopen(fname);
tmp=fread(fileID,DimsX{1},'*single');
fclose(fileID);
eta=tmp';

fname=[fdir_results 'u_' fnum];
fileID=fopen(fname);
tmp=fread(fileID,DimsX{1},'*single');
fclose(fileID);
u=tmp';

fname=[fdir_results 'v_' fnum];
fileID=fopen(fname);
tmp=fread(fileID,DimsX{1},'*single');
fclose(fileID);
v=tmp';

fname=[fdir_results 'mask_' fnum];
fileID=fopen(fname);
tmp=fread(fileID,DimsX{1},'*single');
fclose(fileID);
mask=tmp';

eta(mask<1)=NaN;

% read over -------


clf


pcolor(x,y,eta),shading flat
hold on

pause(0.1)


% save image
F = print('-RGBImage','-r300');
%J = imresize(F,[vidHeight vidWidth]);
mov(k).cdata = F;

writeVideo(myVideo,mov(k).cdata);

end

close(myVideo)




