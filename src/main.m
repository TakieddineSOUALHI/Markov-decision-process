clear all, close all, clc,

%% Creation du scenario

% dimensions de la grille
RowMax = 3; % nombre de lignes
ColMax = 4; % nombre de colonnes
nbr = RowMax*ColMax; % nombre de cases/noeuds

% création de la grille
Plan = ones(RowMax,ColMax);

% association d'un numéro à chaque case
Map_plan2node = reshape((1:nbr),RowMax,ColMax);

% positionnement des obstacles
Plan(2,2) = -1;

% affichage de la grille
figure(1), imagesc(Plan), colormap gray, colorbar, axis square, grid on, title('Scène');


%% Définition des récompenses

R = -0.04*ones(RowMax,ColMax); % cases standards
R(1,4) = 1; % case objectif
R(2,4) = -1; % cas à éviter

% affichage des récompenses
AfficheRecompences(R,Map_plan2node);


%% Définition de la fonction de transition d'état

% définition des actions possible
N = 1; W = 2; S = 3; E = 4;
A = [N,W,S,E];

% probabilité de résultat à chaque action
forward = 0.8; right = 0.1 ; left = 0.1; back = 0;

% fonction de transition d'état
T = zeros(nbr,length(A),nbr); % T(s,a,s') initilisée à 0

for i=1:nbr % for chaque case
    
    [RowPos,ColPos] = find(Map_plan2node==i); % position de la case dans la grille
    
    if Plan(RowPos,ColPos)==1  % si la case n'est pas un obstacle
        
        % gestion des cases en bordure de la grille
        ligneHaut = -1; ligneBas = 1;colGauche = -1; colDroite = 1;
        if RowPos == 1 ;
            ligneHaut = 0; % pas de voisin au dessus
        end
        if RowPos == RowMax;
            ligneBas = 0;  % pas de voisin en dessous
        end
        if ColPos == 1;
            colGauche = 0;  % pas de voisin à gauche
        end
        if ColPos == ColMax
            colDroite = 0; % pas de voisin à droite
        end
        
        % détermination des numéros des voisins
        Voisins(1) = Map_plan2node(RowPos+ligneHaut,ColPos); % N
        Voisins(2) = Map_plan2node(RowPos,ColPos+colGauche); % W
        Voisins(3) = Map_plan2node(RowPos+ligneBas,ColPos);  % S
        Voisins(4) = Map_plan2node(RowPos,ColPos+colDroite); % E
        
        % recherche d'obstacle dans les voisins
        DirObst=find(Plan(Voisins)==-1); % voisins qui sont des obstacles
        Voisins(DirObst)=i;  % le robot ne bouge pas s'il se heurte à un obstacle
        
        % probabilités des résultats des actions
        % action : N
        T(i,A(1),Voisins(1)) = T(i,A(1),Voisins(1))+forward;
        T(i,A(1),Voisins(2)) = T(i,A(1),Voisins(2))+left;
        T(i,A(1),Voisins(3)) = T(i,A(1),Voisins(3))+back;
        T(i,A(1),Voisins(4)) = T(i,A(1),Voisins(4))+right;
        % action : W
        T(i,A(2),Voisins(1)) = T(i,A(2),Voisins(1))+left;
        T(i,A(2),Voisins(2)) = T(i,A(2),Voisins(2))+forward;
        T(i,A(2),Voisins(3)) = T(i,A(2),Voisins(3))+right;
        T(i,A(2),Voisins(4)) = T(i,A(2),Voisins(4))+back;
        % action : S
        T(i,A(3),Voisins(1)) = T(i,A(3),Voisins(1))+back;
        T(i,A(3),Voisins(2)) = T(i,A(3),Voisins(2))+right;
        T(i,A(3),Voisins(3)) = T(i,A(3),Voisins(3))+forward;
        T(i,A(3),Voisins(4)) = T(i,A(3),Voisins(4))+left;
        % action : E
        T(i,A(4),Voisins(1)) = T(i,A(4),Voisins(1))+right;
        T(i,A(4),Voisins(2)) = T(i,A(4),Voisins(2))+back;
        T(i,A(4),Voisins(3)) = T(i,A(4),Voisins(3))+left;
        T(i,A(4),Voisins(4)) = T(i,A(4),Voisins(4))+forward;
        
    elseif Plan(RowPos,ColPos)==0 % si la case est un objectif
        T(i,A,:)=0;
    else  % si la case est un obstacle
        T(i,A,:)=0;
    end
end
