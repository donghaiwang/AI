%%
clear;clc;close all;

%% Find number of logical cores assigned by the OS
ncores = feature('numCores');

%% Find the number of logical real cpus
import java.lang.*;
r = Runtime.getRuntime;
ncpus = r.availableProcessors;

%%
r.freeMemory;
r.maxMemory;


%%
computer