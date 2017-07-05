function [ finalString ] = DecideRepetition( bitString , repetitions )

    finalString=zeros(1,8);

    if not((length(bitString)/repetitions)==8)
         return;
    end
    decision=zeros(1,repetitions);
    for i=1:8
        for j=1:repetitions
            decision(j)=bitString((i-1)*repetitions+j);
        end
        decision=cumsum(decision);
        
        if(decision(repetitions)) >= (repetitions/2)
           finalString(i)=1; 
        else
           finalString(i)=0;
        end    
    end

end

