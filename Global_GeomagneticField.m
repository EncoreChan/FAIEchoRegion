close all
clear all
clc

height = 100;
n = datenum('31-dec-16','dd-mmm-yy');
Z = zeros(181,361);
% for latitude  = -90:1:90; 
%     for longitude = -180:1:180;
%     [Bx,By,Bz] = igrf(n,latitude,longitude,height,'geod');% IGRF 模型先输入纬度再输入经度[BX, BY, BZ] = IGRF(TIME, LATITUDE, LONGITUDE, ALTITUDE, COORD)
%     Z(latitude+91,longitude+181)=Bz;
%     end
% end
for latitude  = -90:1:90
    [Bx,By,Bz] = igrf(n,latitude,-180:1:180,height,'geod');% IGRF 模型先输入纬度再输入经度[BX, BY, BZ] = IGRF(TIME, LATITUDE, LONGITUDE, ALTITUDE, COORD)
    Z(latitude+91,:)=Bz;% MATLAB IGRF 模型支持矩阵运算
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
contourf(-180:1:180,-90:1:90,Z,'Linestyle','none')
title(colorbar,'nT','fontsize',12)
hold on 
% Draw Map
load coast
plot(long,lat,'k')
axis([-180 180  -90  90]);
title('Bz','fontsize',14)
xlabel('Longitude(degree)','fontsize',14);
ylabel('Latitude(degree)','fontsize',14);

