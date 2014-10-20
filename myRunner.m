clear all
clc
close all

rng(1)
<<<<<<< HEAD

proteinName='T0652';
=======
proteinName='T0675';
>>>>>>> origin/master
load (proteinName);
points = T0652(1:100,1:3);


% proteinName='T0649';
% load (proteinName);
% points = T0649(101:200,1:3);

<<<<<<< HEAD
overlappingSizeArray=[10,20,40];
alphaArray=[0,0.01,0.1,1];

=======

overlappingSizeArray=[10,20,40];
alphaArray=[0,0.01,0.1,1];
points = T0675(1:56,1:3);
>>>>>>> origin/master
diff1=zeros(size(alphaArray,2),size(overlappingSizeArray,2));
diff2=zeros(size(alphaArray,2),size(overlappingSizeArray,2));
for i=1:size(overlappingSizeArray,2)
    for j=1:size(alphaArray,2)
        [diff1(j,i),diff2(j,i)]=experimentMethods(proteinName,points,overlappingSizeArray(1,i),alphaArray(1,j));
    end
end

