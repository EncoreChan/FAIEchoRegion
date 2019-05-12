%波束指向正北方向的情况下
clear all;
close all;
clc;

fid_height = fopen('height1.txt','wt');  
fid_range = fopen('range1.txt','wt');
process(-22.5,fid_height,fid_range);
fclose(fid_height);
fclose(fid_range);

fid_height = fopen('height2.txt','wt');  
fid_range = fopen('range2.txt','wt');
process(-15,fid_height,fid_range);
fclose(fid_height);
fclose(fid_range);

fid_height = fopen('height3.txt','wt');  
fid_range = fopen('range3.txt','wt');
process(-7.5,fid_height,fid_range);
fclose(fid_height);
fclose(fid_range);

fid_height = fopen('height4.txt','wt');  
fid_range = fopen('range4.txt','wt');
process(0,fid_height,fid_range);
fclose(fid_height);
fclose(fid_range);

fid_height = fopen('height5.txt','wt');  
fid_range = fopen('range5.txt','wt');
process(7.5,fid_height,fid_range);
fclose(fid_height);
fclose(fid_range);

fid_height = fopen('height6.txt','wt');  
fid_range = fopen('range6.txt','wt');
process(15,fid_height,fid_range);
fclose(fid_height);
fclose(fid_range);

fid_height = fopen('height7.txt','wt');  
fid_range = fopen('range7.txt','wt');
process(22.5,fid_height,fid_range);
fclose(fid_height);
fclose(fid_range);

figure
hold on 

load height1.txt;
load range1.txt;
 title('XXX关系图','fontsize',14)
 plot(height1,range1,'.') 
xlabel('height','fontsize',14);
ylabel('range','fontsize',14);

load height2.txt;
load range2.txt;
plot(height2,range2,'.') 

load height3.txt;
load range3.txt;
plot(height3,range3,'.') 

load height4.txt;
load range4.txt;
plot(height4,range4,'.') 

load height5.txt;
load range5.txt;
plot(height5,range5,'.') 

load height6.txt;
load range6.txt;
plot(height6,range6,'.') 

load height7.txt;
load range7.txt;
plot(height7,range7,'.') 
 

