clc;
clear;
close all;

%read the database and define labels to print
load ndataset.mat
labels={'Smoker' 'Drink Level' 'Activity' 'Budget','Personality'};

% variables
fname='rules1';
sortFlag=true;
minSup = 0.1;
minConf = 0.4;
nRules = 1000;
%apply apriori algorithm on all windows
[Rules,RuleSup,RuleConf] = findRules(ndataset, minSup, minConf, nRules, sortFlag, labels, fname);
count = DisplayRules(Rules,RuleSup,RuleConf,labels);

%calculate weight
weight=zeros(1,4);
numRules=0;
for i=1:count
    antecedent=cell2mat(Rules{1,1}(i));
    consequent=cell2mat(Rules{2,1}(i));
    if find(antecedent==5,1,'first')
        numRules=numRules+1;
      for j=1:length(consequent)
          if consequent(j)==1
              weight(1,1)=weight(1,1)+1;
          elseif consequent(j)==2
              weight(1,2)=weight(1,2)+1;
          elseif consequent(j)==3
              weight(1,3)=weight(1,3)+1;
          elseif consequent(j)==4
              weight(1,4)=weight(1,4)+1;
          end
      end
      for j=1:length(antecedent)
          if antecedent(j)==1
              weight(1,1)=weight(1,1)+1;
          elseif antecedent(j)==2
              weight(1,2)=weight(1,2)+1;
          elseif antecedent(j)==3
              weight(1,3)=weight(1,3)+1;
          elseif antecedent(j)==4
              weight(1,4)=weight(1,4)+1;
          end
      end
    end
end

 
[val,ind]=sort(weight);
group1=[];
group2=[];
j=1;
k=1;
for i=1:length(val)
    if val(i)>10
        group1(j)=ind(i);
        j=j+1;
    else
        group2(k)=ind(i);
        k=k+1;
    end
end

fprintf('selected group is :');
for i=1:length(group1)
    fprintf('%s, ',char(labels(group1(i))));
end
fprintf('\n');