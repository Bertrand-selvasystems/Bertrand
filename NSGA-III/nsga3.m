% 
% Copyright (c) 2016, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
% 
% Project Code: YPEA126
% Project Title: Non-dominated Sorting Genetic Algorithm III (NSGA-III)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Implemented by: Mostapha Kalami Heris, PhD (member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, NSGA-III: Non-dominated Sorting Genetic Algorithm, the Third Version — MATLAB Implementation (URL: https://yarpiz.com/456/ypea126-nsga3), Yarpiz, 2016.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
% 
% Base Reference Paper:
% K. Deb and H. Jain, "An Evolutionary Many-Objective Optimization Algorithm 
% Using Reference-Point-Based Nondominated Sorting Approach, Part I: Solving
% Problems With Box Constraints, "
% in IEEE Transactions on Evolutionary Computation, 
% vol. 18, no. 4, pp. 577-601, Aug. 2014.
% 
% Reference Paper URL: http://doi.org/10.1109/TEVC.2013.2281535
% 

clc;
clear;
close all;
delete(gcp('nocreate')) 
parpool('local', 16);

%% Problem Definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   DEFINITION DU PROBLEME POUR NSGA 3


CostFunction = @(x) surface_oreille(x);  % Cost Function

nVar = 10;    % Number of Decision Variables

VarSize = [1 nVar]; % Size of Decision Variables Matrix

VarMin = -[0.01 0.01 0.01 0.01 0.1 0.1 0.1 1 1 10];
VarMax = [0.01 0.01 0.01 0.01 0.1 0.1 0.1 1 1 10];

% Number of Objective Functions
nObj = numel(CostFunction(unifrnd(VarMin, VarMax)));


%% NSGA-II Parameters

% Generating Reference Points
nDivision = 10;
Zr = GenerateReferencePoints(nObj, nDivision);

MaxIt = 1000;  % Maximum Number of Iterations

nPop = 250;  % Population Size

pCrossover = 0.7;       % Crossover Percentage
nCrossover = 2*round(pCrossover*nPop/2); % Number of Parnets (Offsprings)

pMutation = 0.3;       % Mutation Percentage
nMutation = round(pMutation*nPop);  % Number of Mutants

mu = 0.02;     % Mutation Rate

sigma = 0.1*(VarMax-VarMin); % Mutation Step Size


%% Colect Parameters

params.nPop = nPop;
params.Zr = Zr;
params.nZr = size(Zr, 2);
params.zmin = [];
params.zmax = [];
params.smin = [];

%% Initialization

disp('Staring NSGA-III ...');

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.NormalizedCost = [];
empty_individual.AssociatedRef = [];
empty_individual.DistanceToAssociatedRef = [];

pop = repmat(empty_individual, nPop, 1);
parfor i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
end

% Sort Population and Perform Selection
[pop, F, params] = SortAndSelectPopulation(pop, params);


%% NSGA-II Main Loop

for it = 1:MaxIt
 
    % Crossover
    popc = repmat(empty_individual, nCrossover/2, 2);
    for k = 1:nCrossover/2

        i1 = randi([1 nPop]);
        p1 = pop(i1);

        i2 = randi([1 nPop]);
        p2 = pop(i2);

        [popc(k, 1).Position, popc(k, 2).Position] = Crossover(p1.Position, p2.Position);

        popc(k, 1).Cost = CostFunction(popc(k, 1).Position);
        popc(k, 2).Cost = CostFunction(popc(k, 2).Position);

    end
    popc = popc(:);

    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    for k = 1:nMutation

        i = randi([1 nPop]);
        p = pop(i);

        popm(k).Position = Mutate(p.Position, mu, sigma);

        popm(k).Cost = CostFunction(popm(k).Position);

    end

    % Merge
    pop = [pop
           popc
           popm]; %#ok
    
    % Sort Population and Perform Selection
    [pop, F, params] = SortAndSelectPopulation(pop, params);
    
    % Store F1
    F1 = pop(F{1});

    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);

    % Plot F1 Costs
    figure(1);
    PlotCosts(F1);
    pause(0.01);
 
end

%% Results

disp(['Final Iteration: Number of F1 Members = ' num2str(numel(F1))]);
disp('Optimization Terminated.');
delete(gcp('nocreate'))

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                   AFFICHAGE DES DIFFERENTS GRAPHIQUES
% 
% 
% % Tracer la surface
% figure;subplot(2, 2, 1);
% surf(X, Y, Z);
% title('Surface');
% hold on;
% % Plot des vecteurs normals en utilisant quiver3
% quiver3(X, Y, Z, NORMALS_SURFACE(:,:,1), NORMALS_SURFACE(:,:,2), NORMALS_SURFACE(:,:,3), 0.5);
% % Mettez en surbrillance le point cible A
% scatter3(xa, ya, za, 'r', 'filled');
% axis equal
% 
% % Tracer la surface
% subplot(2, 2, 2);
% surf(X, Y, Z);
% title('reflexion');
% hold on;
% % Plot des vecteurs normals en utilisant quiver3
% quiver3(X, Y, Z, REFLEXION_SURFACE(:,:,1), REFLEXION_SURFACE(:,:,2), REFLEXION_SURFACE(:,:,3), 0.5);
% % Mettez en surbrillance le point cible A
% scatter3(xa, ya, za, 'r', 'filled');
% axis equal
% 
% % Tracer la surface
% subplot(2, 2, 3);
% surf(X, Y, Z);
% title('Uma');
% hold on;
% % Plot des vecteurs normals en utilisant quiver3
% quiver3(X, Y, Z, UMA(:,:,1), UMA(:,:,2), UMA(:,:,3), 0.5);
% % Mettez en surbrillance le point cible A
% scatter3(xa, ya, za, 'r', 'filled');
% axis equal
% 
% % Tracer la surface
% subplot(2, 2, 4);
% surf(X, Y, DS);
% title('ds');
% hold on;
% scatter3(xa, ya, za, 'r', 'filled');
% axis equal
% 
% figure;
% surf(X, Y, CRITERE);
% title('critere');
% 
% figure;
% surf(X, Y, ALPHAij);
% title('alpha');
% 
% figure;
% surf(X, Y, COMPTEUR);
% title('COMPTEUR');
% 
% 
