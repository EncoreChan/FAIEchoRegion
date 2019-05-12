% �������״�Ԥ��ز�����
close all
clear all
clc
% Step 1: Inputs
Longitude_ChungLi = 121.1855583;%�����״�վ����121.19��E��24.96��N
Latitude_ChungLi = 24.96773;
Re = 6371.2; %����뾶 km
n = datenum('4-aug-15','dd-mmm-yy');% Date
% n = datenum('1-jan-15','dd-mmm-yy');% Date
% i=1;%�洢Ԥ��ز���ĸ���

%�򿪱����¼���ݵ��ļ�
fid_Azim = fopen('Recorded_azimuth.txt','wt');  
fid_Elevat = fopen('Recorded_elevation.txt','wt');  
fid_Alt = fopen('Recorded_altitude.txt','wt'); 



%����ѭ������
% for Azimuth = -13:0.2:13;  %�״����߲�����λ��-30��-4 deg %% �����״����߼���Ϊ��ƫ��17�������״ﲨ��ָ��Ϊ0�㣬��ΧΪ-13�㵽13��
for Azimuth = -30:0.2:-4;  %�״����߲�����λ��-30��-4 deg % �����״����߼���Ϊ��ƫ��17�������״ﲨ��ָ��Ϊ0�㣬��ΧΪ-13�㵽13��
    Azimuth %��ʾAzimuthֵ
    for Elevation = 46:0.05:54; %�״����߲������� deg % �趨���Ƿ�Χ
        for	Altitude = 90:0.3:120; %���θ߶� km
% Azimuth = -17;
% Elevation = 50;
% Altitude = 100;

Beta = asind(Re.*sind(90+Elevation)./(Re+Altitude)); %�״ﲨ�������� FAI�͵������߼н�
Alpha = 180-(90+Elevation)-Beta; %�״�վ��͵��������벻������͵������߼н�
S = (Re+Altitude).*sind(Alpha)./sind(90+Elevation); %�״�վ�㵽FAI����
%��S�ֽ�
SV = S.*cosd(Beta); %S�ڸ߶ȷ������ ����ֱ�ر�������
SH = S.*sind(Beta); %S�ڵ��淽�����
SSN = SH.*cosd(Azimuth); %S���ϱ�������� ����Ϊ�� �ϱ�Ϊ��
SEW = SH.*sind(Azimuth); %S�ڶ���������� ����Ϊ�� ����Ϊ��
%S����
S_Vector(1) = SSN;   %�ų�Bx����     %   -BX: Northward component of the magnetic field in nanoteslas (nT).
S_Vector(2) = SEW;   %�ų�By����      %   -BY: Eastward component of the magnetic field in nT.
S_Vector(3) = -SV;   %�ų�Bz����  %   -BZ: Downward component of the magnetic field in nT.

%��FAI�ľ�γ��
Arc_TB = Alpha;%SH./Re;
Arc_NB = 90-Latitude_ChungLi;
Arc_TN = acosd(cosd(Arc_TB).*cosd(Arc_NB)+sind(Arc_TB).*sind(Arc_NB).*cosd(Azimuth));
Delta = asind(sind(Arc_TB)./sind(Arc_TN).*sind(Azimuth));
FAI.Latitude = 90-Arc_TN;
FAI.Longtitude = Longitude_ChungLi+Delta;
FAI.Altitude = Altitude;
% Step 2: Location of points in echoing region

B = igrf(n,FAI.Latitude,FAI.Longtitude,FAI.Altitude,'geod');% IGRF ģ��������γ�������뾭��B = IGRF(TIME, LATITUDE, LONGITUDE, ALTITUDE, COORD) B: [BX(:), BY(:), BZ(:)].
% Step 3: Recording azimuth and elevation angle of echoing points
% dot(S_Vector,B)==0
if abs(acosd(dot(S_Vector,B)./norm(S_Vector,2)./norm(B,2))-90)<=0.1;%0.1
%     Expected(i).Azim = Azimuth;
%     Expected(i).Elevat = Elevation;
%     Expected(i).Alt = Altitude;
%     i=i+1;
    %����¼�ĵ�д�ļ�
    fprintf(fid_Azim,'%g\n',Azimuth);    
    fprintf(fid_Elevat,'%g\n',Elevation);    
    fprintf(fid_Alt,'%g\n',Altitude);    

end

        end
    end
end
%�ر��ļ�
fclose(fid_Azim);
fclose(fid_Elevat);
fclose(fid_Alt);


