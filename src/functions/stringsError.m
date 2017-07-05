function [ totalErrors ] = stringsError(string1, string2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
       totalErrors=0;
       l=min(length(string1),length(string2));
       for i=1:l
           totalErrors=totalErrors+charBitsDiff(string1(i),string2(i));
       end

end

