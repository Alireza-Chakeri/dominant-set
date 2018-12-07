function  [DS, Partition, compact] = TabuSetDS(A, numcluster,method)

%%%%	Inputs: -A 				Similarity matrix of the graph of size [nxn]
%%%%			-numcluster		Number of desired clusters
%%%%			-method			'jumpcut' or 'average'	or 'peeling-off'		
%%%% 	Outputs: -DS			Clusters of the graph of size [n x numcluster]
%%%%			 -Partition		Partitions of the graph of size [1xn]
%%%%			 -compact		Compactness of the clusters of size [1xnumcluster]	

n = size(A,1);  
S = 1 : n;
toll = 1e-6;

DS = zeros(n,numcluster);
T = [];
for i = 1 : numcluster
	W = setdiff(S,T);                       %%%%% working set (S\T)
	Adj = A(W,W);
	y = enumDS(Adj);
	x = zeros(n,1);
	x(W) = y;
	
	%%%%%%%%%%checking that the obtained Nash is the Nash of whole graph
	payoff = A * x;
	compact(i) = x' * payoff;
	check = find (payoff > compact(i) + toll);
	
	if ~isempty(check)     %%% if it is not a Nash, use x as the initial point and start the dynamics again
		DS(:,i) = enumDS(A,x');
		payoff = A * DS(:,i);
		compact(i) = DS(:,i)' * A * DS(:,i);
	else
		DS(:,i) = x;
	end
	%%%%%%%%%%%%%%%%%%% methods to add vertices to Tabu set in hope of
	%%%%%%%%%%%%%%%%%%% finding well distributed clusters
	if strcmp(method,'average') 
		average = mean(payoff);
		t = find(payoff > average);    %%%%%% vertices that will be added to the Tabu set
	elseif strcmp(method,'jumpcut')
		[t,v_bin] = JumpCut(payoff);	%%%%% vertices that will be added to the Tabu set
	elseif strcmp(method,'peeling-off')
		t = find(x);
	end
	T = union(T,t);                           %%%%% Tabu set until this step
	
end    

%%%%%%%%%%%% Cluster Assignments
Z = [];
for j = 1 : numcluster
	z = find(DS(:,j));
	Z = union(Z,z);
end
Z_hat = setdiff(S,Z);

for j = Z' %%% for vertices in the support of the clusters
	Partition(j) = find(DS(j,:) == max(DS(j,:)),1);
end

for j = Z_hat %%% for vertices outside the support of all clusters
	relative = (A(j,:) * DS)./compact;
	[m Partition(j)] = max(relative);
end

end

