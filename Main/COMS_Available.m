function [coms]=COMS_Available ()
try
    com='COM99';
    s=serial(com);
    fopen(s);
catch me
    fclose(s);
    delete(s)
    clear s
    
    x=1+1;
    
    chars=length(me.message);
    count=1;
    
    for i=1:chars
       if isempty(str2num(me.message(i)))
           isnum(i)=0;
       else
           isnum(i)=1;
       end
    end
    coms=char();
    for i=1:chars-3
        if me.message(i:2+i)=='COM'
            if isnum(i+4)==0
                if me.message(i:3+i)=='COM1'
                else
                    coms(count,1:4)=me.message(1,i:i+3);
                    count=count+1;
                end
            elseif isnum(i+4)==1
                if me.message(i:4+i)==com
                else
                    coms(count,1:5)=me.message(1,i:i+4);
                    count=count+1;
                end
            end
        end
    end
    if count-1==0
        disp('No available COM ports');
    end
end