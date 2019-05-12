BeamNum = 7;
Point = -22.5: 7.5 :22.5;  % 波束指向
AltRange = [200, 500];
DistRange = [-145, 145];

%%% 读数据1
fileVHF1 =  'FKT_VHF01_DFI_L11_02H_20140908120000.dat' ;
[fid,message]=fopen(fileVHF1,'r');

if fid==-1
    disp(message);  %使用fopen函数时，都测试其返回值是否为有效值,如果fid=-1,打开文件失败，message显示错误信息
end
%获取数据文件第一行说明文字
Head = textscan(fid, '%s', 1, 'delimiter', '');  % 文件头；

%获取数据文件中的数字类型数据
DataAll = textscan(fid, '%d64 %f %f ');
fclose(fid);

pointing = DataAll{1};     %数据文件第一列波束指向
echo_range = DataAll{2};   %数据文件第二列回波距离
echo_re = DataAll{3};      %数据文件第三列波束强度
clear DataAll

%%% 找到数据格式特征
DataHead = find(pointing>10);   %找到段首位置
DataNum = length(DataHead);     %数据段数，这个数据是420；
DataLgth = DataHead(2)-1;       %数据段长度；
BinNum = DataHead(2)-2;         %距离门长度；

%%% 整理数据
%%% 时间
TimeArrayi = pointing(DataHead)+80000;
TimeArray = num2str(TimeArrayi);
TimeAxis1 = datenum(TimeArray, 'yyyymmddHHMMSS');  %时间轴
% TimeAxis2 = reshape(TimeAxis1', length(TimeAxis1)/BeamNum ,BeamNum);  % 行为时间，列为Beams

%%%距离
Range1 = echo_range(2:DataLgth);  %波束1的range值信息
Altitude = Range1.* cosd(28.2);
L = length(Point);

%%%Amp
Ampi = reshape(echo_re,DataLgth,DataNum);
Amp2 = Ampi(2:DataLgth,:);   % 一列为一个Beam的数据，7列为一次扫描的7个Beam的数据，再下一次扫描，共扫描60次 7*60 = 420；
[Hang, Lie] = size(Amp2);
Nrange=800:874
M = mean(Amp2(Nrange,2));
Amp1(:,2)=Amp2(:,2)-M;