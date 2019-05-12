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


%通过仰角算S在高度、南北、东西方向分量
Re = 6371.2; %地球半径 km
Beta = asind(Re*sind(90+Recorded_elevation)./(Re+Recorded_altitude)); %雷达波束方向与 FAI和地心连线夹角
Alpha = 180-(90+Recorded_elevation)-Beta; %雷达站点和地心连线与不均匀体和地心连线夹角
S = (Re+Recorded_altitude).*sind(Alpha)./sind(90+Recorded_elevation); %雷达站点到FAI向量
%将S分解
SV = S.*cosd(Beta); %S在高度方向分量 方向垂直地表面向上
SH = S.*sind(Beta); %S在地面方向分量
SSN = SH.*cosd(Recorded_azimuth); %S在南北方向分量 北边为正 南边为负
SEW = SH.*sind(Recorded_azimuth); %S在东西方向分量 东边为正 西边为负

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
Longitude_ChungLi = 121.19;%中坜雷达站经度121.19°E，24.96°N
Latitude_ChungLi = 24.96;
%由SSN 和 SEW 换算成经纬度
%算FAI的经纬度
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
set(gca,'Ydir','reverse')%坐标反转
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

