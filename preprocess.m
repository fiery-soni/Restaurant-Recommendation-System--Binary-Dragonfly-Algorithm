clc
clear
close all

%load mat fle
load datah.mat
load UID.mat
%remove rows that does not contain values
[row,col]=size(datah);
for i=row:-1:1
    idx = find(strcmp(datah(i,:), '?'));
    if ~isempty(idx)
        datah(i,:)=[];
        UID(i)=[];
    end
end
save UID.mat UID
%% rough set conversion(bit vector format - information space)
[row,col]=size(datah);
dataset=zeros(row,col);
ndataset=zeros(row,col);

smoke=unique(datah(:,1));
dl=unique(datah(:,2));
ac=unique(datah(:,3));
bu=unique(datah(:,4));
pers=unique(datah(:,5));
for i=1:row
    if strcmpi(datah{i,1},smoke{2,1})
        dataset(i,1) = 1;
        ndataset(i,1) = 1;
    else
        dataset(i,1) = 0;
        ndataset(i,1) = 0;
    end
    if strcmpi(datah{i,2},dl{1,1})
        dataset(i,2) = 2;
        ndataset(i,2) = 1;
    elseif strcmpi(datah{i,2},dl{2,1})
        dataset(i,2) = 3;
        ndataset(i,2) = 1;
    else
        dataset(i,2) = 1;
        ndataset(i,2) = 0;
    end
    if strcmpi(datah{i,3},ac{1,1})
        dataset(i,3) = 4;
         ndataset(i,3) = 1;
    elseif strcmpi(datah{i,3},ac{2,1})
        dataset(i,3) = 2;
        ndataset(i,3) = 1;
    elseif strcmpi(datah{i,3},ac{3,1})
        dataset(i,3) = 1;
        ndataset(i,3) = 0;
    else
        dataset(i,3) = 3;
        ndataset(i,3) = 1;
    end
    if strcmpi(datah{i,4},bu{1,1})
        dataset(i,4) = 3;
        ndataset(i,4) = 1;
    elseif strcmpi(datah{i,4},bu{2,1})
        dataset(i,4) = 1;
        ndataset(i,4) = 0;
    else
        dataset(i,4) = 2;
        ndataset(i,4) = 1;
    end
    if strcmpi(datah{i,5},pers{1,1})
        dataset(i,5) = 1;
        ndataset(i,5) = 1;
    elseif strcmpi(datah{i,5},pers{2,1})
        dataset(i,5) = 2;
        ndataset(i,5) = 1;
    elseif strcmpi(datah{i,5},pers{3,1})
        dataset(i,5) = 3;
        ndataset(i,5) = 1;
    else
        dataset(i,5) = 4;
        ndataset(i,5) = 1;
    end
end

save dataset.mat dataset
save ndataset.mat ndataset
display 'Data Preprocessed Successfully'