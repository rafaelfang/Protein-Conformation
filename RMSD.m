function [ value ] = RMSD( v,w )
%calculate the RMSD value
%written by Chao Fang

n=size(v,1);


value=sqrt(sum(sum((v-w).^2))/n);

end

