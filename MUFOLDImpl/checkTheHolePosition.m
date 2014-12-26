close all
clc
clear
%check the template hole position to figure out the type of the holes
%written by Chao Fang
load T0753TemplatesData;
[ templatesSorted ] = sortTemplateBasedOnEValue( templates,Escores );
n=size(templatesSorted{1,1},1);
m=size(templatesSorted,1);
holeMatrix=zeros(n,m);
for i=1:m
    temp=templatesSorted{i,1};
    holeMatrix(:,i)=(temp(:,1)==10000);
    
end
imagesc(holeMatrix);
colorbar
title('hole position, yellow means a hole')
ylabel('position')
xlabel('template number')