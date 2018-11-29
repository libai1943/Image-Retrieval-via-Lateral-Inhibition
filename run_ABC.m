function [CB,abc] = run_ABC(NP,runtime,maxTime)
% The evolutionary algorithm adopted in this study, namely, ABC.
global test
global template

[m,n] = size(test);
[a,b] = size(template);

D = 2; % Problem dimensional...
FoodNumber = NP/2; 
Limit = 50*NP*D; % Threshold for re-initialization.

maxCycle = 9999;
abc = zeros(runtime,maxCycle);


for r = 1 : runtime
    tic
    ObjVal = zeros(FoodNumber,1);
    Fitness = zeros(FoodNumber,1);
    trial = zeros(1,FoodNumber);
    
    ub = [m-a, n-b];
    lb = [1, 1];
    Range = repmat((ub-lb),[FoodNumber 1]);
    Lower = repmat(lb, [FoodNumber 1]);
    Foods = rand(FoodNumber,D) .* Range + Lower;

    for ii = 1 : FoodNumber
        ObjVal(ii,1) = obj(Foods(ii,:));
        Fitness(ii,1) = calculateFitness(ObjVal(ii,1));
    end

    BestInd = find(ObjVal==max(ObjVal));
    BestInd = BestInd(end);
    GlobalMin = ObjVal(BestInd,1);
    
    iter = 1;
    while ((iter <= maxCycle)),
        for i = 1 : FoodNumber
                Param2Change = fix(rand*D)+1;
                neighbour = fix(rand*(FoodNumber))+1;
                while(neighbour==i)
                    neighbour=fix(rand*(FoodNumber))+1;
                end;
                sol=Foods(i,:);
                sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
                ind=find(sol<lb);
                sol(ind)=lb(ind);
                ind=find(sol>ub);
                sol(ind)=ub(ind);
                ObjValSol = obj(sol);
                FitnessSol = calculateFitness(ObjValSol);
                if (FitnessSol < Fitness(i))
                    Foods(i,:)=sol;
                    Fitness(i)=FitnessSol;
                    ObjVal(i)=ObjValSol;
                    trial(i) = 0;
                else
                    trial(i) = trial(i) + 1;
                end;     
        end;


        prob = 0.9.*Fitness./max(Fitness) + 0.1;
        i=1;
        t=0;
        for t = 1 : FoodNumber
            if(rand < prob(i))
                Param2Change=fix(rand*D)+1;
                neighbour=fix(rand*(FoodNumber))+1; 
                while(neighbour==i)
                    neighbour=fix(rand*(FoodNumber))+1;
                end; 
                sol=Foods(i,:);
                sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
                ind=find(sol<lb);
                sol(ind)=lb(ind);
                ind=find(sol>ub);
                sol(ind)=ub(ind);
                ObjValSol = obj(sol);
                FitnessSol = calculateFitness(ObjValSol);

                if (FitnessSol < Fitness(i)) 
                    Foods(i,:)=sol;
                    Fitness(i)=FitnessSol;
                    ObjVal(i)=ObjValSol;
                    trial(i) = 0;
                else
                    trial(i) = trial(i) + 1; 
                end;
            end;
            i=i+1;
            if (i==(FoodNumber)+1) 
                i=1;
            end;  
        end;
        ind = find(ObjVal == max(ObjVal));
        ind = ind(end);
        if (ObjVal(ind) > GlobalMin)
            GlobalMin = ObjVal(ind);
            GlobalParams = Foods(ind,:);
        end;
        
        ind = find(trial == max(trial));
        ind = ind(end);
        if (trial(ind) > Limit)
            trial(ind) = 0;
            sol=(ub-lb).*rand(1,D)+lb;
            ObjValSol = obj(sol);
            FitnessSol = calculateFitness(ObjValSol);
            Foods(ind,:)=sol;
            Fitness(ind)=FitnessSol;
            ObjVal(ind)=ObjValSol;
        end;

        abc(r, iter) = GlobalMin;
        iter = iter+1;
        if (toc >= maxTime)
            iter = maxCycle + 1;
        end
    end % End of ABC
    CB(r,:) = GlobalParams;
end; %end of runs
save ABC_backup