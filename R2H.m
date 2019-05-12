function H = R2H(year, beam, R)%��ȡ��ݣ�������R

%��ȡ�����벨������ݵ�����RH
path = pwd;
filenameH = strcat(path,'/R2H/',num2str(beam),'/H',num2str(year),'.txt');
filenameR = strcat(path,'/R2H/',num2str(beam),'/R',num2str(year),'.txt');
Hreal = load(filenameH);
Rreal = load(filenameR);

%�����۵�RH����һ�׸���Ҷ���
n = 1;
% Set up fittype and options.
ft = fittype( ['fourier',num2str(n)'] );
opts = fitoptions( ft );
opts.Display = 'Off';
% Fit model to data.
[fitresult, gof] = fit( Rreal, Hreal, ft, opts );

%���״ﷵ�ص�Rֵ������������еõ�ʵ��H
H = fitresult(R);
