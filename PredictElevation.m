%波束指向正北方向的情况下
clear all;
close all;
clc;

Latitude_Fuke = 19.5;        %富克雷达纬度
Longitude_Fuke = 109.1;      %富克雷达经度
 
Azimuth =0;                 %波束为正北方向时方位角为0
Re = 6371.2;                 %地球半径(km)
n = datenum('4-aug-15','dd-mmm-yy');  
AzimuthTemp= zeros(5,1);
 
fid_Azim = fopen('azimuth.txt','wt');  
fid_Elevat = fopen('elevation.txt','wt');  
  

for base=-25:7.5:20    
for i=0:0.2:5
Azimuth=base+i;
 
for Elevation = 45:0.1:65
  for Height =300:10:400
    %得到向量S的表达式   
    Beta = asind(Re.*sind(90+Elevation)./(Re+Height));          %雷达波束方向与FAI和地心连线夹角
    Alpha = 90-Elevation-Beta;                                  %雷达站点和地心连线与不均匀体和地心连线夹角
    S = (sind(Alpha)/sind(90+Elevation))*(Re+Height);           %雷达站点到FAI向量
    
    %将S分解
    SV = S.*cosd(Beta);      %S在高度方向分量 方向垂直地表面向上
    SH = S.*sind(Beta);      %S在地面方向分量
    SSN = SH.*cosd(Azimuth); %S在南北方向分量 北边为正 南边为负
    SEW = SH.*sind(Azimuth); %S在东西方向分量 东边为正 西边为负
    
    %S向量
    S_Vector(1) = SSN;   %磁场Bx方向
    S_Vector(2) = SEW;   %磁场By方向
    S_Vector(3) = -SV;   %磁场Bz方向
    
    %计算FAI的经纬度
    Arc_TB = Alpha;
    Arc_NB = 90-Latitude_Fuke;
    Arc_TN = acosd(cosd(Arc_TB).*cosd(Arc_NB)+sind(Arc_TB).*sind(Arc_NB).*cosd(Azimuth));
    Delta = asind(sind(Arc_TB)./sind(Arc_TN).*sind(Azimuth));
    FAI.Latitude = 90-Arc_TN;
    FAI.Longitude = Longitude_Fuke+Delta;
    
    B = igrf(n,FAI.Latitude,FAI.Longitude,Height,'geod');
      if abs(acosd(dot(S_Vector,B)./norm(S_Vector,2)./norm(B,2))-90)<=0.1  %判断雷达波束指向与地磁场夹角是否在90°±0.1°
    fprintf(fid_Azim,'%g\n',Azimuth);    
    fprintf(fid_Elevat,'%g\n',Elevation);            
      end
  end
end 
end
end
load azimuth.txt;
load elevation.txt;
figure
hold on
 title('XXX关系图','fontsize',14)
 plot(azimuth,elevation,'.')
 axis([-25 25  46  62]);
xlabel('Azimuth','fontsize',14);
ylabel('Elevation','fontsize',14);


 

