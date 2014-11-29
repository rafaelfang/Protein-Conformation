close all
clc
clear

load T0659TemplatesData;
primaryTemplatePicked=1;
%% find the holes in the primary template
primaryTemplate=templates{primaryTemplatePicked, 1};
isHole=zeros(size(primaryTemplate,1),1);
for i=1:size(primaryTemplate,1)
    if(primaryTemplate(i,1)==10000)
        isHole(i,1)=1;
    end
end
%% find the starting and ending position of the holes
%holePosition matrix is defined as: 
%ith hole: startPos,endPos,holeSize,hole patch taken from other templates
holePosition=[];
prev=isHole(1,1);
startPos=1;
endPos=1;
if prev==1
    counter=1;
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
        holePosition=[holePosition; [startPos i-1 endPos-startPos+1 -1]];
        counter=0;
    else
        
    end
    prev=isHole(i,1);
        
end

if counter~=0
    holePosition=[holePosition; [startPos i endPos-startPos+1 -1]];
end


%% first round fill in the hole whose size is less than or equal to 2

for i=size(holePosition,1)
    if(holePosition(i,3)==1)
       primaryTemplate(holePosition(i,1),:)=(primaryTemplate(holePosition(i,1)-1,:)+primaryTemplate(holePosition(i,1)+1,:))/2;
    end
    if(holePosition(i,3)==2)
       primaryTemplate(holePosition(i,1),:)=primaryTemplate(holePosition(i,1)-1,:)+(primaryTemplate(holePosition(i,1)+2,:)+primaryTemplate(holePosition(i,1)-1,:))/3;
       primaryTemplate(holePosition(i,1)+1,:)=primaryTemplate(holePosition(i,1)-1,:)+2*(primaryTemplate(holePosition(i,1)+2,:)+primaryTemplate(holePosition(i,1)-1,:))/3;
    end
    
end



%% find available patches
for ind=1:size(holePosition,1)
    if(holePosition(ind,3)==1||holePosition(ind,3)==2)
        continue;
    end
    startPos=holePosition(ind,1);
    endPos=holePosition(ind,2);
    patchFound=0;
    for i=1:size(templates,1)
        if(primaryTemplatePicked==i)
            continue;
        end
        temp=templates{i,1};
        I=find(temp(startPos:endPos,1)==10000);
        if size(I,1)==0
            patchFound=1;
            holePosition(ind,3)=i;
            break;
        else
            
        end
    end
end
