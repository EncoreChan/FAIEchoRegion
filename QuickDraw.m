figure
hold on 

title('XXX¹ØÏµÍ¼','fontsize',14)
axis([150 500 200 500])
load height1.txt;
load range1.txt;
plot(height1,range1,'.') 


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

legend('1','2','3','4','5','6','7');
xlabel('height','fontsize',14);
ylabel('range','fontsize',14);