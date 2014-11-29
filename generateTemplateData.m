% this file will read in data from the data folder
% and then generate template and EScores from each protein

clear
clc

numOfTemplates=56;



templates=cell(numOfTemplates,1);
Escores=zeros(numOfTemplates,1);
for i=1:numOfTemplates
    fid = fopen(strcat('./T0753templates/OMG_getBlockInfo_New__FUNC_OMG_calSegBkgCaMatrix__TemplateCoord__02_48_21__Number',num2str(i-1),'.txt'),'r');  % Open text file
    InputText = textscan(fid,'%s',1,'delimiter','\n');  % Read strings delimited
    % get the EValue from score function
    Scores=strsplit(InputText{1}{1},' ');
    Escores(i,1)=str2double(Scores{1,4});
    %populate the template
    template=[];
    while (~feof(fid)) 
        InputText = textscan(fid,'%s',1,'delimiter','\n');
        C=strsplit(InputText{1}{1},' ');
        row=[str2num(C{1}) str2num(C{2}) str2num(C{3})];
        template=[template;row];
    end
    templates{i,1}=template;
end
save ('T0753TemplatesData','Escores','templates');