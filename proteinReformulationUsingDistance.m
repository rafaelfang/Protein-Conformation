clear all
clc
close all
% points = 0:pi/50:10*pi;
% coords(:,3)=points(1:500);
% coords(:,1) = sin(coords(:,3));
% coords(:,2) = cos(coords(:,3));

load Protein;
points = Protein;
totalPoints=1000;
coords=points(1:totalPoints,:);
% load example1
% points=example1;
% totalPoints=500;
% coords=points(1:totalPoints,:);


pointsAlign=200;

half=((totalPoints+pointsAlign)/2);
firstHalf=coords(1:half,:);
secondHalf=coords(size(firstHalf,1)-pointsAlign+1:end,:);
% figure;
subplot(2,2,1);
plot3(firstHalf(:,1),firstHalf(:,2),firstHalf(:,3));
hold on
plot3(secondHalf(:,1),secondHalf(:,2),secondHalf(:,3),'r');
hold off
title('Original')
xlabel('x')
ylabel('y')
zlabel('z')



R=rotx(90);
secondHalf=R*secondHalf';
secondHalf=secondHalf';
subplot(2,2,2);
% figure;
plot3(firstHalf(:,1),firstHalf(:,2),firstHalf(:,3));
hold on
plot3(secondHalf(:,1),secondHalf(:,2),secondHalf(:,3),'r');
title('rotated')
hold off
xlabel('x')
ylabel('y')
zlabel('z')


Z=zeros(size(secondHalf));
Z(:,3)=10;
secondHalf=secondHalf-Z;
subplot(2,2,3);
%figure;
plot3(firstHalf(:,1),firstHalf(:,2),firstHalf(:,3));
hold on
plot3(secondHalf(:,1),secondHalf(:,2),secondHalf(:,3),'r');
title('shifted')
hold off
xlabel('x')
ylabel('y')
zlabel('z')


[d,Z,transform] = procrustes(firstHalf(half-pointsAlign+1:half,:),secondHalf(1:pointsAlign,:));
c = transform.c;
T = transform.T;
b = transform.b;

secondHalfRecover = secondHalf*T+repmat(c(1,:),size(secondHalf,1),1) ;
    

subplot(2,2,4);
%figure;
plot3(firstHalf(:,1),firstHalf(:,2),firstHalf(:,3));
hold on
plot3(secondHalfRecover(:,1),secondHalfRecover(:,2),secondHalfRecover(:,3),'r');
hold off
title(strcat('recoverd from procrustes with difference:',int2str(d)))
xlabel('x')
ylabel('y')
zlabel('z')








