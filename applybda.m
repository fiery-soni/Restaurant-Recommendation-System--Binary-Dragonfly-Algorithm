clc
clear
close all

% read data file
load data.mat data
UIDS=data{1,1};
uuid=unique(UIDS); %all user ids(customers)
places=data{1,2}(:,1);
placeids=unique(data{1,2}(:,1));
placeids=placeids'; %all restaurent
fulldata=data{1,2};
ratings=fulldata(:,2);

d=2; %Maximum allowable rating
num=20; %number of clients taken
rates=ratings;
UID=UIDS;
place=places;

%test user details
testUserId='U1001';
testUserRatings=[];
testUserRatingsall=[];
%make copy for future use
testUserTr=0;
testUserPlaces=[];
testUserPlacesall=[];
i=1;
k=1;

while i<=length(UIDS)
    if strcmp(UIDS{i},testUserId)==1
        testUserTr=testUserTr+1;
        testUserRatingsall(1,k)=ratings(i);
        testUserPlacesall(1,k)=places(i);
        k=k+1;
    end
    i=i+1;
end

%enter size of test set
taken=2;
prompt = {'Enter Size Of Test Set (2/4/6/8) :'};
dlg_title = 'Input';
num_lines = 1;
def = {'2'};
while true
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    taken=str2double(cell2mat(answer(1)));
    if taken==2 || taken==4 || taken==6 || taken==8
        break;
    else
        continue;
    end
end

for i=1:taken
    if testUserRatingsall(1,i)~=0
        testUserRatings(1,i)=testUserRatingsall(1,i);
        testUserPlaces(1,i)=testUserPlacesall(1,i);
    end
end

%find corated places,ratings and clients
coratedplace=[];
coratings=[];
couids=[];
k=1;
for i=1:length(UIDS)
    if strcmp(UIDS{i},testUserId)~=1
        if ~isempty(find(testUserPlaces==places(i), 1))
            coratedplace(k,1)=places(i);
            couids{k,1}=UIDS{i};
            coratings(k,1)=ratings(i);
            k=k+1;
        end
    end
end

%removal of rows for test user and same places
i=length(UIDS);
while i>=1
    if strcmp(UIDS{i},testUserId)==1
        ratings(i)=[];
        UIDS(i)=[];
        places(i)=[];
    else
        if ~isempty(find(testUserPlaces==places(i), 1))
            places(i)=[];
            ratings(i)=[];
            UIDS(i)=[];
        end
    end
    i=i-1;
end

%get rating of users other than target client
OUID={};
pl=unique(places);
cols= length(unique(places));
rows=length(uuid)-1;
datas=zeros(rows,cols);
i=1;
k=1;
tr=zeros(rows,cols);
tnr=zeros(rows,cols);
temp={};
while i<=length(UIDS)
    if i==1
        row = str2double(extractAfter(UIDS{i},2));
        OUID{row}=UIDS{i};
        temp{k}=UIDS{i};
        col=find(pl==places(i,1),1);
        datas(row,col)=ratings(i);
        tr(row,col)=1;
        i=i+1;
    else
        if i>length(UIDS)
            break;
        end
        index=strfind(temp,UIDS(i));
        x=find(not(cellfun('isempty',index)));
        if isempty(x)
            row = str2double(extractAfter(UIDS{i},2));
            OUID{row}=UIDS{i};
            temp{k}=UIDS{i};
            col=find(pl==places(i,1),1);
            datas(row,col)=ratings(i);
            tr(row,col)=1;
            i=i+1;
        else
            row = str2double(extractAfter(UIDS{i},2));
            j=tr(row)+1;
            col=find(pl==places(i,1),1);
            datas(row,j)=ratings(i);
            tr(row,col)=tr(row,col)+1;
            i=i+1;
            k=k-1;
        end
    end
    if i>length(UIDS)
        break;
    end
    while true
        if strcmp(temp{k},UIDS{i})==1
            col=find(pl==places(i,1),1);
            datas(row,col)=ratings(i);
            tr(row,col)=tr(row,col)+1;
            i=i+1;
            if i>length(UIDS)
                break;
            end
        else
            break;
        end
    end
    k=k+1;
    if i>length(UIDS)
        break;
    end
end
tr(1,:)=[];
datas(1,:)=[];
OUID(1)=[];

%for 20 neighbours
datas20=datas(1:20,:);
tr20=tr(1:20,:);
OUID20=OUID(1:20);
rows=size(datas20,1);
cols=size(datas20,2);
for i=1:rows
    for j=1:cols
        tnr20(i,j)=length(pl)-tr20(i,j);
    end
end
nar=size(datas20,2); %Number of allowable top-n recommendation

%calling binary dragon fly algorithm
[Best_pos]=BDA(datas20,tr20,tnr20,nar);
neighbours={};
k=1;
for i=1:length(Best_pos)
    if Best_pos(i)>0.3 && Best_pos(i)<2
        neighbours{k}=OUID20{i};
        k=k+1;
    end
end

%find ik ,identification of best neighbors
rows1=length(neighbours);
cols1=size(placeids,2);
ik=zeros(rows1,cols1);

for i=1:rows1
    r=strfind(UID(:),neighbours{i});
    x=find(not(cellfun('isempty',r)));
    pls=place(x);
    for j=1:length(pls)
        col=find(placeids==pls(j,1),1);
        col1=find(testUserPlaces==pls(j,1),1);
        if ~isempty(col) && ~isempty(col1)
            ik(i,col)=(d-abs(testUserRatings(col1)-rates(x(j))))/d;
        elseif ~isempty(col) && isempty(col1)
            ik(i,col)=(d-abs(0-rates(x(j))))/d;
        elseif isempty(col) && ~isempty(col1)
            ik(i,col)=(d-abs(testUserRatings(col1)-0))/d;
        end
        
    end
end
%find wk
wk=zeros(rows1,cols1);

for i=1:rows1
    r=strfind(UID(:),neighbours{i});
    x=find(not(cellfun('isempty',r)));
    pls=place(x);
    for j=1:length(pls)
        col=find(placeids==pls(j,1),1);
        if ~isempty(col)
            wk(i,col)=1;
        else
            wk(i,col)=0;
        end
    end
end

%find overall similarity
sim=zeros(rows1,1);

for i=1:rows1
    w=0;
    for j=1:cols1
        s=(wk(i,j)*ik(i,j));
        w=w+wk(i,j);
        if ~isnan(s)
            sim(i)=sim(i)+s;
        end
    end
    sim(i)=sim(i)/w;
end

loc=find(sim>=0.1);
bestneighbours=neighbours(loc);
fprintf('Best Neighbours are\n');
for i=1:length(bestneighbours)
   fprintf('%s\t', bestneighbours{i});
end
fprintf('\n');

%rating prediction
unratedplace=[];
k=1;
for i=1:length(placeids)
    if isempty(find(testUserPlaces==placeids(i),1))
    unratedplace(k)=placeids(i);
    k=k+1;
    end
end
unratedplace=sort(unratedplace);
prate=[];
k=1;

for i=1:length(bestneighbours)
    index=strfind(OUID,bestneighbours{i});
    x=find(not(cellfun('isempty',index)));
    if x>0
        prate(k,:)=datas20(x,:);
        k=k+1;
    end
end
%find standard deviation
stddev=[];

for i=1:size(prate,2)
    stddev(i)=std(prate(:,i));
end
%rating prediction
prerates=zeros(size(prate,1),size(prate,2));
for i=1:size(prate,1)
    for j=2:size(prate,2)
       prerates(i,j)=(prate(i,(j-1))-stddev(j-1))^2 * stddev(j)* (stddev(j)/stddev(j-1));
    end
end

% % Recommendation generation
Vy=1;
highly=[];
recomms=[];
recomm_not=[];
highly_not=[];
for i=1:size(prerates,1)
    for j=1:size(prerates,2)
        if (prerates(i,j)-Vy)>=-1 && (prerates(i,j)-stddev(j))>0
          highly=[highly;pl(j)];
        elseif (prerates(i,j)-Vy)>=-1 && (prerates(i,j)-stddev(j))<=0
            if isempty(find(highly==pl(j),1))
                recomms=[recomms;pl(j)];
            end
        elseif (prerates(i,j)-Vy)<=-1 && (prerates(i,j)-stddev(j))>0
            if isempty(find(highly==pl(j),1)) && isempty(find(highly==pl(j),1))
                recomm_not=[recomm_not;pl(j)];
            end
        elseif (prerates(i,j)-Vy)<-1 && (prerates(i,j)-stddev(j))<=0
            if isempty(find(highly==pl(j),1)) && isempty(find(recomms==pl(j),1)) && isempty(find(recomm_not==pl(j),1))
                highly_not=[highly_not;pl(j)];
            end
        else
            if ~isnan(prerates(i,j)-Vy) && ~isnan(prerates(i,j)-stddev(j)) && mod(i,2)==0
                    highly_not=[highly_not;pl(j)];
            end
        end
    end
end

highly=unique(highly);
recomms=unique(recomms);
recomm_not=unique(recomm_not);
highly_not=unique(highly_not);
fprintf('Recommended Restaurent \n')
fprintf('---------------------------\n');
fprintf('Highly Recommended :\n');
for i=1:length(highly)
    fprintf('               %d\n',highly(i));
end
fprintf('\nRecommended :\n');
for i=1:length(recomms)
    fprintf('               %d\n',recomms(i));
end
fprintf('-------------------------------\n');

%coverage calculation
countrates=length(highly)+length(recomms);
tau=countrates;
rho=length(highly)+length(highly_not)+2*length(recomms)+length(recomm_not);
coverage=tau/rho;

calc=0;
count=0;
for i=1:size(prerates,1)
    for j=1:size(prerates,2)
        if ~isnan(prerates(i,j))
            calc=calc+(prerates(i,j)-prate(i,j))^2;
             if prerates(i,j)~=0
                count=count+1;
            end
        end
    end
end

rmse=sqrt(calc/count);
maximumpossibleerror=2;
precision=(1 -(rmse/maximumpossibleerror));
f_measure=(2*precision*100*coverage)/(precision*100+coverage);

fprintf('Coverage :%f\n',coverage*100);
fprintf('Root Mean Square Error :%f\n',rmse);
fprintf('Precision :%f%%\n',precision*100);
fprintf('F-Measure :%f\n',f_measure);

if taken==2
    results2p=[coverage rmse precision*100 f_measure];
    save result2p.mat results2p
elseif taken==4
    results4p=[coverage rmse precision*100 f_measure];
    save result4p.mat results4p
elseif taken==6
    results6p=[coverage rmse precision*100 f_measure];
    save result6p.mat results6p
elseif taken==8
    results8p=[coverage rmse precision*100 f_measure];
    save result8p.mat results8p
end