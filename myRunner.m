clear all
clc
close all



rng(1)

proteinName='T0675';
load (proteinName);

rng(1)
overlappingSizeArray=[10,20,40];
alphaArray=[0,0.01,0.1,1];
points = T0675(1:56,1:3);

for i=1:size(overlappingSizeArray,2)
    for j=1:size(alphaArray,2)
        experimentMethods(proteinName,points,overlappingSizeArray(1,i),alphaArray(1,j))
    end
end