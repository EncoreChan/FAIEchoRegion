function[]=process(Azimuth,fid_height,fid_range)

Latitude_Fuke = 19.5;        %�����״�γ��
Longitude_Fuke = 109.1;      %�����״ﾭ��
 
              %����Ϊ��������ʱ��λ��Ϊ0
Re = 6371.2;                 %����뾶(km)
n = datenum('4-aug-15','dd-mmm-yy');  

for Elevation = 45:0.1:65
  for Height =100:1:600
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
      if abs(acosd(dot(S_Vector,B)./norm(S_Vector,2)./norm(B,2))-90)<=0.5  %�ж��״ﲨ��ָ����شų��н��Ƿ���90���0.5��
    fprintf(fid_height,'%g\n',Height);    
    fprintf(fid_range,'%g\n',S);            
      end
  end
end 
end