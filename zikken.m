clc;
x = [-1,0,3,-4,5;6,0,8,9,0]

y = dif_laplace(x)

arrayfun(@dif_laplace,x)

function y = dif_laplace(x)
    y = x >= 0;
end