function retarray =newpolavg(AVGArray)
sizef = size(AVGArray);
retarray=zeros(((sizef(1))/2), (sizef(2)));

for i = 1:1:((sizef(1))/2)
    for j = 1:1:(sizef(2))
        retarray(i,j)= (AVGArray(i,j)+AVGArray((i+(sizef(1)/2)),j))/2;
    end
end
        