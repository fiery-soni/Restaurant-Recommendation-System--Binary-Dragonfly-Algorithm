function [count] = DisplayRules(Rules,RuleSup,RuleConf,labels)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
fprintf('Apriori Rules\n');
fprintf('%s                                        (%s, %s) \n', 'Rule', 'Support', 'Confidence');
fprintf('---------------------------------------------------------------------------------------\n');
count=0;
for i = 1:size(Rules{1},1)
    s1 = '';
    s2 = '';
    for j = 1:size(Rules{1}{i},2)
        if j == size(Rules{1}{i},2)
            s1 = [s1 labels{Rules{1}{i}(j)}];
        else
            s1 = [s1 labels{Rules{1}{i}(j)} ','];
        end
    end
    for k = 1:size(Rules{2}{i},2)
        if k == size(Rules{2}{i},2)
            s2 = [s2 labels{Rules{2}{i}(k)}];
        else
            s2 = [s2 labels{Rules{2}{i}(k)} ','];
        end
    end
    s3 = num2str(RuleSup(i)*100);
    s4 = num2str(RuleConf(i)*100);
         fprintf('%s -> %s  (%s%%, %s%%)\n', s1, s2, s3, s4);
        count=count+1;
 end
fprintf('-----------------------------------------------------------------------------------------\n');
fprintf('Number of Rules %d \n',count);
fprintf('-----------------------------------------------------------------------------------------\n');


end

