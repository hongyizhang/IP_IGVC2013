function [flagStop,flagDisplayImg] = DisplayImage(RGB,flagDisplayImg,plotim)
if flagDisplayImg == 0
    plotim = imshow(RGB); title('IEEE 1394 captured image');
    flagDisplayImg = 1;
else
    set(plotim,'CData',RGB); % use this do fast display
    drawnow;
end
flagStop = ishandle(plotim);
end