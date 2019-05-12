% 画中坜雷达预测回波区域
close all
clear all
clc
% Step 1: Inputs
Longitude_ChungLi = 121.1855583;%中坜雷达站经度121.19°E，24.96°N
Latitude_ChungLi = 24.96773;
Re = 6371.2; %地球半径 km
n = datenum('4-aug-15','dd-mmm-yy');% Date
% n = datenum('1-jan-15','dd-mmm-yy');% Date
% i=1;%存储预测回波点的个数

%打开保存记录数据的文件
fid_Azim = fopen('Recorded_azimuth.txt','wt');  
fid_Elevat = fopen('Recorded_elevation.txt','wt');  
fid_Alt = fopen('Recorded_altitude.txt','wt'); 



%设置循环变量
% for Azimuth = -13:0.2:13;  %雷达天线波束方位角-30到-4 deg %% 中坜雷达天线架设为北偏西17°若以雷达波束指向为0°，则范围为-13°到13°
for Azimuth = -30:0.2:-4;  %雷达天线波束方位角-30到-4 deg % 中坜雷达天线架设为北偏西17°若以雷达波束指向为0°，则范围为-13°到13°
    Azimuth %显示Azimuth值
    for Elevation = 46:0.05:54; %雷达天线波束仰角 deg % 设定仰角范围
        for	Altitude = 90:0.3:120; %海拔高度 km
% Azimuth = -17;
% Elevation = 50;
% Altitude = 100;

Beta = asind(Re.*sind(90+Elevation)./(Re+Altitude)); %雷达波束方向与 FAI和地心连线夹角
Alpha = 180-(90+Elevation)-Beta; %雷达站点和地心连线与不均匀体和地心连线夹角
S = (Re+Altitude).*sind(Alpha)./sind(90+Elevation); %雷达站点到FAI向量
%将S分解
SV = S.*cosd(Beta); %S在高度方向分量 方向垂直地表面向上
SH = S.*sind(Beta); %S在地面方向分量
SSN = SH.*cosd(Azimuth); %S在南北方向分量 北边为正 南边为负
SEW = SH.*sind(Azimuth); %S在东西方向分量 东边为正 西边为负
%S向量
S_Vector(1) = SSN;   %磁场Bx方向     %   -BX: Northward component of the magnetic field in nanoteslas (nT).
S_Vector(2) = SEW;   %磁场By方向      %   -BY: Eastward component of the magnetic field in nT.
S_Vector(3) = -SV;   %磁场Bz方向  %   -BZ: Downward component of the magnetic field in nT.

%算FAI的经纬度
Arc_TB = Alpha;%SH./Re;
Arc_NB = 90-Latitude_ChungLi;
Arc_TN = acosd(cosd(Arc_TB).*cosd(Arc_NB)+sind(Arc_TB).*sind(Arc_NB).*cosd(Azimuth));
Delta = asind(sind(Arc_TB)./sind(Arc_TN).*sind(Azimuth));
FAI.Latitude = 90-Arc_TN;
FAI.Longtitude = Longitude_ChungLi+Delta;
FAI.Altitude = Altitude;
% Step 2: Location of points in echoing region

B = igrf(n,FAI.Latitude,FAI.Longtitude,FAI.Altitude,'geod');% IGRF 模型先输入纬度再输入经度B = IGRF(TIME, LATITUDE, LONGITUDE, ALTITUDE, COORD) B: [BX(:), BY(:), BZ(:)].
% Step 3: Recording azimuth and elevation angle of echoing points
% dot(S_Vector,B)==0
if abs(acosd(dot(S_Vector,B)./norm(S_Vector,2)./norm(B,2))-90)<=0.1;%0.1
%     Expected(i).Azim = Azimuth;
%     Expected(i).Elevat = Elevation;
%     Expected(i).Alt = Altitude;
%     i=i+1;
    %将记录的点写文件
    fprintf(fid_Azim,'%g\n',Azimuth);    
    fprintf(fid_Elevat,'%g\n',Elevation);    
    fprintf(fid_Alt,'%g\n',Altitude);    

end

        end
    end
end
%关闭文件
fclose(fid_Azim);
fclose(fid_Elevat);
fclose(fid_Alt);


