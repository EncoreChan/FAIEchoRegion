%����ָ����������������
clear all;
close all;
clc;

Latitude_Fuke = 19.5;        %�����״�γ��
Longitude_Fuke = 109.1;      %�����״ﾭ��
 
Azimuth =0;                 %����Ϊ��������ʱ��λ��Ϊ0
Re = 6371.2;                 %����뾶(km)
n = datenum('4-aug-15','dd-mmm-yy');  
AzimuthTemp= zeros(5,1);
 
fid_Azim = fopen('azimuth.txt','wt');  
fid_Elevat = fopen('elevation.txt','wt');  
  

for base=-25:7.5:20    
for i=0:0.2:5
Azimuth=base+i;
 
for Elevation = 45:0.1:65
  for Height =300:10:400
    %�õ�����S�ı��ʽ   
    Beta = asind(Re.*sind(90+Elevation)./(Re+Height));          %�״ﲨ��������FAI�͵������߼н�
    Alpha = 90-Elevation-Beta;                                  %�״�վ��͵��������벻������͵������߼н�
    S = (sind(Alpha)/sind(90+Elevation))*(Re+Height);           %�״�վ�㵽FAI����
    
    %��S�ֽ�
    SV = S.*cosd(Beta);      %S�ڸ߶ȷ������ ����ֱ�ر�������
    SH = S.*sind(Beta);      %S�ڵ��淽�����
    SSN = SH.*cosd(Azimuth); %S���ϱ�������� ����Ϊ�� �ϱ�Ϊ��
    SEW = SH.*sind(Azimuth); %S�ڶ���������� ����Ϊ�� ����Ϊ��
    
    %S����
    S_Vector(1) = SSN;   %�ų�Bx����
    S_Vector(2) = SEW;   %�ų�By����
    S_Vector(3) = -SV;   %�ų�Bz����
    
    %����FAI�ľ�γ��
    Arc_TB = Alpha;
    Arc_NB = 90-Latitude_Fuke;
    Arc_TN = acosd(cosd(Arc_TB).*cosd(Arc_NB)+sind(Arc_TB).*sind(Arc_NB).*cosd(Azimuth));
    Delta = asind(sind(Arc_TB)./sind(Arc_TN).*sind(Azimuth));
    FAI.Latitude = 90-Arc_TN;
    FAI.Longitude = Longitude_Fuke+Delta;
    
    B = igrf(n,FAI.Latitude,FAI.Longitude,Height,'geod');
      if abs(acosd(dot(S_Vector,B)./norm(S_Vector,2)./norm(B,2))-90)<=0.1  %�ж��״ﲨ��ָ����شų��н��Ƿ���90���0.1��
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
 title('XXX��ϵͼ','fontsize',14)
 plot(azimuth,elevation,'.')
 axis([-25 25  46  62]);
xlabel('Azimuth','fontsize',14);
ylabel('Elevation','fontsize',14);


 

