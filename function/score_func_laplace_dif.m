function y = dif_laplace_func(x)
%    if x >= 0
%        y = 1;
%    else
%        y = -1;
%    end
    y = 2*(x >= 0)-1;
end