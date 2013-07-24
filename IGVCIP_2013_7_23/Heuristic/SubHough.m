% This function extracts the edge image using Hough Transform
% Input: BW image, Number of peaks
% Output: Edge Image
% Call function: EdgeImg = SubHough(BW,1);
function [EdgeImg] = SubHough(BW,NoPeaks)
%% Verify the inputs
% Verify arguments
switch nargin
    case 1
        NoPeaks = 1;
    case 2
    otherwise
        error('Number of input arguments of SubHough is from 1 to 2');
end
% Verify the Input Image
[R,C,CH] = size(BW);
if (R*C<10)
    warning('Input Image is too small');
end

% Hough transform
[H,theta,rho] = hough(BW,'ThetaResolution',3,'RhoResolution',10);
flag = isempty(H);
if (~flag)
    peaks = houghpeaks(H, NoPeaks, 'NhoodSize', [9 9],'Threshold',0.7*max(H(:)));
    % Generate lines
    line = [];
    line = houghlines(BW, theta, rho, peaks,'FillGap',10,'MinLength',20);
    EdgeImg = zeros(R,C,1);
    flag_empty = isempty(fieldnames(line));
    if(~flag_empty)
        No_Lines = length(line);
        for k = 1:1:No_Lines
            Lines.x = [];
            Lines.y = [];
            Index = [];
            % Lines.x = line(k).point1(2):1:line(k).point2(2);
            x0 = line(k).point1(2);
            y0 = line(k).point1(1);
            x1 = line(k).point2(2);
            y1 = line(k).point2(1);
            if (x1>x0)
                Lines.x = x0:1:x1;
                alpha = (y1-y0)/(x1-x0);
                Lines.y = floor(alpha*(Lines.x-x0)+y0);
                Index = [Lines.x',Lines.y'];
                [r c] = size(Index);
                for i=1:1:r
                    if ((Index(i,1)>0)&&(Index(i,2)>0))
                        EdgeImg(Index(i,1),Index(i,2)) = 1;
                    end
                end
            elseif (x1<x0)
                Lines.x = x1:1:x0;
                alpha = (y1-y0)/(x1-x0);
                Lines.y = floor(alpha*(Lines.x-x0)+y0);
                Index = [Lines.x',Lines.y'];
                [r c] = size(Index);
                for i=1:1:r
                    if ((Index(i,1)>0)&&(Index(i,2)>0))
                        EdgeImg(Index(i,1),Index(i,2)) = 1;
                    end
                end
            else
                if y1>y0
                    Lines.y = y0:1:y1;
                    Lines.x = zeros(size(Lines.y));
                    Lines.x = Lines.x + x0;
                else
                    Lines.y = y1:1:y0;
                    Lines.x = zeros(size(Lines.y));
                    Lines.x = Lines.x + x0;
                end
            end
            
            %             alpha = (y1-y0)/(x1-x0);
            %             Lines.y = floor(alpha*(Lines.x-x0)+y0);
            %             Index = [Lines.x',Lines.y'];
            %             [r c] = size(Index);
            %             for i=1:1:r
            %                 if ((Index(i,1)>0)&&(Index(i,2)>0))
            %                     EdgeImg(Index(i,1),Index(i,2)) = 1;
            %                 end
            %             end
        end
    end
else
    EdgeImg = zeros(size(BW));
end
end