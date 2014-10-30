 function [diff1,diff2] =experimentMethods(proteinName,points,overlappingSize,alpha)
%% prepare dataset


totalPoints=size(points,1);
coords=points(1:totalPoints,:);


half=((totalPoints+overlappingSize)/2);
firstHalfOrigin=coords(1:half,:);
secondHalfOrigin=coords(size(firstHalfOrigin,1)-overlappingSize+1:end,:);




% figure;
subplot(4,3,1);
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalfOrigin(:,1),secondHalfOrigin(:,2),secondHalfOrigin(:,3),'r');
hold off
title({strcat(proteinName,' Original Structure'); strcat('set overlapping size: ', num2str(overlappingSize))})
xlabel('x')
ylabel('y')
zlabel('z')




noise=alpha*randn(half,3);
secondHalfAddedNoise=secondHalfOrigin+noise;
subplot(4,3,2);
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalfAddedNoise(:,1),secondHalfAddedNoise(:,2),secondHalfAddedNoise(:,3),'r');
hold off
title({strcat('add noise: ',num2str(alpha),'*randn(half,3)');' to second half'})
xlabel('x')
ylabel('y')
zlabel('z')


%% superimposing overlapping region method
R=rotx(30);
secondHalfAddedNoiseRotated=R*secondHalfAddedNoise';
secondHalfAddedNoiseRotated=secondHalfAddedNoiseRotated';
subplot(4,3,3);
% figure;
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalfAddedNoiseRotated(:,1),secondHalfAddedNoiseRotated(:,2),secondHalfAddedNoiseRotated(:,3),'r');
title('rotated second half 30 degreee')
hold off
xlabel('x')
ylabel('y')
zlabel('z')


moveMatrix=zeros(size(secondHalfAddedNoiseRotated));
moveMatrix(:,3)=10;
secondHalfAddedNoiseRotatedMoved=secondHalfAddedNoiseRotated-moveMatrix;
subplot(4,3,4);
%figure;
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalfAddedNoiseRotatedMoved(:,1),secondHalfAddedNoiseRotatedMoved(:,2),secondHalfAddedNoiseRotatedMoved(:,3),'r');
title('shifted second half away')
hold off
xlabel('x')
ylabel('y')
zlabel('z')


[~,~,transform] = procrustes(firstHalfOrigin(half-overlappingSize+1:half,:),secondHalfAddedNoiseRotatedMoved(1:overlappingSize,:),'scaling',false);
c = transform.c;
T = transform.T;
% b = transform.b;

secondHalfRecover = secondHalfAddedNoiseRotatedMoved*T+repmat(c(1,:),size(secondHalfAddedNoiseRotatedMoved,1),1) ;
    

subplot(4,3,5);
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



s1 = pdist2(firstHalfOrigin,firstHalfOrigin);
s2 = pdist2(secondHalfAddedNoise,secondHalfAddedNoise);
s=zeros(totalPoints,totalPoints);
s(1:half,1:half)=s1;
s(half-overlappingSize+1:end,half-overlappingSize+1:end)=s2;
subplot(4,3,6);
imagesc(s);
%colorbar;
title('s:combine s1 and s2')

s(1:half-overlappingSize,half+1:end)=Inf;
s(half+1:end,1:half-overlappingSize)=Inf;
subplot(4,3,7);
imagesc(s);
%colorbar;
title('s:set two blue parts into Inf')

s = Floyd_Warshall(s);
%   s=ShortPath(s);
subplot(4,3,8);
imagesc(s);
%colorbar;
title('s:after Floyd')


p=cmdscale(s);
p=p(:,1:3);

secondHalfFromCmdscale=p(size(firstHalfOrigin,1)-overlappingSize+1:end,:);
subplot(4,3,9);
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalfFromCmdscale(:,1),secondHalfFromCmdscale(:,2),secondHalfFromCmdscale(:,3),'r');
hold off
title('get points using cmdscale:');
xlabel('x')
ylabel('y')
zlabel('z')



[~,~,transform] = procrustes(coords,p,'scaling',false);

c = transform.c;
T = transform.T;
b = transform.b;
secondHalfRecovered = secondHalfFromCmdscale*T+repmat(c(1,:),size(secondHalfFromCmdscale,1),1) ;
subplot(4,3,10);
plot3(firstHalfOrigin(:,1),firstHalfOrigin(:,2),firstHalfOrigin(:,3));
hold on
plot3(secondHalfRecovered(:,1),secondHalfRecovered(:,2),secondHalfRecovered(:,3),'r');
hold off
diff2=RMSD( secondHalfOrigin,secondHalfRecovered );
title(strcat('shortest path RMSD:', num2str(diff2)))
xlabel('x')
ylabel('y')
zlabel('z')

  set(gcf,'PaperType','usletter')
  print('-dpng','-r0',strcat(proteinName,'Alpha',num2str(alpha),'OverlappingSize',num2str(overlappingSize)))

  end
