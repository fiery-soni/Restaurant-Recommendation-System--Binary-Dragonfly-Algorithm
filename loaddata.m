clc
clear
close all
% read data file
filename='userprofile.csv';
fid = fopen(filename, 'rt');
InputText = textscan(fid,'%s',1,'delimiter','\n');  % Read 1 header lines
data = textscan(fid, '%s %f %f %s %s %s %s %s %s %s %d %s %s %s %s %s %d %s %f', 'Delimiter',',', 'CollectOutput',1);
fclose(fid);

datah={};
UID={};
for i=1:length(data{1,1})
    UID{i,1}=data{1,1}(i);
end
datah=data{1,3}(:,1);
datah(:,2)=data{1,3}(:,2);
datah(:,3)=data{1,5}(:,4);
datah(:,4)=data{1,7};
datah(:,5)=data{1,5}(:,2);
save UID.mat UID
save datah.mat datah


% read data file
filename='rating_final.csv';
fid = fopen(filename, 'rt');
InputText = textscan(fid,'%s',1,'delimiter','\n');  % Read 1 header lines

data = textscan(fid, '%s %d %d %d %d', 'Delimiter',',', 'CollectOutput',1);
fclose(fid);
save data.mat data

%get unique user ids, restuarent ids, corresponding ratings
UIDS=data{1,1};
uuid=unique(UIDS);
places=data{1,2}(:,1);
placeids=unique(data{1,2}(:,1));
placeids=placeids';
fulldata=data{1,2};
ratings=fulldata(:,2);

OUID={};
datas=zeros(length(uuid),length(placeids));
i=1;
k=1;
tr=zeros(length(uuid),1);
temp={};

while i<=length(UIDS)
    if i==1
        row = str2double(extractAfter(UIDS{i},2));
        OUID{row}=UIDS{i};
        temp{k}=UIDS{i};
        col=find(placeids==fulldata(i,1),1);
        datas(row,col)=ratings(i);
        tr(row)=tr(row)+1;
        i=i+1;
    else
        index=strfind(temp,UIDS(i));
        x=find(not(cellfun('isempty',index)));
        
        if isempty(x)
            row = str2double(extractAfter(UIDS{i},2));
            OUID{row}=UIDS{i};
            temp{k}=UIDS{i};
            col=find(placeids==fulldata(i,1),1);
            datas(row,col)=ratings(i);
            tr(row)=tr(row)+1;
            i=i+1;
        else
            row = str2double(extractAfter(UIDS{i},2));
            col=find(placeids==fulldata(i,1),1);
            datas(row,col)=ratings(i);
            tr(row)=tr(row)+1;
            i=i+1;
            k=k-1;
        end
    end
    while true
        if strcmp(temp{k},UIDS{i})==1
            col=find(placeids==fulldata(i,1),1);
            datas(row,col)=ratings(i);
            tr(row)=tr(row)+1;
            i=i+1;
            if i>length(UIDS)
                break;
            end
        else
            break;
        end
    end
    
   
    
end

save tr.mat tr
save datas.mat datas
save OUID.mat OUID
save placeids.mat placeids
save ratings.mat ratings
save UIDS.mat UIDS

Personality={};
for i=1:length(OUID) 
   loc = str2double(extractAfter(OUID{i},2));
   Personality(i,1)=datah(loc,5);
end
save Personality.mat Personality

display 'Data Loaded Succesfully'