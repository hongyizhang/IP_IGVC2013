function [Binary] = basicIP_noise_mt2(img_out)

    [h, w] = size(img_out);
    M = h; N=w;     
    A=2.2; % used by lowfilter for standard dev. weight
    B = 1.2; % used for mean weighting
    BW=lowfilter(img_out,A,M,N);
    BW2=(medfilt2(BW, [5,5]));
    level=graythresh(BW2);
    Binary=im2bw(BW2,level);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% New Function %%%%%%%%%%%%%%%%%%%%%%%%%%%
function newlight4=lowfilter(imagesansbar0,A,M,N)
%The deletes all the low intensity pixels below the threshold A*std+B*mean.
%By Robert McKeon  
% 
% imagesansbar0 is the gray image input with dimensions M x N. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Low
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[row col] = size(imagesansbar0);
M = row;
N = col-1;
% imagesansbar0=imagesansbar0(:,1:500);
imagesansbar0=imagesansbar0(:,1:N);
imagesansbar01=cast(imagesansbar0,'double');
% N=500;
me21st=(zeros(M,1));
met201(:,:)=(zeros(M,fix(N/2)));
stdt1=(zeros(M,1));
me21st1=(zeros(M,1));
me22nd1=(zeros(M,1));
cutofflevel=(zeros(M,N));


%finds the mean of each row in the left half of the image
me21st(:)=sum(imagesansbar01(:,1:fix(N/2)),2,'native')/(N/2); 

%This re-maps the mean onto the same number of columns so as to be used in
%calculating the std. 
met201(:,:)=repmat(me21st(:), 1, fix(N/2));


%This finds the difference between the pixel value and the mean value
%squared.
stdimage1=(imagesansbar01(:,1:fix(N/2))-(met201)).^2;
stdt1(:)=sqrt(sum((stdimage1),2,'native')/(N/2));

%This sets the cutoff value for each row based on B*mean+A*std
me21st1(:)=B*me21st+A*stdt1;

%finds the mean of the right half of the image
me21st(:)=sum(imagesansbar01(:,fix(N/2)+1:N),2,'native')/(N/2);

%This does the second half of the image
met201(:,:)=repmat(me21st(:), 1, fix(N/2));

%Makes std for right half of the image.
stdimage1=(imagesansbar01(:,fix(N/2)+1:N)-(met201)).^2;
stdt1(:)=sqrt(sum(stdimage1,2,'native')/(N/2));

%Makes the cutoff for the right half of the image
me22nd1(:)=B*me21st+A*stdt1;

%Repmaps the cutoff levels for each half of the image to make the cutoff
%image.
cutofflevel(:,1:fix(N/2))=repmat(me21st1(:), 1, fix(N/2));

cutofflevel(:,fix(N/2)+1:N)=repmat(me22nd1(:), 1, fix(N/2));

newlight4=uint8(imagesansbar0>cutofflevel).*imagesansbar0;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% New Function %%%%%%%%%%%%%%%%%%%%%%%%%%%
function readytothres=threswhist(readytothres,M,b)
%This function determines a threshold by finding how many pixels are left
%after choose a thres based on when there are b*M pixels supposed to be
%left in the image. M is the number of rows and b is the multiplier.
%By Robert McKeon

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Determines a better factor to automatically give values for the range of
%thresholds.
% min(min(readytothres))
% mean(mean(readytothres))

bins=50;
% readytothres1=cast(readytothres,'uint8');
% figure, imshow(readytothres1)
readytothres = bitshift(readytothres,8)-readytothres;

[count nn]=imhist(readytothres,bins);
%See if my own function for histogram that I copied from the imhist file
%works faster.
% [count nn]=imhistspecial(readytothres,bins);

% count1-count
% figure, plot(nn(2:bins,1),count(2:bins,1))
countcs=cumsum(count(2:bins));
% figure, plot(nn(2:bins,1),countcs(bins-1)-countcs)
% countmean=sum(countcs)/(bins-1);
% countstd=(sum((countcs-countmean).^2)/(bins-2)).^0.5;
% threshold=nn(find(countcs>(countmean-countstd),1,'first'));
cutsum0=(countcs(bins-1)-countcs)>b*M;

%This checks to make sure the cumulative sum is not zero.
if cutsum0(1)==0
    counti=countcs(bins-1)-countcs;
    countmean=sum(counti)/(bins-1);
    if counti(1)>150 &countmean>10
        %if the number of pels is greater than 150, this serves as a lower
        %threshold.
        threshold=nn(find(counti>countmean,1,'last')+1);
    else
        threshold=nn(bins);
    end
else
    threshold=nn(find(cutsum0,1,'last')+1);
end    

readytothres=1-(1-(readytothres-threshold));
end
% figure, imshow(readytothres*255)


end