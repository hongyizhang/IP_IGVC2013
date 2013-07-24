
function [left_line, right_line, img] = huff_img(img)

    img = single(img);

    % s1 = cvlib('sobel', img, 1, 0, 3); 
    %s2 = cvlib('sobel', img, 0, 1, 3); 
%     %s1 = imfilter(img, fspecial('sobel'));
%     %s2 = imfilter(img, fspecial('sobel')'); % note the tick

    %img = s1 > 0 | s2 > 0;
    

    IM = size(img, 1);
    IN = size(img, 2);
%     TopRow = round(2/3 * IM);
TopRow = 0;
    
%     [left_line] = huff(img(TopRow:IM, 1:floor(IN/2)), 1);
    [left_line] = huff(img(:, 1:floor(IN/2)), 1);

    
    if(~isempty(left_line))
        left_line.point1(2) = left_line.point1(2) + TopRow;
        left_line.point2(2) = left_line.point2(2) + TopRow;
    end
    
%     [right_line] = huff(img(TopRow:IM, ceil(IN/2):IN), 1);
[right_line] = huff(img(:, ceil(IN/2):IN), 1);
    
    
    if(~isempty(right_line))
        right_line.point1(1) = right_line.point1(1) + IN/2;
        right_line.point2(1) = right_line.point2(1) + IN/2;

        right_line.point1(2) = right_line.point1(2) + TopRow;
        right_line.point2(2) = right_line.point2(2) + TopRow;
    end
end