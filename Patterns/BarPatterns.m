% Generate postscript file with patterns for visual motion stimulus.
% For use in MOL549 Neurolab course.
%
% Rob de Ruyter, April 2002
%

%
% Open PostScript file for writing
%
fid=fopen('BarPatterns.ps','w');
% 
% Wite PostScript header info
%
fprintf(fid,'%s\r\n','%!PS-Adobe-3.0 EPSF-3.0')
fprintf(fid,'%s\r\n','%%Pages: 1')
fprintf(fid,'%s\r\n','%%Title: test')
fprintf(fid,'%s\r\n','%%BoundingBox: 0 0 612 792')
fprintf(fid,'%s\r\n','')
fprintf(fid,'%s\r\n','%%Page: PageLabel 1')
fprintf(fid,'%s\r\n','%%BeginPageSetup')
fprintf(fid,'%s\r\n','/fillbar{newpath moveto lineto lineto lineto closepath fill}def')
%
% Define parameters
%
PrinterRes=120; % in dots/inch
LW=72/PrinterRes; % LineWidth 1 point
SepLine=1;
fprintf(fid,'%6.3f %s\r\n',LW,' setlinewidth')
%
LenStrip=3.25*pi; % inner circumference of polycarbonate tube in inch
WidthPaper=8.5;
MarginPaper=0.25;
Len=ceil(LenStrip*72); % length in points
LenBlank=2*72; % Blank region in points
Width=WidthPaper*72;
Margin=MarginPaper*72;
%
NBars=ceil(Len/LW); % each bar is 1 LineWidth
NBlanks=ceil(LenBlank/LW);
mmPerLine=(25.4/72)*LW;
DegPerRad=180/pi; 
FlyScreenDist=DegPerRad; % set fly aprox 57 mm from screen: then 1deg=1mm
LinesPerDeg=1/(DegPerRad*(atan(mmPerLine/FlyScreenDist)));
ZeroLev=0.5;
%
NStrips=5;
StripVariables=zeros(NStrips,NBars);
StripGrayLevels=zeros(NStrips,NBars);
BarWidth=Len/NBars;
BarHeight=(Width-2*Margin)/NStrips;
XOrg=Margin	% X-origin
YOrg=Margin	% Y-origin
%
% Strip 1: sinewave pattern, 20 periods
%
GrayLev=ZeroLev;
fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
Y0=BarWidth;Y1=Y0+NBars*BarWidth;
X0=XOrg+0*BarHeight;X1=X0+BarHeight;
fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
   [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
NPeriods=20;
Lambda=NBars/NPeriods; % Lambda is now expressed in LW units
Contrast=1;
X0=XOrg;X1=XOrg+BarHeight;
for j=1:NBars
   GrayLev=ZeroLev+0.5*Contrast*sin(2*pi*j/Lambda);
   fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
   StripGrayLevels(1,j)=GrayLev;
   StripVariables(1,j)=Contrast;
   Y0=j*BarWidth;Y1=Y0+BarWidth;
   fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
      [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
end
%
% Strip 2: sinewave pattern, increasing contrast, 12 deg
%
GrayLev=ZeroLev;
fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
Y0=BarWidth;Y1=Y0+NBars*BarWidth;
X0=XOrg+1*BarHeight;X1=X0+BarHeight;
fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
   [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
Lambda=NBars/NPeriods; % Lambda is now expressed in LW units
ZeroLev=0.5;
X0=XOrg+BarHeight;X1=X0+BarHeight;
for j=1:NBlanks
   GrayLev=ZeroLev;
   fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
   StripGrayLevels(2,j)=GrayLev;
   StripVariables(2,j)=0;
   Y0=j*BarWidth;Y1=Y0+BarWidth;
   fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
      [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
end
for j=NBlanks+1:NBars
   Contrast=(j-NBlanks)/(NBars-NBlanks);
   GrayLev=ZeroLev+0.5*Contrast*sin(2*pi*j/Lambda); % sinewave
   fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
   StripGrayLevels(2,j)=GrayLev;
   StripVariables(2,j)=Contrast;
   Y0=j*BarWidth;Y1=Y0+BarWidth;
   fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
      [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
end
GrayLev=1;
fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
Y0=BarWidth;Y1=Y0+NBars*BarWidth;
X0=XOrg+1*BarHeight;X1=X0+SepLine;
fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
   [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
%
% Strip 3: max contrast, varying Lambda
%
GrayLev=ZeroLev;
fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
Y0=BarWidth;Y1=Y0+NBars*BarWidth;
X0=XOrg+2*BarHeight;X1=X0+BarHeight;
fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
   [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
LambdaVar=logspace(log10(2),log10(36),NBars-NBlanks)*LinesPerDeg;
Phase=cumsum(2*pi./LambdaVar);
Contrast=1;
ZeroLev=0.5;
X0=XOrg+2*BarHeight;X1=X0+BarHeight;
for j=1:NBlanks
   GrayLev=ZeroLev;
   fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
   StripGrayLevels(3,j)=GrayLev;
   Y0=j*BarWidth;Y1=Y0+BarWidth;
   fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
      [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
end
for j=NBlanks+1:NBars
%   GrayLev=ZeroLev+0.5*Contrast*sign(sin(2*pi*j/LambdaVar(j))); % binary
   GrayLev=ZeroLev+0.5*Contrast*(sin(Phase(j-NBlanks))); % gray level
   fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
   StripGrayLevels(3,j)=GrayLev;
   StripVariables(3,j)=Phase(j-NBlanks);
   Y0=j*BarWidth;Y1=Y0+BarWidth;
   fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
      [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
end
GrayLev=1;
fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
Y0=BarWidth;Y1=Y0+NBars*BarWidth;
X0=XOrg+2*BarHeight;X1=X0+SepLine;
fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
   [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
%
% Strip 4: random pattern
%
GrayLev=ZeroLev;
fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
Y0=BarWidth;Y1=Y0+NBars*BarWidth;
X0=XOrg+3*BarHeight;X1=X0+BarHeight;
fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
   [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
RandBarUnit0=1; % 1 deg minimum barwidth
RandBarUnit=ceil(RandBarUnit0*LinesPerDeg);
Contrast=1;
ZeroLev=0.5;
X0=XOrg+3*BarHeight;X1=X0+BarHeight;
for j=1:RandBarUnit:NBars
%   GrayLev=ZeroLev+0.5*Contrast*sign(rand(1)-0.5); % binary pattern
   GrayLev=ZeroLev+0.5*Contrast*(rand(1)-0.5); % gray levels
   fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
   Y0=j*BarWidth;Y1=min(Y0+BarWidth*RandBarUnit,BarWidth*NBars);
   j0=j;j1=round(Y1/BarWidth);
   StripGrayLevels(4,j0:j1)=GrayLev;
   fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
      [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
end
GrayLev=1;
fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
Y0=BarWidth;Y1=Y0+NBars*BarWidth;
X0=XOrg+3*BarHeight;X1=X0+SepLine;
fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
   [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
%
% Strip 5: sine pattern, max contrast, increase in vertical size
%
Lambda=NBars/(2*NPeriods); % Lambda is now expressed in LW units
Contrast=1;
ZeroLev=0.5;
XMid=XOrg+4.5*BarHeight;X1=X0+BarHeight;
%VarBarHeight=linspace(0,BarHeight,NBars);
VarBarHeight=logspace(log10(BarHeight/100),log10(BarHeight),NBars-NBlanks);
GrayLev=ZeroLev;
fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
Y0=BarWidth;Y1=Y0+NBars*BarWidth;
X0=XOrg+4*BarHeight;X1=X0+BarHeight;
fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
   [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
for j=1:NBlanks
   GrayLev=ZeroLev;
   fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
   StripVariables(5,j)=0;
   StripGrayLevels(5,j)=GrayLev;
   Y0=j*BarWidth;Y1=Y0+BarWidth;
   j0=j;j1=round(Y1/BarWidth);
   StripGrayLevels(5,j0:j1)=GrayLev;
   fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
      [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
end
for j=NBlanks+1:NBars
   %   GrayLev=ZeroLev+0.5*Contrast*sign(sin(2*pi*j/Lambda)); %binary
   GrayLev=ZeroLev+0.5*Contrast*(sign(sin(2*pi*j/Lambda))); % sqwave
   fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
   Y0=j*BarWidth;Y1=Y0+BarWidth;
   X0=XMid-VarBarHeight(j-NBlanks)/2;
   X1=XMid+VarBarHeight(j-NBlanks)/2;
   StripVariables(5,j)=VarBarHeight(j-NBlanks)/BarHeight;
   j0=j;j1=min(NBars,round(Y1/BarWidth));
   StripGrayLevels(5,j0:j1)=GrayLev;
   fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
      [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
end
GrayLev=1;
fprintf(fid,'%6.3f %s\r\n',GrayLev,' setgray');
Y0=BarWidth;Y1=Y0+NBars*BarWidth;
X0=XOrg+4*BarHeight;X1=X0+SepLine;
fprintf(fid,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %s\r\n',...
   [X0, Y0, X1, Y0, X1, Y1, X0, Y1],'fillbar');
%
% Write trailer information
%
fprintf(fid,'%s\r\n','%%EndPageSetup')
fprintf(fid,'%s\r\n','showpage')
fclose(fid)
%
% Write parameter files
%
DrumAngle=linspace(0,360*(NBars-1)/NBars,NBars);
%
txtfile=fopen('BarPatternParameters.txt','w'); 
fprintf(txtfile,'%s\r\n','Angle  Strip1  Strip2  Strip3  Strip4  Strip5');
fprintf(txtfile,'%s\r\n','(DEG)  Contr.  Contr.  Phase   Dummy   Height');
fprintf(txtfile,'%s\r\n',' ')
fprintf(txtfile,'%4.2f\t%4.3f\t%4.3f\t%4.3f\t%4.3f\t%4.3f\r\n',[DrumAngle;StripVariables])
fclose(txtfile)
%
txtfile=fopen('BarPatternGrayLevels.txt','w'); 
fprintf(txtfile,'%s\r\n','Angle  Strip1  Strip2  Strip3  Strip4  Strip5');
fprintf(txtfile,'%s\r\n','(DEG)  RelInt  RelInt  RelInt  RelInt  RelInt');
fprintf(txtfile,'%s\r\n',' ')
fprintf(txtfile,'%4.2f\t%4.3f\t%4.3f\t%4.3f\t%4.3f\t%4.3f\r\n',[DrumAngle;StripGrayLevels])
fclose(txtfile)
%
% Plot strips
%
figure(1);clf
orient tall
%
subplot(5,2,1)
plot(DrumAngle,StripGrayLevels(1,:),'k')
axis([0,360,-0.05,1.05])
set(gca,'XTick',[0,90,180,270,360],'XTickLabel',[])
title('Angle dependent gray levels, pattern 1')
%
subplot(5,2,2)
plot(DrumAngle,StripVariables(1,:),'r')
axis([0,360,-0.05,1.05])
set(gca,'XTick',[0,90,180,270,360],'XTickLabel',[])
ylabel('contrast')
title('Angle dependent parameter, pattern 1')
%
subplot(5,2,3)
plot(DrumAngle,StripGrayLevels(2,:),'k')
axis([0,360,-0.05,1.05])
set(gca,'XTick',[0,90,180,270,360],'XTickLabel',[])
title('pattern 2')
%
subplot(5,2,4)
plot(DrumAngle,StripVariables(2,:),'r')
axis([0,360,-0.05,1.05])
set(gca,'XTick',[0,90,180,270,360],'XTickLabel',[])
ylabel('contrast')
title('pattern 2')
%
subplot(5,2,5)
plot(DrumAngle,StripGrayLevels(3,:),'k')
axis([0,360,-0.05,1.05])
set(gca,'XTick',[0,90,180,270,360],'XTickLabel',[])
ylabel('relative gray level')
title('pattern 3')
%
subplot(5,2,6)
DrumStep=DrumAngle(2)-DrumAngle(1);
SpWaveLength=2*pi./(diff([0,StripVariables(3,:)])/DrumStep);
   plot(DrumAngle,SpWaveLength,'r')
axis([0,360,0,50])
set(gca,'XTick',[0,90,180,270,360],'XTickLabel',[])
ylabel('wavelength (\circ)')
title('pattern 3')
%
subplot(5,2,7)
plot(DrumAngle,StripGrayLevels(4,:),'k')
axis([0,360,-0.05,1.05])
set(gca,'XTick',[0,90,180,270,360],'XTickLabel',[])
title('pattern 4')
%
subplot(5,2,9)
plot(DrumAngle,StripGrayLevels(5,:),'k')
axis([0,360,-0.05,1.05])
set(gca,'XTick',[0,90,180,270,360])
xlabel('Drum angle (\circ)')
title('pattern 5')
%
subplot(5,2,10)
plot(DrumAngle,StripVariables(5,:),'r')
axis([0,360,0,1])
set(gca,'XTick',[0,90,180,270,360])
xlabel('Drum angle (\circ)')
ylabel('relative height')
title('pattern 5')
%
% Write plot to TIFF file
%
print -dtiff 'BarPatternPlots'
%
%
