function [t,v_bin] = JumpCut(v)
%JUMPCUT Summary of this function goes here
%   Detailed explanation goes here

[v_sort,ind_sort] = sort(v,1,'descend');
max = v_sort(1) - v_sort(2);
index = 1;
for i = 2:size(v)-1
    a = v_sort(i) - v_sort(i+1);
    if a > max
        max = a;
        index = i;
    end
end
t = ind_sort(1:index);
v_bin = zeros(size(v),1);
v_bin(t,1) = 1;
end

