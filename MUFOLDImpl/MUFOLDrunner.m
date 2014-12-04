close all
clc
clear
%MUFOLD runner
%written by Chao Fang

load T0659TemplatesData;
[ templatesSorted ] = sortTemplateBasedOnEValue( templates,Escores );
numOfPrimaryTemplates=9;
primaryTemplateBuilt=cell(numOfPrimaryTemplates,1);

%original plot
figure;
for primaryTemplateSelected=1:numOfPrimaryTemplates
   
    
        subplot(3,3,primaryTemplateSelected);
        temp=templatesSorted{primaryTemplateSelected,1};
        plot3(temp(:,1),temp(:,2),temp(:,3));
        title(num2str(primaryTemplateSelected));
    
end



%after mufold


figure;
 for primaryTemplateSelected=1:numOfPrimaryTemplates
    %primaryTemplateSelected=6; %debug use
    %primaryTemplateSelected=7; %debug use
    %primaryTemplateSelected=8; %debug use
    [primaryTemplateBuilt{primaryTemplateSelected,1},plotflag]=mufold(templatesSorted,primaryTemplateSelected);
    if(plotflag==1)
        subplot(3,3,primaryTemplateSelected);
        temp=primaryTemplateBuilt{primaryTemplateSelected,1};
        plot3(temp(:,1),temp(:,2),temp(:,3));
        title(num2str(primaryTemplateSelected));
    else 
        
    end
 end
