clear all;
close all;
clc;

load Recorded_azimuth.txt;
load Recorded_elevation.txt;
load Recorded_altitude.txt;

%Draw Azimuth-Elevation plot
figure(1);
plot(Recorded_azimuth,Recorded_elevation,'.')
axis([-30 -4  46  54]);
title('YEAR=20150804/BEAM DIRECTION = -17(deg)','fontsize',16);
xlabel('Azimuth(deg)','fontsize',14);
ylabel('Elevation(deg)','fontsize',14);
grid on;


%ͨ��������S�ڸ߶ȡ��ϱ��������������
Re = 6371.2; %����뾶 km
Beta = asind(Re*sind(90+Recorded_elevation)./(Re+Recorded_altitude)); %�״ﲨ�������� FAI�͵������߼н�
Alpha = 180-(90+Recorded_elevation)-Beta; %�״�վ��͵��������벻������͵������߼н�
S = (Re+Recorded_altitude).*sind(Alpha)./sind(90+Recorded_elevation); %�״�վ�㵽FAI����
%��S�ֽ�
SV = S.*cosd(Beta); %S�ڸ߶ȷ������ ����ֱ�ر�������
SH = S.*sind(Beta); %S�ڵ��淽�����
SSN = SH.*cosd(Recorded_azimuth); %S���ϱ�������� ����Ϊ�� �ϱ�Ϊ��
SEW = SH.*sind(Recorded_azimuth); %S�ڶ���������� ����Ϊ�� ����Ϊ��

%Draw distnace in N-S direction - ture height plot
figure(2);
plot(SSN,Recorded_altitude,'.')
axis([60 100  90  120]);
title('YEAR=20150804/BEAM DIRECTION = -17(deg)','fontsize',16);
xlabel('Distance in N-S direction(km)','fontsize',14);
ylabel('Ture Height(km)','fontsize',14);
grid on;

%Draw distnace in W-E direction - ture height plot
figure(3);
plot(SEW,Recorded_altitude,'.')
axis([-60 0  90  120]);
title('YEAR=20150804/BEAM DIRECTION = -17(deg)','fontsize',16);
xlabel('Distance in W-E direction(km)','fontsize',14);
ylabel('Ture Height(km)','fontsize',14);
grid on;

%Draw distnace in W-E direction - N-S direction
figure(4);
plot(SEW,SSN,'.')
axis([-60 0  60 100]);
title('YEAR=20150804/BEAM DIRECTION = -17(deg)','fontsize',16);
xlabel('Distance in W-E direction(km)','fontsize',14);
ylabel('Distance in N-S direction(km)','fontsize',14);
grid on;

%Draw 3D
Longitude_ChungLi = 121.19;%�����״�վ����121.19��E��24.96��N
Latitude_ChungLi = 24.96;
%��SSN �� SEW ����ɾ�γ��
%��FAI�ľ�γ��
Arc_TB = Alpha;%SH./Re;
Arc_NB = 90-Latitude_ChungLi;
Arc_TN = acosd(cosd(Arc_TB).*cosd(Arc_NB)+sind(Arc_TB).*sind(Arc_NB).*cosd(Recorded_azimuth));
Delta = asind(sind(Arc_TB./sind(Arc_TN).*sind(Recorded_azimuth)));
FAI.Latitude = 90-Arc_TN;
FAI.Longtitude = Longitude_ChungLi+Delta;
FAI.Altitude = Recorded_altitude;

figure(5);
% plot3(FAI.Latitude,flipud(FAI.Longtitude),FAI.Altitude,'.');
plot3(FAI.Latitude,FAI.Longtitude,FAI.Altitude,'.');
set(gca,'Ydir','reverse')%���귴ת
axis([24 27  119  122 0 120]);
hold on;
plot3(FAI.Latitude,119*ones(size(FAI.Latitude)),FAI.Altitude,'.');
hold on;
plot3(27*ones(size(FAI.Longtitude)),FAI.Longtitude,FAI.Altitude,'.');
hold on;
plot3(FAI.Latitude,FAI.Longtitude,0*ones(size(FAI.Longtitude)),'.');
hold on;

plot3(Latitude_ChungLi,Longitude_ChungLi,0,'p');
xlabel('Latitude (deg)','fontsize',14);
ylabel('Longtitude (deg)','fontsize',14);
zlabel('Height (km)','fontsize',14);

grid on;
% axis square;

