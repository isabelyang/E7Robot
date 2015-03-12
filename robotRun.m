function [ W, L, T ] = robotRun( n )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here

W = 0;
L = 0;
T = 0;

for i = 1:n
    [winner, err, errstr] = battle2014_v4(@Belodong, @theMatrixReloaded, 'asym', 0, 2);
    if winner == 1
        W = W + 1;
    elseif winner == 2
        L = L + 1;
    else
        T = T + 1;
    end
end
    
end


