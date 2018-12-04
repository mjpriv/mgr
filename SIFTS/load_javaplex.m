% This script prepares the javaPlex library for use
% You need to change the javaPlex directory marked by "To do" below.

clc; clear all; close all;
clear import;

% To do: Replace the path with your directory of javaPlex
cwd = cd('~/work/tools/javaPlex/matlab_examples');

javaaddpath('./lib/javaplex.jar');
import edu.stanford.math.plex4.*;

javaaddpath('./lib/plex-viewer.jar');
import edu.stanford.math.plex_viewer.*;

cd './utility';
addpath(pwd);

cd(cwd);
