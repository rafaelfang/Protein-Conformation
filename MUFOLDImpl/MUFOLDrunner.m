close all
clc
clear
%MUFOLD runner
%written by Chao Fang

load T0753TemplatesData;
[ templatesSorted ] = sortTemplateBasedOnEValue( templates,Escores );
numOfPrimaryTemplates=9;
primaryTemplateBuilt=cell(numOfPrimaryTemplates,1);

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
 for primaryTemplateSelected=1:numOfPrimaryTemplates
    %primaryTemplateSelected=2; %debug use
    %primaryTemplateSelected=7; %debug use
    %primaryTemplateSelected=8; %debug use
    [primaryTemplateBuilt{primaryTemplateSelected,1}]=muFoldShortestPath(templatesSorted,primaryTemplateSelected);
    
        subplot(3,3,primaryTemplateSelected);
        temp=primaryTemplateBuilt{primaryTemplateSelected,1};
        plot3(temp(:,1),temp(:,2),temp(:,3));
        title(num2str(primaryTemplateSelected));
    
 end


%% superposition
figure;
for primaryTemplateSelected=1:numOfPrimaryTemplates
    %primaryTemplateSelected=2; %debug use
    %primaryTemplateSelected=7; %debug use
    %primaryTemplateSelected=8; %debug use
    [primaryTemplateBuilt{primaryTemplateSelected,1},plotflag,uncoveredHoleInfo]=muFoldSuperPosition(templatesSorted,primaryTemplateSelected);
    if(plotflag==1)
        subplot(3,3,primaryTemplateSelected);
        temp=primaryTemplateBuilt{primaryTemplateSelected,1};
        plot3(temp(:,1),temp(:,2),temp(:,3));
        title(num2str(primaryTemplateSelected));
    else 
        subplot(3,3,primaryTemplateSelected);
        temp=primaryTemplateBuilt{primaryTemplateSelected,1};
        for t=1:size(uncoveredHoleInfo,1)
            temp(uncoveredHoleInfo(t,1):uncoveredHoleInfo(t,2),:)=NaN;
        end
        plot3(temp(:,1),temp(:,2),temp(:,3));
        title(num2str(primaryTemplateSelected));
    end
end
