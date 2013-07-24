a=[1 1 1 1 2 2 2 2 1 1 1 1 0 0 0 0.5 0.5 0.5 1.4 1.4 1.4]
% diff(a)
% find(abs(a)>0)
find(abs(diff(a))>0.5)
% edge=and
% edge=ans

% a(edge(2)+1)
% find(abs(diff(a))>=0.5)
a2=find(abs(diff(a))>=0.5)
a2
a3=a2+1
a4=[a2 a3]
a(a4(:))
% find(a(a4(:))==0)
% a4(find(a(a4(:))==0))=[]
a4(find(a(a4(:))==0))=[],a5=sort(a4)
edge=a5
if(a(1)>0) , edge=[1 edge]
end
if(a(length(a))>0) , edge=[edge length(a)],end