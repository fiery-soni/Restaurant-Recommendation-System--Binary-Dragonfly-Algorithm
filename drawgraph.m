clc;
clear;
close all;
%base
load result2b.mat
load result4b.mat
load result6b.mat
load result8b.mat

%propose
load result2p.mat
load result4p.mat
load result6p.mat
load result8p.mat

% Create figure
 figure(1);
 nebh=[0 2 4 6 8];
 coverageb=[0 results2b(1) results4b(1) results6b(1) results8b(1)];
 coveragep=[0 results2p(1) results4p(1) results6p(1) results8p(1)];
 coverageb=coverageb*100;
 coveragep=coveragep*100;
 p1=plot(nebh,coverageb,'LineWidth',2,'Color','r');
 hold on;
 p2=plot(nebh,coveragep,'LineWidth',2,'Color','g');
 hold on;
 ylim([0 100]);
  
 %Create xlabel
  xlabel('Size of Test Set','FontWeight','bold','FontSize',11, 'FontName','Cambria');
%   Create ylabel
  ylabel('Percentage of Coverage','FontWeight','bold','FontSize',11,'FontName','Cambria');
% Create title
 title('Coverage','FontWeight','bold','FontSize',12,'FontName','Cambria');
 h=[p1(1);p2(1)];
 legend(h,'ACCF-DA','ACCF-BDA');
 

% Create figure
rmseb=[0 results2b(2) results4b(2) results6b(2) results8b(2)];
rmsep=[0 results2p(2) results4p(2) results6p(2) results8p(2)];

figure(2);
p1=plot(nebh,rmseb,'LineWidth',2,'Color','r');
hold on;
p2=plot(nebh,rmsep,'LineWidth',2,'Color','g');
hold on;
ylim([0 1]);
 % Create xlabel
 xlabel('Size of Test Set','FontWeight','bold','FontSize',11, 'FontName','Cambria');
 % Create ylabel
 ylabel('RMSE','FontWeight','bold','FontSize',11,'FontName','Cambria');
 % Create title
 title('RMSE','FontWeight','bold','FontSize',12,'FontName','Cambria');
h=[p1(1);p2(1)];
legend(h,'ACCF-DA','ACCF-BDA');

% Create figure
figure(3);
preb=[0 results2b(3) results4b(3) results6b(3) results8b(3)];
prep=[0 results2p(3) results4p(3) results6p(3) results8p(3)];

p1=plot(nebh,preb,'LineWidth',2,'Color','r');
hold on;
p2=plot(nebh,prep,'LineWidth',2,'Color','g');
hold on;
ylim([0 100]);
 % Create xlabel
 xlabel('Size of Test Set','FontWeight','bold','FontSize',11, 'FontName','Cambria');
 % Create ylabel
 ylabel('Precision','FontWeight','bold','FontSize',11,'FontName','Cambria');
 % Create title
 title('Precision','FontWeight','bold','FontSize',12,'FontName','Cambria');
h=[p1(1);p2(1)];
legend(h,'ACCF-DA','ACCF-BDA');

 figure(4);
 fmeasureb=[0 results2b(4) results4b(4) results6b(4) results8b(4)];
 fmeasurep=[0 results2p(4) results4p(4) results6p(4) results8p(4)];
 
 p1=plot(nebh,fmeasureb,'LineWidth',2,'Color','r');
 hold on;
 p2=plot(nebh,fmeasurep,'LineWidth',2,'Color','g');
 hold on;
 %  Create xlabel
 xlabel('Size of Test Set','FontWeight','bold','FontSize',11, 'FontName','Cambria');
 % Create ylabel
 ylabel('F-Measure','FontWeight','bold','FontSize',11,'FontName','Cambria');
  % Create title
  title('F-Measure','FontWeight','bold','FontSize',12,'FontName','Cambria');
 h=[p1(1);p2(1)];
 legend(h,'ACCF-DA','ACCF-BDA');
 
