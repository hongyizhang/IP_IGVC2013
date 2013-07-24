% This function generates prediction of the previous lane lines in current
% frame.
%   * Input: MaskHeur: Heuristic Mask (8x8) of previous frame; v: forward
%   speed, v>0 if the robot is moving forward; w: Angular speed, w>0 if
%   the robot is rotating counterclockwise
%   * Output: MaskTrack: Probable positions of the previous lane lines in
%   current frame
%   * Call Function: MaskTrack = MaskTrackGenerate(MaskHeur,1,1);
function [MaskTrack] = MaskTrackGenerate(MaskHeur,v,w)
if nargin~=3
    MaskTrack.Overall = ones(8,8,1);
    MaskTrack.LeftLane = ones(8,8,1);
    MaskTrack.RightLane = ones(8,8,1);
else
    MaskTrack.Overall = zeros(8,8,1);
    MaskTrack.LeftLane = zeros(8,8,1);
    MaskTrack.RightLane = zeros(8,8,1);
    for r=2:7
        for c=2:7
            % Check Overall Mask
            if MaskHeur.Overall(r,c)>0
                if ((v>=0)&&(w>=0))
                    MaskTrack.Overall(r:r+1,c:c+1)=ones(2,2,1);
                elseif ((v>=0)&&(w<0))
                    MaskTrack.Overall(r:r+1,c-1:c)=ones(2,2,1);
                elseif ((v<0)&&(w>=0))
                    MaskTrack.Overall(r-1:r,c:c+1)=ones(2,2,1);
                else
                    MaskTrack.Overall(r-1:r,c-1:c)=ones(2,2,1);
                end
            end
            % Check Left Mask
            if MaskHeur.LeftLane(r,c)>0
                if ((v>=0)&&(w>=0))
                    MaskTrack.LeftLane(r:r+1,c:c+1)=ones(2,2,1);
                elseif ((v>=0)&&(w<0))
                    MaskTrack.LeftLane(r:r+1,c-1:c)=ones(2,2,1);
                elseif ((v<0)&&(w>=0))
                    MaskTrack.LeftLane(r-1:r,c:c+1)=ones(2,2,1);
                else
                    MaskTrack.LeftLane(r-1:r,c-1:c)=ones(2,2,1);
                end
            end
            % Check Right Mask
            if MaskHeur.RightLane(r,c)>0
                if ((v>=0)&&(w>=0))
                    MaskTrack.RightLane(r:r+1,c:c+1)=ones(2,2,1);
                elseif ((v>=0)&&(w<0))
                    MaskTrack.RightLane(r:r+1,c-1:c)=ones(2,2,1);
                elseif ((v<0)&&(w>=0))
                    MaskTrack.RightLane(r-1:r,c:c+1)=ones(2,2,1);
                else
                    MaskTrack.RightLane(r-1:r,c-1:c)=ones(2,2,1);
                end
            end
        end
    end
    
    % Check The velocity
    % shiftc = sign(w);
    % shiftr = sign(v);
    % Check the Heuristic Mask
    %     if max(MaskHeur.Overall(:))==0 % No Lane Lines detect
    %         % MaskTrack.Overall = ones(8,8,1);
    %         MaskTrack.Overall = zeros(8,8,1);
    %     else
    %         MaskTrack.Overall = MaskHeur.Overall;
    %         r = [];
    %         c = [];
    %         [r,c] = find(MaskTrack.Overall>0);
    %         Indr = find((r>1)&(r<8));
    %         Indc = find((c>1)&(c<8));
    %         if ((sum(Indr(:))>0)&&(sum(Indc(:))>0))
    %             Idxr = Indr(1,:);
    %             Idxc = Indc(1,:);
    %             if ((sum(Idxr(:))>0)&&(sum(Idxc(:))>0))
    %                 if ((v>=0)&&(w>=0))
    %                     %MaskTrack.Overall(r:r+1,c:c+1)=ones(2,2,1);
    %                     MaskTrack.Overall(r(Idxr):r(Idxr)+1,c(Idxc):c(Idxc)+1)=ones(2,2,1);
    %                 elseif ((v>=0)&&(w<0))
    %                     MaskTrack.Overall(r:r+1,c-1:c)=ones(2,2,1);
    %                 elseif ((v<0)&&(w>=0))
    %                     MaskTrack.Overall(r-1:r,c:c+1)=ones(2,2,1);
    %                 else
    %                     MaskTrack.Overall(r-1:r,c-1:c)=ones(2,2,1);
    %                 end
    %             else
    %                 MaskTrack.Overall = zeros(8,8,1);
    %             end
    %         else
    %             MaskTrack.Overall = zeros(8,8,1);
    %         end
    %     end
    % end
    % if max(MaskHeur.LeftLane(:))==0
    %     %MaskTrack.LeftLane = ones(8,8,1);
    %     MaskTrack.LeftLane = zeros(8,8,1);
    % else
    %     MaskTrack.LeftLane = MaskHeur.LeftLane;
    %     r = [];
    %     c = [];
    %     [r,c] = find(MaskTrack.LeftLane>0);
    %     Indr = find((r>1)&(r<8));
    %     Indc = find((c>1)&(c<8));
    %     if ((sum(Indr(:))>0)&&(sum(Indc(:))>0))
    %         Idxr = Indr(1,:);
    %         Idxc = Indc(1,:);
    %         if ((sum(Idxr(:))>0)&&(sum(Idxc(:))>0))
    %             if ((v>=0)&&(w>=0))
    %                 %MaskTrack.LeftLane(r:r+1,c:c+1)=ones(2,2,1);
    %                 MaskTrack.LeftLane(r(Idxr):r(Idxr)+1,c(Idxc):c(Idxc)+1)=ones(2,2,1);
    %             elseif ((v>=0)&&(w<0))
    %                 MaskTrack.LeftLane(r:r+1,c-1:c)=ones(2,2,1);
    %             elseif ((v<0)&&(w>=0))
    %                 MaskTrack.LeftLane(r-1:r,c:c+1)=ones(2,2,1);
    %             else
    %                 MaskTrack.LeftLane(r-1:r,c-1:c)=ones(2,2,1);
    %             end
    %         else
    %             MaskTrack.LeftLane = zeros(8,8,1);
    %         end
    %     else
    %         MaskTrack.LeftLane = zeros(8,8,1);
    %     end
    %     %MaskTrack.LeftLane(r:r+shiftr,c:c+shiftc)=ones(2,2,1);
    % end
    % if max(MaskHeur.RightLane(:))==0
    %     %MaskTrack.RightLane = ones(8,8,1);
    %     MaskTrack.RightLane = zeros(8,8,1);
    % else
    %     MaskTrack.RightLane = MaskHeur.RightLane;
    %     r = [];
    %     c = [];
    %     [r,c] = find(MaskTrack.RightLane>0);
    %     Indr = find((r>1)&(r<8));
    %     Indc = find((c>1)&(c<8));
    %     if ((sum(Indr(:))>0)&&(sum(Indc(:))>0))
    %         Idxr = Indr(1,:);
    %         Idxc = Indc(1,:);
    %         if ((sum(Idxr(:))>0)&&(sum(Idxc(:))>0))
    %             if ((v>=0)&&(w>=0))
    %                 % MaskTrack.RightLane(r:r+1,c:c+1)=ones(2,2,1);
    %                 MaskTrack.RightLane(r(Idxr):r(Idxr)+1,c(Idxc):c(Idxc)+1)=ones(2,2,1);
    %             elseif ((v>=0)&&(w<0))
    %                 MaskTrack.RightLane(r:r+1,c-1:c)=ones(2,2,1);
    %             elseif ((v<0)&&(w>=0))
    %                 MaskTrack.RightLane(r-1:r,c:c+1)=ones(2,2,1);
    %             else
    %                 MaskTrack.RightLane(r-1:r,c-1:c)=ones(2,2,1);
    %             end
    %         else
    %             MaskTrack.RightLane = zeros(8,8,1);
    %         end
    %     else
    %         MaskTrack.RightLane = zeros(8,8,1);
    %     end
    %     %MaskTrack.RightLane(r:r+shiftr,c:c+shiftc)=ones(2,2,1);
    % end
end