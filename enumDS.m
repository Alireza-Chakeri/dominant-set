function y = enumDS(A,toll)

%%% inputs: -A          Similarity matrix of the graph
%%% outputs: -y         A cluster

if ~exist('toll','var')
    toll = 1e-6;
end
n = size(A,1);
x = rand(n,1) + 1000;
x = x/sum(x);
y = inImDynC(A,x,toll); %%% InImDyn dynamics (refer to the paper "S.R. Bulo, I. M. Bomze, Infection and immunization: a new class of evolutionary game dynamics" for implementation)
end