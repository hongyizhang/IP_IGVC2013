function [ImgLaneLines] = VoteLaneLines416(ImgMask,M4,M16,E4,E16)
%% Resize the masks
% M1Full = MaskResize(ImgMask,M1);
M4Full = MaskResize(ImgMask,M4);
M16Full = MaskResize(ImgMask,M16);
% M64Full = MaskResize(ImgMask,M64);
%% Start Process
Mask = ImgMask;
%% Mask #1
% Mask_Temp = Mask.*M1Full;
% Update Lane Lines
% ImgLaneLines = Mask_Temp.*E1;
% Check if thge process has completed
% Mask = Mask-Mask_Temp;
% S = sum(Mask(:));
% if S~=0
    Mask_Temp = Mask.*M4Full;
    % Update Lane Lines
    ImgLaneLines = Mask_Temp.*E4;
    % Check if thge process has completed
    Mask = Mask-Mask_Temp;
    S = sum(Mask(:));
    if S~=0
        Mask_Temp = Mask.*M16Full;
        ImgLaneLines = ImgLaneLines + Mask_Temp.*E16;
%         Mask = Mask-Mask_Temp;
%         S = sum(Mask(:));
%         if S~=0
%             Mask_Temp = Mask.*M64Full;
%             ImgLaneLines = ImgLaneLines + Mask_Temp.*E64;            
%         end
    end
% end
end