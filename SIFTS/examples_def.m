% This example code computes SIF and SIFTS bar-codes as in Figure 1 in the paper
%    Xiaojin Zhu.
%    Persistent homology: An introduction and a new text representation for natural language processing.
%    In The 23rd International Joint Conference on Artificial Intelligence (IJCAI),
%    2013.
%
% You need to first download and install javaPlex (http://code.google.com/p/javaplex/).

load_javaplex

% Choose one of the data sets
bow = load('data/emperor.bow'); 
%bow = load('data/redcap.bow'); 
%bow = load('data/alice.bow'); 

% convert the BOW vectors into tf.idf
[ndoc, nvoc]=size(bow)
nw = sum(bow>0); % nw = number of documents word w appeared in
idf = log(ndoc ./ nw)
% TFIDF: Xw = log(Cw+1)*idf, where Cw is the count vector
X = log(bow+1).*repmat(idf, ndoc, 1)

% compute the cosine similarity between tf.idf vectors
K = X*X'; % the inner product matrix
normX = sqrt(diag(K));

% There may be all-zero tf.idf doc vector, with norm=0.
% Let's smooth it a bit so that we don't have divide by 0 in cs
idx = find(normX==0); normX(idx)=1e-10;

cs = K ./ repmat(normX, 1, ndoc) ./ repmat(normX', ndoc, 1);
idx = find(cs>1); cs(idx)=1; % handle numerical issues
idx = find(cs<0); cs(idx)=0; % handle numerical issues

% the angular distance arccos() is a distance metric
D = acos(cs);

% common Vietoris-Rips complex parameters
max_dimension = 2;
max_filtration_value = pi/2;
num_divisions = 100;

close all

% SIF
intervals_SIF = SIF(D, max_dimension, max_filtration_value, num_divisions)

% SIFTS
intervals_SIFTS = SIFTS(D, max_dimension, max_filtration_value, num_divisions)
