function intervals = SIF(D, max_dimension, max_filtration_value, num_divisions)
% intervals = SIF(D, max_dimension, max_filtration_value, num_divisions)
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
%		See javaPlex documentation for details.
%
% Be sure to run load_javaplex first.

import edu.stanford.math.plex4.*;

% create a Vietoris-Rips stream
m_space = metric.impl.ExplicitMetricSpace(D);
stream = api.Plex4.createVietorisRipsStream(m_space, max_dimension, max_filtration_value, num_divisions);
stream.finalizeStream();
fprintf('SIF: Rips complex size=%d\n',stream.getSize());

% get persistence algorithm over Z/2Z
persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);

% compute the persistent intervals
intervals = persistence.computeAnnotatedIntervals(stream)

% create the barcode plots
options.filename = 'SIF';
options.max_filtration_value = max_filtration_value;
options.max_dimension = max_dimension - 1;
plot_barcodes(intervals, options);

% To extract the 1-homology barcodes from time skeleton semantic filtration, do
% endpoints = homology.barcodes.BarcodeUtility.getEndpoints(intervals, 1, true)
