Vm=0; delta=0; yload=0; deltad =0;
nbus = length(busdata(:,1));
for k=1:nbus
n=busdata(k,1);
kb(n)=busdata(k,2); Vm(n)=busdata(k,3); delta(n)=busdata(k, 4);
Pd(n)=busdata(k,5); Qd(n)=busdata(k,6); Pg(n)=busdata(k,7); Qg(n) = busdata(k,8);
Qmin(n)=busdata(k, 9); Qmax(n)=busdata(k, 10);
Qsh(n)=busdata(k, 11);
    if Vm(n) <= 0  Vm(n) = 1.0; V(n) = 1 + j*0;
    else delta(n) = pi/180*delta(n);
         V(n) = Vm(n)*(cos(delta(n)) + j*sin(delta(n)));
         P(n)=(Pg(n)-Pd(n))/basemva;
         Q(n)=(Qg(n)-Qd(n)+ Qsh(n))/basemva;
         S(n) = P(n) + j*Q(n);
    end
DV(n)=0;
end
num = 0; AcurBus = 0; converge = 1;
Vc = zeros(nbus,1)+j*zeros(nbus,1); Sc = zeros(nbus,1)+j*zeros(nbus,1);

while exist('accel')~=1
   accel = 1.3;
end
while exist('accuracy')~=1
   accuracy = 0.001;
end
while exist('basemva')~=1
   basemva= 100;
end
while exist('maxiter')~=1
   maxiter = 100;
end
iter=0;
maxerror=10;
while maxerror >= accuracy & iter <= maxiter
iter=iter+1;
  for n = 1:nbus;
  YV = 0+j*0;
    for L = 1:nbr;
            if nl(L) == n, k=nr(L);
            YV = YV + Ybus(n,k)*V(k);
            elseif nr(L) == n, k=nl(L);
            YV = YV + Ybus(n,k)*V(k);
            end
    end
       Sc = conj(V(n))*(Ybus(n,n)*V(n) + YV) ;
       Sc = conj(Sc);
       DP(n) = P(n) - real(Sc);
       DQ(n) = Q(n) - imag(Sc);
         if kb(n) == 1
         S(n) =Sc; P(n) = real(Sc); Q(n) = imag(Sc); DP(n) =0; DQ(n)=0;
         Vc(n) = V(n);
         elseif kb(n) == 2
         Q(n) = imag(Sc); S(n) = P(n) + j*Q(n);

           if Qmax(n) ~= 0
             Qgc = Q(n)*basemva + Qd(n) - Qsh(n);
             if abs(DQ(n)) <= .005 & iter >= 10 % After 10 iterations
               if DV(n) <= 0.045                % the Mvar of generator buses are
                  if Qgc < Qmin(n),             % tested. If not within limits Vm(n)
                  Vm(n) = Vm(n) + 0.005;        % is changed in steps of 0.005 pu
                  DV(n) = DV(n)+.005;           % up to .05  pu in order to bring
                  elseif Qgc > Qmax(n),         % the generator Mvar within the
                  Vm(n) = Vm(n) - 0.005;        % specified limits.
                  DV(n)=DV(n)+.005; end
               else, end
             else,end
           else,end
         end
       if kb(n) ~= 1
       Vc(n) = (conj(S(n))/conj(V(n)) - YV )/ Ybus(n,n);
       else, end
          if kb(n) == 0
          V(n) = V(n) + accel*(Vc(n)-V(n));
          elseif kb(n) == 2
          VcI = imag(Vc(n));
          VcR = sqrt(Vm(n)^2 - VcI^2);
          Vc(n) = VcR + j*VcI;
           V(n) = V(n) + accel*(Vc(n) -V(n));
          end
   end
  maxerror=max( max(abs(real(DP))), max(abs(imag(DQ))) );
   if iter == maxiter & maxerror > accuracy
   fprintf('\nWARNING: Iterative solution did not converged after ')
   fprintf('%g', iter), fprintf(' iterations.\n\n')
   fprintf('Press Enter to terminate the iterations and print the results \n')
   converge = 0; pause, else, end
   
end
if converge ~= 1
   tech= ('                      ITERATIVE SOLUTION DID NOT CONVERGE'); else, 
   tech=('                   Power Flow Solution by Gauss-Seidel Method');
end   
k=0;
for n = 1:nbus
  Vm(n) = abs(V(n)); deltad(n) = angle(V(n))*180/pi;
     if kb(n) == 1
     S(n)=P(n)+j*Q(n);
     Pg(n) = P(n)*basemva + Pd(n);
     Qg(n) = Q(n)*basemva + Qd(n) - Qsh(n);
     k=k+1;
     Pgg(k)=Pg(n);
     elseif  kb(n) ==2
     k=k+1;
     Pgg(k)=Pg(n);
     S(n)=P(n)+j*Q(n);
     Qg(n) = Q(n)*basemva + Qd(n) - Qsh(n);
     end
yload(n) = (Pd(n)- j*Qd(n)+j*Qsh(n))/(basemva*Vm(n)^2);
end
Pgt = sum(Pg);  Qgt = sum(Qg); Pdt = sum(Pd); Qdt = sum(Qd); Qsht = sum(Qsh);
busdata(:,3)=Vm'; busdata(:,4)=deltad';
clear  AcurBus  DP  DQ  DV  L Sc Vc VcI VcR YV converge delta