% This example code computes SIF and SIFTS bar-codes as in Figure 1 in the paper
%    Xiaojin Zhu.
%    Persistent homology: An introduction and a new text representation for natural language processing.
%    In The 23rd International Joint Conference on Artificial Intelligence (IJCAI),
%    2013.
%
% You need to first download and install javaPlex (http://code.google.com/p/javaplex/).

load_javaplex

% Choose one of the data sets
bow = load('data/spider.bow'); 
%bow = load('data/rowyourboat.bow'); 
%bow = load('data/londonbridge.bow'); 

% Each Bag-of-Words is for a line
% Compute the Euclidean distance between the BOWs
n=size(bow,1);
K=bow*bow';
D = sqrt(repmat(diag(K),1,n) - 2*K + repmat(diag(K)',n,1))

% common Vietoris-Rips complex parameters
max_dimension = 2;
max_filtration_value = max(max(D)); 
num_divisions = 100;

close all

% SIF
intervals_SIF = SIF(D, max_dimension, max_filtration_value, num_divisions)

% SIFTS
intervals_SIFTS = SIFTS(D, max_dimension, max_filtration_value, num_divisions)
