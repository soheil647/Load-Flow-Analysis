
basemva = 100;  accuracy = 0.001; accel = 1.2; maxiter = 100;

lfybus                            % form the bus admittance matrix
Ybus
tic
lfgauss                % Load flow solution by Gauss-Seidel method
toc
busout              % Prints the power flow solution on the screen
lineflow          % Computes and displays the line flow and losses