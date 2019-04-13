clc;
clear;
close all;

possibility=7;
while(1)
    xxx=menu('RMS','Load Data','Preprocess','Apply Rough Set','Profile Aggregation','Apply BDA','Comparision Graph','Exit');
    switch(xxx)
        case 1
            loaddata
        case 2
            preprocess
        case 3
            aprioritest
        case 4
            PAA
        case 5
            applybda
        case 6
            drawgraph
        case 7
            break;
    end
end

