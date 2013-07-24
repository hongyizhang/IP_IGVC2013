function [lines, mag] = huff(img, line_count)
    [H, T, R] = hough(img, 'ThetaResolution', 3, 'RhoResolution', 10);
    P = houghpeaks(H, 10, 'threshold', ceil(0.5 * max(H(:))), 'NHoodSize', [9 9]);
  %P = myhoughpeaks2(H, 5, ceil(.5*max(H(:))), [11 11]);
    hlines = houghlines(img, T, R, P, 'FillGap', 7, 'MinLength', 20);
    
    j = zeros(2, length(hlines));
    mag = [];
    lines = [];
    if(isfield(hlines, 'point2') )
        j(:) = [hlines.point2] - [hlines.point1];
        [mag, ind] = sort(sqrt(j' .* j' * [ 1 ; 1]), 1, 'descend');   % norm(j(i, :))

        ind = ind(1:min(line_count, size(ind, 1))); % Top line_count only
        mag = mag(1:min(line_count, size(mag, 1))); % Top line_count only
        lines = hlines(ind); % ditto. also sorted by mag
    end
end

    
    
    
