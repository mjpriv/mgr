function intervals = SIFTS(D, max_dimension, max_filtration_value, num_divisions)
% Compute the Similarity Filtration with Tim Skeleton (SIFTS).
%
% intervals = SIFTS(D, max_dimension, max_filtration_value, num_divisions)
%
% Input
%	D: an n*n symmetric matrix, D_ij = the distance between points i, j
%	max_dimension: 
%		E.g. 2 to get 0-homology (clusters) and 1-homology (holes)
%	max_filtration_value: the largest diameter when constructing the Rips complex.  
%		E.g. max(max(D)), though sometimes the Rips complex is too big.
%	num_divisions:
%		Filtration resolution, e.g. 100.
%
% Output
%	intervals: the birth-death intervals of persistent homology groups.
% 		To extract the 1-homology barcodes from time skeleton semantic filtration, do
%		endpoints = homology.barcodes.BarcodeUtility.getEndpoints(intervals, 1, true)
%		See javaPlex documentation for details.
%
% Note: Be sure to run load_javaplex first.
%
% Created by: Xiaojin Zhu, jerryzhu@cs.wisc.edu.  April 2013.
%
% Citation:
%    Xiaojin Zhu. 
%    Persistent homology: An introduction and a new text representation for natural language processing. 
%    In The 23rd International Joint Conference on Artificial Intelligence (IJCAI), 
%    2013. 

import edu.stanford.math.plex4.*;

% time skeleton
for i=1:size(D,1)-1,
  D(i,i+1)=0;
  D(i+1,i)=0;
end

% create a Vietoris-Rips stream
m_space = metric.impl.ExplicitMetricSpace(D);
stream = api.Plex4.createVietorisRipsStream(m_space, max_dimension, max_filtration_value, num_divisions);
stream.finalizeStream();
fprintf('SIFTS: Rips complex size=%d\n',stream.getSize());

% get persistence algorithm over Z/2Z
persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);

% compute the persistent intervals
intervals = persistence.computeAnnotatedIntervals(stream)

% create the barcode plots
options.filename = 'SIFTS';
options.max_filtration_value = max_filtration_value;
options.max_dimension = max_dimension - 1;
plot_barcodes(intervals, options);

