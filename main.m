clear all
clc
data30
met = input('Enter the method for load flow (1 - GS, 2 - NR, 3 - Decouple): ');
while met ~= 1 && met ~= 2 && met ~= 3
    fprintf('Invalid Input try again\n');
    met = input('Enter the method for load flow (1 - GS, 2 - NR, 3 - Fast Decouple): ');
end
switch met
    case 1
        maingauss
    case 2
        mainnewton
    case 3
        maindecouple
end