close all
clc
clear
%MUFOLD runner
%written by Chao Fang

load T0753TemplatesData;
[ templatesSorted ] = sortTemplateBasedOnEValue( templates,Escores );
numOfPrimaryTemplates=9;
primaryTemplateBuiltSuperPosition=cell(numOfPrimaryTemplates,1);
primaryTemplateBuiltShortestPath=cell(numOfPrimaryTemplates,1);

%original plot
% figure;
% for primaryTemplateSelected=1:numOfPrimaryTemplates
%    
%     
%         subplot(3,3,primaryTemplateSelected);
%         temp=templatesSorted{primaryTemplateSelected,1};
%         plot3(temp(:,1),temp(:,2),temp(:,3));
%         title(num2str(primaryTemplateSelected));
%     
% end



%after mufold

%% shortest path
figure;
%for primaryTemplateSelected=1:numOfPrimaryTemplates
    primaryTemplateSelected=5; %debug use
    %primaryTemplateSelected=7; %debug use
    %primaryTemplateSelected=8; %debug use
    [primaryTemplateBuiltShortestPath{primaryTemplateSelected,1}]=muFoldShortestPath(templatesSorted,primaryTemplateSelected);
    
        subplot(3,3,primaryTemplateSelected);
        temp=primaryTemplateBuiltShortestPath{primaryTemplateSelected,1};
        plot3(temp(:,1),temp(:,2),temp(:,3));
        title(num2str(primaryTemplateSelected));
 
%end
text('Position',[0,0],'String','shortestPath','color','b')   

%% superposition
figure;

for primaryTemplateSelected=1:numOfPrimaryTemplates
    %primaryTemplateSelected=2; %debug use
    %primaryTemplateSelected=7; %debug use
    %primaryTemplateSelected=8; %debug use
    [primaryTemplateBuiltSuperPosition{primaryTemplateSelected,1},plotflag,uncoveredHoleInfo]=muFoldSuperPosition(templatesSorted,primaryTemplateSelected);
    if(plotflag==1)
        subplot(3,3,primaryTemplateSelected);
        temp=primaryTemplateBuiltSuperPosition{primaryTemplateSelected,1};
        plot3(temp(:,1),temp(:,2),temp(:,3));
        title(num2str(primaryTemplateSelected));
    else 
        subplot(3,3,primaryTemplateSelected);
        temp=primaryTemplateBuiltSuperPosition{primaryTemplateSelected,1};
        for t=1:size(uncoveredHoleInfo,1)
            temp(uncoveredHoleInfo(t,1):uncoveredHoleInfo(t,2),:)=NaN;
        end
        plot3(temp(:,1),temp(:,2),temp(:,3));
        title(num2str(primaryTemplateSelected));
    end
end

text('Position',[0,0],'String','superposition','color','r')
%% use RMSD to compare both results.
RMSDarray=zeros(numOfPrimaryTemplates,1);
for primaryTemplateSelected=1:numOfPrimaryTemplates
    v=primaryTemplateBuiltSuperPosition{primaryTemplateSelected,1};
    w=primaryTemplateBuiltShortestPath{primaryTemplateSelected,1};
    [~, Z, ~] = procrustes(v,w);
    RMSDarray(primaryTemplateSelected,1)=RMSD( v,Z );
end
figure;
stem(RMSDarray);
title('RMSD: generated model difference between two methods')
xlabel('template ID');
ylabel('RMSD');