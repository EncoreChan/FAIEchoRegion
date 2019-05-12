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
L = length(Point);

%%%Amp
Ampi = reshape(echo_re,DataLgth,DataNum);
Amp2 = Ampi(2:DataLgth,:);   % һ��Ϊһ��Beam�����ݣ�7��Ϊһ��ɨ���7��Beam�����ݣ�����һ��ɨ�裬��ɨ��60�� 7*60 = 420��
[Hang, Lie] = size(Amp2);
Nrange=800:874
M = mean(Amp2(Nrange,2));
Amp1(:,2)=Amp2(:,2)-M;