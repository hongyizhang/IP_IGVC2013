
A=diff((LadarRange>0) & (LadarRange<0.5))
A1=find(A==1)
A2=find(A==-1)
A3=A1(find(LadarRange(A1(:))==0))+1 ; % detect the '0' raising edge, then plus 1.
                                      % because raising edge is on the
                                      % falling edge right.
A4=A2(find(LadarRange(A2(:))==0))-1   % detect the '0' falling edge, then minus 1.
                                      % because falling edge is on the
                                      % raising edge left.
                                     
%% detail
if ~isempty(find((LadarRange>0) & (LadarRange<=0.5)))
special_edge=diff((LadarRange>0) & (LadarRange<=0.5));
Raising_edge=find(special_edge==1);
Falling_edge=find(special_edge==-1);
if find(LadarRange(Raising_edge(:))==0)
% special_case3=special_case1(find(LadarRange(special_case1(:))==0))+1;
Raising_edge=Raising_edge+1;
end
if find(LadarRange(Falling_edge(:))==0)
% special_case4=special_case2(find(LadarRange(special_case2(:))==0))-1;
Falling_edge=Falling_edge-1;
end
if isempty(special_case3)==0 && isempty(special_case4)==0
    edge=[special_case3 special_case4 edge];
end

RangeDiff = diff(LadarRange);
edge = find(abs(RangeDiff)>Threshold);
edge =[edge edge+1]; % use falling edge to create raising edge.
find(LadarRange(edge(:))==0);
edge(find(LadarRange(edge(:))==0))=[];
edge=sort(edge);

if(LadarRange(1)>0) 
   edge=[1 edge];
end
if(LadarRange(length(LadarRange))>0)
    edge=[edge length(LadarRange)];
end
