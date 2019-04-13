clc
clear
close all

% PAA (Preference Aggregation Algorithm) 
load ratings.mat
load UIDS.mat
alluid=unique(UIDS);
num=length(alluid);
Kavg=zeros(num,1);
Kdif_avg=zeros(num,1);
Kagg=zeros(num,1);
Balance_factor=zeros(num,1);

for i=1:num
  IndexC = strfind(UIDS,alluid{i});  
  Index = find(not(cellfun('isempty',IndexC)));
  ravg=0;
  rdif=0;
  mu=0;
  temp=[];
  
  for j=1:length(Index)
      temp(j)=ratings(Index(j),1);
  end
  Emin=min(temp);
  for j=1:length(Index)
      ravg=ravg+temp(j);
      rdif=rdif+(temp(j)-Emin);
      mu=mu+1;
  end
  Kavg(i)=ravg/mu;
  Kdif_avg(i)=rdif/mu;
  Balance_factor(i)=0.5 * abs(Kavg(i)-Kdif_avg(i));
  Kagg(i)=Kavg(i)+Balance_factor(i);
end

% display userid and aggregate rating
fprintf('User Id      Aggredate Ratings\n');
fprintf('------------------------------\n');
for i=1:length(Kagg)
    fprintf(' %s          %f\n',UIDS{i},Kagg(i));
end
fprintf('------------------------------\n');

save alluid.mat alluid
save Kagg.mat Kagg
