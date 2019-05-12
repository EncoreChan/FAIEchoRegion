%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �ļ�����FANInt1.m
% ��  �ߣ����
% ��  �ܣ�������VHF�״�����
% ˵  �����Լ���ȫ��д����,��7������������ͼ,��ֵ
% ��  �ڣ�20160805
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ݸ�ʽ����һ��Ϊ����ͷ����������Ϣ���Ժ�Ϊ���ݱ������ݷ�Ϊ���У���һ�в���ָ�򣬵ڶ��о��룬������ǿ�ȡ�
% ���ݷ�Ϊ360��ÿ��875�У�ÿ������Ϊ���ݼ�¼ʱ��,ÿ�����ݵĸ߶����궼��һ���ġ�
% ���ֵ


% clc
clear all
% close all

%% RTI����


%%% �����趨
% RangeMax =120;
BeamNum = 7;
Point = -22.5: 7.5 :22.5;  % ����ָ��
AltRange = [200, 500];
DistRange = [-145, 145];

%%% ������1
fileVHF1 =  'FKT_VHF01_DFI_L11_02H_20140908120000.dat' ;
[fid,message]=fopen(fileVHF1,'r');

if fid==-1
    disp(message);  %ʹ��fopen����ʱ���������䷵��ֵ�Ƿ�Ϊ��Чֵ,���fid=-1,���ļ�ʧ�ܣ�message��ʾ������Ϣ
end
%��ȡ�����ļ���һ��˵������
Head = textscan(fid, '%s', 1, 'delimiter', '');  % �ļ�ͷ��

%��ȡ�����ļ��е�������������
DataAll = textscan(fid, '%d64 %f %f ');
fclose(fid);

pointing = DataAll{1};     %�����ļ���һ�в���ָ��
echo_range = DataAll{2};   %�����ļ��ڶ��лز�����
echo_re = DataAll{3};      %�����ļ������в���ǿ��
clear DataAll

%%% �ҵ����ݸ�ʽ����
DataHead = find(pointing>10);   %�ҵ�����λ��
DataNum = length(DataHead);     %���ݶ��������������420��
DataLgth = DataHead(2)-1;       %���ݶγ��ȣ�
BinNum = DataHead(2)-2;         %�����ų��ȣ�

%%% ��������
%%% ʱ��
TimeArrayi = pointing(DataHead)+80000;
TimeArray = num2str(TimeArrayi);
TimeAxis1 = datenum(TimeArray, 'yyyymmddHHMMSS');  %ʱ����
% TimeAxis2 = reshape(TimeAxis1', length(TimeAxis1)/BeamNum ,BeamNum);  % ��Ϊʱ�䣬��ΪBeams

%%%����
Range1 = echo_range(2:DataLgth);  %����1��rangeֵ��Ϣ
Altitude = Range1.* cosd(28.2);

%%%Amp
Ampi = reshape(echo_re,DataLgth,DataNum);
Amp2 = Ampi(2:DataLgth,:);   % һ��Ϊһ��Beam�����ݣ�7��Ϊһ��ɨ���7��Beam�����ݣ�����һ��ɨ�裬��ɨ��60�� 7*60 = 420��


%�������˲�
[Hang, Lie] = size(Amp2); %���ؾ���Amp2������������
Nrange=800:874;%140:150;
for ii = 1:Lie
    Amp1(:,ii)=Amp2(:,ii)-mean(Amp2(Nrange,ii));
end


% RangReso= Range1(2) - Range1(1); 
clear Ampi pointing echo_range echo_re DataAll TimeArrayi ;

%%% ��ֵ����
PointInt = -22.5: 0.5 :22.5;  % ����ָ��
Elevation = [59.72 60.70 61.24 61.36 61.06 60.35 59.15];%������1-7������
Elevation1 = linspace(59.72,60.7,16);
Elevation2 = linspace(60.7,61.24,16);
Elevation3 = linspace(61.24,61.36,16);
Elevation4 = linspace(61.36,61.06,16);
Elevation5 = linspace(61.06,60.35,16);
Elevation6 = linspace(60.35,59.15,16);
%��Ϊ��ͼ������  ����������7-1  ����fliplr���ҷ�ת
ElevationInt = fliplr([Elevation1 Elevation2(2:end) Elevation3(2:end) Elevation4(2:end) Elevation5(2:end) Elevation6(2:end)]);

%%% ������ͼ

% RangeRange = AltRange./cosd(28.2);
fffff=0;
% h = figure
for ScanNum = 8:3:42   % ɨ��60��  5:5:60%
  
  jj = length(Point); 
  DataNumi = jj*ScanNum -6;

  TimeStr1 =  datestr(TimeAxis1(DataNumi), 'yyyy-mm-dd HH:MM');
  TimeStr2 =  datestr(TimeAxis1(DataNumi), 'yyyymmddHHMMSS');

for ii = 1:length(Point)
    
    Power(:, jj) = Amp1(:,DataNumi);
    jj = jj -1;
    DataNumi = DataNumi + 1;
    
end

%%% ��ֵ
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


% print(h,'-djpeg',TimeStr2); %�����Ϊh��ͼ�α���Ϊjpeg/jpg��ʽ�� % clear Power
% clear TimeStr1 TimeStr2 PowerInt

end