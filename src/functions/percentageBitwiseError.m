function [ errorPercentage ] = percentageBitwiseError( recovered, original )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    totalBits=8*length(recovered);
    %length(sprintf('\n')) == 1
    l=length(original);
    iterations= floor((length(recovered)/l));
    
    error=0;
    substr='';
    for i=1:iterations
        substr=recovered((i-1)*l+1:i*l);
        error=error+stringsError(original,substr);
    end
    errorPercentage=(error/totalBits)*100;
end

