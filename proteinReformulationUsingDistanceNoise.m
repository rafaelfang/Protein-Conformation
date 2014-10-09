clear all
clc
close all
% points = 0:pi/50:10*pi;
% coords(:,3)=points(1:500);
% coords(:,1) = sin(coords(:,3));
% coords(:,2) = cos(coords(:,3));
rng(1)
load Protein;
points = Protein;
totalPoints=1000;
coords=points(1:totalPoints,:);
% load example1
% points=example1;
% totalPoints=500;
% coords=points(1:totalPoints,:);

alpha=1;
pointsAlign=200;

half=((totalPoints+pointsAlign)/2);
noise=alpha*randn(half,3);
firstHalf=coords(1:half,:);

secondHalf=coords(size(firstHalf,1)-pointsAlign+1:end,:);

% figure;
subplot(2,3,1);
plot3(firstHalf(:,1),firstHalf(:,2),firstHalf(:,3));
hold on
plot3(secondHalf(:,1),secondHalf(:,2),secondHalf(:,3),'r');
hold off
title('Original')
xlabel('x')
ylabel('y')
zlabel('z')



firstHalf=firstHalf+noise;
secondHalf=secondHalf+noise;
subplot(2,3,2);
plot3(firstHalf(:,1),firstHalf(:,2),firstHalf(:,3));
hold on
plot3(secondHalf(:,1),secondHalf(:,2),secondHalf(:,3),'r');
hold off
title('add noise to original')
xlabel('x')
ylabel('y')
zlabel('z')



s1 = pdist2(firstHalf,firstHalf);
s2 = pdist2(secondHalf,secondHalf);
s=zeros(totalPoints,totalPoints);
s(1:half,1:half)=s1;
s(half-pointsAlign+1:end,half-pointsAlign+1:end)=s2;
subplot(2,3,3);
imagesc(s);
title('s:combine s1 and s2')

s(1:half-pointsAlign,half+1:end)=Inf;
s(half+1:end,1:half-pointsAlign)=Inf;
subplot(2,3,4);
imagesc(s);
title('s:set two black part into Inf')

s = FastFloyd(s);
subplot(2,3,5);
imagesc(s);
title('s:after applying floyd')


p=cmdscale(s);
p=p(:,1:3);
firstHalfRecovered=p(1:half,:);
secondHalfRecovered=p(size(firstHalfRecovered,1)-pointsAlign+1:end,:);
subplot(2,3,6);
plot3(firstHalfRecovered(:,1),firstHalfRecovered(:,2),firstHalfRecovered(:,3));
hold on
plot3(secondHalfRecovered(:,1),secondHalfRecovered(:,2),secondHalfRecovered(:,3),'r');
hold off
diff=procrustes(coords,p);
title(strcat('Use CMDSCALE to recover points and the difference from original is: ',num2str(diff)))
xlabel('x')
ylabel('y')
zlabel('z')



