%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 文件名：FANInt1.m
% 作  者：陈罡
% 功  能：读富克VHF雷达数据
% 说  明：自己完全编写数据,画7个波束的扇形图,插值
% 日  期：20160805
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 数据格式：第一行为数据头包含数据信息，以后为数据本身，数据分为三列，第一列波束指向，第二列距离，第三列强度。
% 数据分为360段每段875行，每段首行为数据记录时间,每段数据的高度坐标都是一样的。
% 后插值


% clc
clear all
% close all

%% RTI数据


%%% 参数设定
% RangeMax =120;
BeamNum = 7;
Point = -22.5: 7.5 :22.5;  % 波束指向
AltRange = [200, 500];
DistRange = [-145, 145];

%%% 读数据1
fileVHF1 =  'FKT_VHF01_DFI_L11_02H_20140908120000.dat' ;
[fid,message]=fopen(fileVHF1,'r');

if fid==-1
    disp(message);  %使用fopen函数时，都测试其返回值是否为有效值,如果fid=-1,打开文件失败，message显示错误信息
end
%获取数据文件第一行说明文字
Head = textscan(fid, '%s', 1, 'delimiter', '');  % 文件头；

%获取数据文件中的数字类型数据
DataAll = textscan(fid, '%d64 %f %f ');
fclose(fid);

pointing = DataAll{1};     %数据文件第一列波束指向
echo_range = DataAll{2};   %数据文件第二列回波距离
echo_re = DataAll{3};      %数据文件第三列波束强度
clear DataAll

%%% 找到数据格式特征
DataHead = find(pointing>10);   %找到段首位置
DataNum = length(DataHead);     %数据段数，这个数据是420；
DataLgth = DataHead(2)-1;       %数据段长度；
BinNum = DataHead(2)-2;         %距离门长度；

%%% 整理数据
%%% 时间
TimeArrayi = pointing(DataHead)+80000;
TimeArray = num2str(TimeArrayi);
TimeAxis1 = datenum(TimeArray, 'yyyymmddHHMMSS');  %时间轴
% TimeAxis2 = reshape(TimeAxis1', length(TimeAxis1)/BeamNum ,BeamNum);  % 行为时间，列为Beams

%%%距离
Range1 = echo_range(2:DataLgth);  %波束1的range值信息
Altitude = Range1.* cosd(28.2);

%%%Amp
Ampi = reshape(echo_re,DataLgth,DataNum);
Amp2 = Ampi(2:DataLgth,:);   % 一列为一个Beam的数据，7列为一次扫描的7个Beam的数据，再下一次扫描，共扫描60次 7*60 = 420；


%先纵向滤波
[Hang, Lie] = size(Amp2); %返回矩阵Amp2的行数和列数
Nrange=800:874;%140:150;
for ii = 1:Lie
    Amp1(:,ii)=Amp2(:,ii)-mean(Amp2(Nrange,ii));
end


% RangReso= Range1(2) - Range1(1); 
clear Ampi pointing echo_range echo_re DataAll TimeArrayi ;

%%% 插值参数
PointInt = -22.5: 0.5 :22.5;  % 波束指向
Elevation = [59.72 60.70 61.24 61.36 61.06 60.35 59.15];%依次是1-7的仰角
Elevation1 = linspace(59.72,60.7,16);
Elevation2 = linspace(60.7,61.24,16);
Elevation3 = linspace(61.24,61.36,16);
Elevation4 = linspace(61.36,61.06,16);
Elevation5 = linspace(61.06,60.35,16);
Elevation6 = linspace(60.35,59.15,16);
%因为画图是西向东  波束依次是7-1  所以fliplr左右翻转
ElevationInt = fliplr([Elevation1 Elevation2(2:end) Elevation3(2:end) Elevation4(2:end) Elevation5(2:end) Elevation6(2:end)]);

%%% 画扇形图

% RangeRange = AltRange./cosd(28.2);
fffff=0;
% h = figure
for ScanNum = 8:3:42   % 扫描60次  5:5:60%
  
  jj = length(Point); 
  DataNumi = jj*ScanNum -6;

  TimeStr1 =  datestr(TimeAxis1(DataNumi), 'yyyy-mm-dd HH:MM');
  TimeStr2 =  datestr(TimeAxis1(DataNumi), 'yyyymmddHHMMSS');

for ii = 1:length(Point)
    
    Power(:, jj) = Amp1(:,DataNumi);
    jj = jj -1;
    DataNumi = DataNumi + 1;
    
end

%%% 插值
% PowerInt = interp2(Point,Altitude,Power,PointInt,Altitude,'cubic');

for ii = 1:length(Point)
%     yy(:,ii) = Range1.* sind(ElevationInt(ii));
%     xx(:,ii) =  Range1'.* cosd(ElevationInt(ii)).*sind(PointInt(ii));

%   yy(:,ii) = Range1.* cosd(28.2);
%   xx(:,ii) =  Range1'.* sind(28.2).*sind(PointInt(ii));

      yy(:,ii)=R2H(2014, 8-ii, Range1);
      xx(:,ii) =(Range1.^2-yy(:,ii).^2).^0.5*sind(Point(ii));
            
%             yy(:,ii) = Range1.*cosd(28.2)*cosd(PointInt(ii));
%             xx(:,ii) =  Range1.* cosd(ElevationInt(ii)).*sind(PointInt(ii));
    
%             yy(:,ii) = Range1.*sind(PointInt(ii))*cosd(ElevationInt(ii));
%             xx(:,ii) =  Range1'.* sind(ElevationInt(ii)).*sind(PointInt(ii));
end   


PowerInt = griddata(Point,Range1,Power,PointInt,Range1,'natural');
xxInt = griddata(Point,Range1,xx,PointInt,Range1,'natural');
yyInt = griddata(Point,Range1,yy,PointInt,Range1,'natural');
    
fffff=fffff+1;
subplot(4,4,fffff)
surf(xxInt,yyInt, PowerInt, 'edgecolor', 'none');
axis([DistRange,AltRange]);
title([TimeStr1(12:16), ' UT']);
xlabel('Zonal Distance (km)');
ylabel('Altitude (km)');
colorbar,colormap(jet),
caxis([0,25]);


% print(h,'-djpeg',TimeStr2); %将句柄为h的图形保存为jpeg/jpg格式的 % clear Power
% clear TimeStr1 TimeStr2 PowerInt

end