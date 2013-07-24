
% test data , must test all possiable situtations
LadarRange=[1 1 1 2 2 2 0 0 0 .3 .3 .3 0 .9 .9 .9]
LadarRange=[0 1 1 2 2 2 0 0 0 .3 .3 .3 0 .9 .9 0]
LadarRange=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
LadarRange=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]
LadarRange=[1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
LadarRange=[0 0 0 0 0 0 0 0 0.3 0 0 0 0 0 0 0 0 0 0]
rangemax=0
thd=0.5 % threshold


offset=(LadarRange>0)*thd % add offset when is not zero

%abs(diff(LadarRange))>thd % the edge without offset

edge=abs(diff(LadarRange+offset))>thd % the edge with offset
edge_loc=[1 find(edge) find(edge)+1 length(LadarRange)] % add first and last , left edge , right edge
edge_loc=sort(edge_loc)
% edge check , remove the none obstacle edge

%
zero_loc=find(LadarRange(edge_loc)==rangemax) % find the range data is 0
zero_loc=sort(zero_loc,'descend')
if (~isempty(zero_loc))
    for i=1:length(zero_loc)
        edge_loc(zero_loc(i))=[]; % remove them
    end
end
edge_loc=reshape(edge_loc,2,length(edge_loc)/2) % convert 1xK array to 2xK/2 array left edge first row , right edge second row

left_edge=edge_loc(1,:)
right_edge=edge_loc(2,:)

% plot it
figure,plot(LadarRange), hold on ,plot(left_edge,LadarRange(left_edge),'R*'),plot(right_edge,LadarRange(right_edge),'G*'),hold off ,


% 

