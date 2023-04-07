function avgvec=newavg(rowdata)
fsize = size(rowdata);
avgvec=zeros(1,(fsize(2)));
for i = 1:1:fsize(1)
    for j = 1:1:fsize(2)
        avgvec(1,j)= rowdata(i,j)+avgvec(1,j);
    end
end
avgvec=avgvec/(fsize(1));
