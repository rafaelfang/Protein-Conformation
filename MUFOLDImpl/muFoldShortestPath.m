function [primaryTemplate]=muFoldShortestPath(templates,primaryTemplateSelected)
% close all
% clear
% clc
% load T0659TemplatesData.mat
% primaryTemplateSelected=1;


%% find the holes in the primary template

primaryTemplate=templates{primaryTemplateSelected, 1};
isHole=zeros(size(primaryTemplate,1),1);
for i=1:size(primaryTemplate,1)
    if(primaryTemplate(i,1)==10000)
        isHole(i,1)=1;
    end
end



%% find the starting and ending position of the holes
%holeInfo matrix is defined as: 
%ith hole: startPos,endPos,holeSize,hole patch taken from other templates
holeInfo=[];
prev=isHole(1,1);
startPos=0;
endPos=0;
if prev==1
    counter=1;
    startPos=1;
else
    counter=0;
end
for i=2:size(isHole,1)
    if isHole(i,1)==1&&prev==1
        counter=counter+1;
        endPos=i;
    elseif isHole(i,1)==1&&prev==0
        counter=1;
        startPos=i;
    elseif isHole(i,1)==0&&prev==1;
        endPos=i-1;
        holeInfo=[holeInfo; [startPos i-1 endPos-startPos+1 -1]];
        counter=0;
    else
        
    end
    prev=isHole(i,1);
        
end

if counter~=0
    holeInfo=[holeInfo; [startPos i i-startPos+1 -1]];
end


%% Round 1: replace the big distance value with 3.8
D=pdist2(primaryTemplate,primaryTemplate,'euclidean');
D(D>10e+2)=3.8;




%% Round 2: find available patches 
for ind=1:size(holeInfo,1)
    if(holeInfo(ind,3)==1||holeInfo(ind,3)==2)
        continue;
    end
    startPos=holeInfo(ind,1);
    endPos=holeInfo(ind,2);
    
    for i=1:size(templates,1)
        if(primaryTemplateSelected==i)
            continue;
        end
        temp=templates{i,1};
        I=find(temp(startPos:endPos,1)==10000);
        if size(I,1)==0
            
            holeInfo(ind,4)=i;
            break;
        else
            
        end
    end
end



%% cover the hole in distance matrix using the patches' distance matrix found from other templates;


for ind=1:size(holeInfo,1)
    if(holeInfo(ind,3)==1||holeInfo(ind,3)==2||holeInfo(ind,4)==-1)
        continue;
    end
    startPos=holeInfo(ind,1);
    endPos=holeInfo(ind,2);
    holeSize=holeInfo(ind,3);
    dockTemp=templates{holeInfo(ind,4),1};
    dockPatchMatrix=pdist2(dockTemp,dockTemp,'euclidean');
    if(startPos==1)
        dockingRange=[endPos+1:endPos+6-1];
    elseif(startPos==2)
        dockingRange=[1,endPos+1:endPos+5-1];
    elseif(startPos==3)
        dockingRange=[1:2,endPos+1:endPos+4-1];
    elseif(endPos==size(primaryTemplate,1))
        dockingRange=[startPos-7+1:startPos-1];
    elseif(endPos==size(primaryTemplate,1)-1)
        dockingRange=[startPos-6+1:startPos-1,size(primaryTemplate,1)];
    elseif(endPos==size(primaryTemplate,1)-2)
        dockingRange=[startPos-5+1:startPos-1,size(primaryTemplate,1)-1,size(primaryTemplate,1)];
    else
        dockingRange=[startPos-4+1:startPos-1,endPos+1:endPos+4-1];
    end
    
    D(dockingRange,dockingRange)=(D(dockingRange,dockingRange)+dockPatchMatrix(dockingRange,dockingRange))/2;
    
    
end


[ dist ] = Floyd_Warshall( D );
p=cmdscale(dist);
primaryTemplate=p(:,1:3);
end





