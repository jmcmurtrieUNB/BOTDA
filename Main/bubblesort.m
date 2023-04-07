function [list] = bubblesort(list)
% Sorts the list given using bubble sort algorithm
%   Detailed explanation goes here

%% Parsing the file names to extract time info
[s,~]=size(list); %  number of files in directory

for i=1:s
    FileName=list(i).name;
    NumChar=length(FileName);
    j=0; %counter
    for k=1:NumChar
        if FileName(k:k+7)=='Averages'
           TempNumber=FileName(k+9:end-4);
           break
        end
    end
    
    for k=1:length(TempNumber)
        if TempNumber(k)~='_'
            DateNumber(k)=TempNumber(k);
        end
    end
    DateNumber=str2num(DateNumber);
    list(i).DateNumber=DateNumber;
    clear DateNumber
end


%% Sorting


for k=1:5
    sorted=false;
    while ~sorted
        sorted=true;
        count=0;
        for i=1:length(list)-1
            if list(i).DateNumber(k)>list(i+1).DateNumber(k)
                switch k
                    case 1
                        temp=list(i);
                        list(i)=list(i+1);
                        list(i+1)=temp;
                        sorted=false;
                        count=count+1;
                    otherwise
                        if list(i).DateNumber(k-1)==list(i+1).DateNumber(k-1)
                            temp=list(i);
                            list(i)=list(i+1);
                            list(i+1)=temp;
                            sorted=false;
                            count=count+1;
                        end
                end
            end
        end
    end
end

















