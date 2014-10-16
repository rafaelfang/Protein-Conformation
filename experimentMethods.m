% function [diff1,diff2] =experimentMethods(proteinName,points,overlappingSize,alpha)
%% prepare dataset

proteinName='T0675';
load (proteinName);


overlappingSize=10;
alpha=0.01;
points = T0675(1:56,1:3);


totalPoints=size(points,1);
coords=points(1:totalPoints,:);


half=((totalPoints+overlappingSize)/2);
firstHalfOrigin=coords(1:half,:);
secondHalfOrigin=coords(size(firstHalfOrigin,1)-overlappingSize+1:end,:);




% figure;
subplot(3,3,1);
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalfOrigin(:,1),secondHalfOrigin(:,2),secondHalfOrigin(:,3),'r');
hold off
title({strcat(proteinName,' Original Structure'); strcat('set overlapping size: ', num2str(overlappingSize))})
xlabel('x')
ylabel('y')
zlabel('z')




noise=alpha*randn(half,3);
secondHalf=secondHalfOrigin+noise;
subplot(3,3,2);
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalf(:,1),secondHalf(:,2),secondHalf(:,3),'r');
hold off
title({strcat('add noise: ',num2str(alpha),'*randn(half,3)');' to second half'})
xlabel('x')
ylabel('y')
zlabel('z')


%% superimposing overlapping region method
R=rotx(30);
secondHalf=R*secondHalf';
secondHalf=secondHalf';
subplot(3,3,3);
% figure;
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalf(:,1),secondHalf(:,2),secondHalf(:,3),'r');
title('rotated second half 30 degreee')
hold off
xlabel('x')
ylabel('y')
zlabel('z')


Z=zeros(size(secondHalf));
Z(:,3)=10;
secondHalf=secondHalf-Z;
subplot(3,3,4);
%figure;
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalf(:,1),secondHalf(:,2),secondHalf(:,3),'r');
title('shifted second half away')
hold off
xlabel('x')
ylabel('y')
zlabel('z')


[~,Z,transform] = procrustes(firstHalfOrigin(half-overlappingSize+1:half,:),secondHalf(1:overlappingSize,:),'scaling',false);
c = transform.c;
T = transform.T;
b = transform.b;

secondHalfRecover = secondHalf*T+repmat(c(1,:),size(secondHalf,1),1) ;
    

subplot(3,3,5);
%figure;
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalfRecover(:,1),secondHalfRecover(:,2),secondHalfRecover(:,3),'r');
hold off
diff1=RMSD( secondHalfOrigin,secondHalfRecover);
title(strcat('superpos RMSD:',num2str(diff1)))
xlabel('x')
ylabel('y')
zlabel('z')



%% shortest path-based method

firstHalfOrigin=coords(1:half,:);
secondHalfOrigin=coords(size(firstHalfOrigin,1)-overlappingSize+1:end,:);



%add noise to second half
secondHalf=secondHalfOrigin+noise;






s1 = pdist2(firstHalfOrigin,firstHalfOrigin);
s2 = pdist2(secondHalf,secondHalf);
s=zeros(totalPoints,totalPoints);
s(1:half,1:half)=s1;
s(half-overlappingSize+1:end,half-overlappingSize+1:end)=s2;
subplot(3,3,6);
imagesc(s);
%colorbar;
title('s:combine s1 and s2')

s(1:half-overlappingSize,half+1:end)=Inf;
s(half+1:end,1:half-overlappingSize)=Inf;
subplot(3,3,7);
imagesc(s);
%colorbar;
title('s:set two blue parts into Inf')

s = Floyd_Warshall(s);
subplot(3,3,8);
imagesc(s);
%colorbar;
title('s:after Floyd')


p=cmdscale(s);
p=p(:,1:3);
firstHalfRecovered=p(1:half,:);
secondHalfRecovered=p(size(firstHalfRecovered,1)-overlappingSize+1:end,:);
subplot(3,3,9);
plot3(firstHalfRecovered(:,1),firstHalfRecovered(:,2),firstHalfRecovered(:,3));
hold on
plot3(secondHalfRecovered(:,1),secondHalfRecovered(:,2),secondHalfRecovered(:,3),'r');
hold off
diff2=RMSD( secondHalfOrigin,secondHalfRecovered );
title(strcat('shortest path RMSD:', num2str(diff2)))
xlabel('x')
ylabel('y')
zlabel('z')

% set(gcf,'PaperType','usletter')
% print('-dpng','-r0',strcat(proteinName,'Alpha',num2str(alpha),'OverlappingSize',num2str(overlappingSize)))

%  end