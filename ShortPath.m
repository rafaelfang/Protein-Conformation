function [X_short] = ShortPath(X)
%Return shortest path X_short between all vertices 
%X: Graph matrix. Matrix values are edges. 0 values mean "no connection"
%X_short: Graph matrix with shortest path filled in
[m,n] = size(X);

if(m ~= n)
    disp('Must be squared matrix');
    return;
end

for i=1:m-1  %set values to 3.8 to missing residues along diagonal
    if(X(i,i+1)==0)
        X(i,i+1) = 3.8;
        X(i+1,i) = 3.8;
    end
end

X1 = sparse(X); %create Sparse matrix (remove 0 elements)
X_short = graphallshortestpaths(X1); %find shortest path for 0 elements in matrix

end
