function H = R2H(year, beam, R)%读取年份，波束，R

%读取所输入波束和年份的理论RH
path = pwd;
filenameH = strcat(path,'/R2H/',num2str(beam),'/H',num2str(year),'.txt');
filenameR = strcat(path,'/R2H/',num2str(beam),'/R',num2str(year),'.txt');
Hreal = load(filenameH);
Rreal = load(filenameR);

%将理论的RH进行一阶傅里叶拟合
n = 1;
% Set up fittype and options.
ft = fittype( ['fourier',num2str(n)'] );
opts = fitoptions( ft );
opts.Display = 'Off';
% Fit model to data.
[fitresult, gof] = fit( Rreal, Hreal, ft, opts );

%将雷达返回的R值输入拟合曲线中得到实际H
H = fitresult(R);
