
basemva = 100;  accuracy = 0.001; maxiter = 10;

lfybus                            % form the bus admittance matrix
Ybus
tic
lfnewton             % Load flow solution by Newton-Raphson method 
toc
busout % Prints the power flow solution on the screen
lineflow          % computes and displays the line flow and losses
