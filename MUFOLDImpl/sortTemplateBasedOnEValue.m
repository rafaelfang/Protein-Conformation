function [ templatesSorted ] = sortTemplateBasedOnEValue( templates,Escores )
%SORT TEMPLATE BASED ON EVALUE 
%written by Chao Fang
templatesSorted=cell(size(templates,1),1);
EMat=[(1:size(Escores,1))' Escores ];
index = flipud(sortrows(EMat,2));


for i=1:size(index,1)
    templatesSorted{i,1}=templates{index(i,1),1};
end

end

