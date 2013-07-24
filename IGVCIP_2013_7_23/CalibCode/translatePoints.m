% TRANSLATEPOINTS Translate points by matrix transform
% [X, Y, Z] = translatePoints(T, X, Y, Z)
function [X, Y, Z] = translatePoints(T, X, Y, Z)
%4xN=4x4*4xN
    pp = [ X(:), Y(:), Z(:) ];
    pp(:,4) = 1;
    pp = (T*pp')';
    X = pp(:,1);
    Y = pp(:,2);
    Z = pp(:,3);
end
    

%X=[1 2 3 4 5],Y=[5 6 7 8 9],Z=[9 9 9 9 9]