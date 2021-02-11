
basemva = 100;  accuracy = 0.001; maxiter = 50;

lfybus                             % form the bus admittance matrix
Ybus
tic
decouple1              % Load flow solution by fast decoupled method
toc
busout               % Prints the power flow solution on the screen
lineflow           % Computes and displays the line flow and losses
