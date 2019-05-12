figure
hold on 

load height1.txt;
load range1.txt;
load height2.txt;
load range2.txt;
load height3.txt;
load range3.txt;
load height4.txt;
load range4.txt;
load height5.txt;
load range5.txt;
load height6.txt;
load range6.txt;
load height7.txt;
load range7.txt;

title('7²¨ÊøÄâºÏR-H¹ØÏµÍ¼','fontsize',14)
axis([100 600 100 700])

n = 2;

A1 = polyfit(range1,height1,n);
H1 = polyval(A1,range1);
plot(H1,range1,'LineWidth',2.0);


A2 = polyfit(range2,height2,n);
H2 = polyval(A2,range2);
plot(H2,range2,'LineWidth',2.0);


A3 = polyfit(range3,height3,n);
H3 = polyval(A3,range3);
plot(H3,range3,'LineWidth',2.0);

A4 = polyfit(range4,height4,n);
H4 = polyval(A4,range4);
plot(H4,range4,'LineWidth',2.0);

A5 = polyfit(range5,height5,n);
H5 = polyval(A5,range5);
plot(H5,range5,'LineWidth',2.0);

A6 = polyfit(range6,height6,n);
H6 = polyval(A6,range6);
plot(H6,range6,'LineWidth',2.0);

A7 = polyfit(range7,height7,n);
H7 = polyval(A7,range7);
plot(H7,range7,'LineWidth',2.0);

xlabel('height','fontsize',14);
ylabel('range','fontsize',14);
legend('Beam1','Beam2','Beam3','Beam4','Beam5','Beam6','Beam7');
