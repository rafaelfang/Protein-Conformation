function [ dist ] = Floyd_Warshall( D )
%FLOYD_WARSHALL algorithm
%   Written by Chao Fang
n=size(D,1);
dist=ones(n,n)*Inf;
    for i=1:n
        for j=1:n
            dist(i,j)=D(i,j);
        end
    
    end


    for k=1:n
        for i=1:n
            for j=1:n
                if(dist(i,j)>dist(i,k)+dist(k,j))
                    dist(i,j)=dist(i,k)+dist(k,j);
                end
            end
        end
    end




end

