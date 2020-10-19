%% Par it?ration de politique
tic;
FixedNodes=[10,11,5]; % cases dont la politique est fixe et nulle

% initialisation arbitraire de la politique
Politique = ones(nbr,1);
Politique(FixedNodes) = 0;

% affichage de la politique initiale
AffichePolitique(Politique,Plan,Map_plan2node),title('Politique initiale');

% valeur d'escompte
escompte = 1;
NbrIterationMax=7;    
% structure pour stocker les r?sultats de chaque action
CasesPossibles = cell(1,length(A)); 

% vecteur pour stocker le gain d'utilit? associ? ? chaque action
GainU = zeros(1,length(A));
U = zeros(nbr,1);
R= -reshape(R,[RowMax*ColMax,1]);
R(FixedNodes) = -R(FixedNodes);

% mise-?-jour it?rative de la politique
%######## A CODER ##########%
for j= 1:NbrIterationMax
     % Pendant chaque iteration, on 
     %1-Construit la matrice M 
    %2-on determine toute les deplacments possibles selon les
    %particularités de la case
    %3-on calcul le gain de la case
    %on calcul l'utilité 
    
    M = zeros(size(U,1), size(U,1));  %on initialize la matrice M( 12*12) 
   
    [m,n]=size(M);
    
    
    for ii = 1:m          %Construction de la matrice M
      
        for jj = 1:n
          
            if (Politique(ii,end) ~=0)
            
                if ii==jj
                M(ii,jj)= T(ii,Politique(ii,end),jj)-1;
            else
                M(ii,jj)=T(ii,Politique(ii,end),jj);
            end
           else
               M(ii,ii) = 1;
           end
        end            
    end
    
    %Resolution du systeme d'equations lineaire 
    U = M\R;
   
    AfficheUtilites(reshape(U,RowMax,ColMax),Map_plan2node,j),pause(0.0001);
   
    
    for i = 1:m
         
        if isempty(find(i == FixedNodes))
             
            
            [RowPos,ColPos] = find(Map_plan2node==i); % position de la case dans la grille        
       
            
            % gestion des cases en bordure de la grille
      
            ligneHaut = -1; ligneBas = 1;colGauche = -1; colDroite = 1;
       
            if RowPos == 1 ;
            ligneHaut = 0; % pas de voisin au dessus
            end
            
            if RowPos == RowMax;
            ligneBas = 0;  % pas de voisin en dessous
            end
            
            if ColPos == 1;
            colGauche = 0;  % pas de voisin ? gauche
            end
            
            if ColPos == ColMax
            colDroite = 0; % pas de voisin ? droite
            end
        
        % On determine les voisin pour chaque cas 
        CasesPossibles{1} = Map_plan2node(RowPos+ligneHaut,ColPos); % cas du Nord
     
        CasesPossibles{2} = Map_plan2node(RowPos,ColPos+colGauche); % cas du West
        
        CasesPossibles{3} = Map_plan2node(RowPos+ligneBas,ColPos);  % Cas du Sud
        
        CasesPossibles{4} = Map_plan2node(RowPos,ColPos+colDroite); % Cas du Est
       
        
        for o = 1:4   %on parcours les cases possibles 
          if CasesPossibles{o} == 5 
              
              CasesPossibles{o} = i;  %si l'un des des voisins est 5, on change pas de case
       
          end
        end
            
            
      GainU(1) = forward*U(CasesPossibles{1}) + left*U(CasesPossibles{2}) + back*U(CasesPossibles{3}) + right*U(CasesPossibles{4});
     
      GainU(2) = forward*U(CasesPossibles{2}) + left*U(CasesPossibles{3}) + back*U(CasesPossibles{4}) + right*U(CasesPossibles{1});
      
      GainU(3) = forward*U(CasesPossibles{3}) + left*U(CasesPossibles{4}) + back*U(CasesPossibles{1}) + right*U(CasesPossibles{2});
      
      GainU(4) = forward*U(CasesPossibles{4}) + left*U(CasesPossibles{1}) + back*U(CasesPossibles{2}) + right*U(CasesPossibles{3});
      %on Determine l'utilité pour toute les combinaisons possibles 
      
      [MAX,INDEX] = max(GainU);
      Politique(i,j+1) = INDEX;  %politique optimale    
          end
    end 
    
     AffichePolitique(Politique(:,end),Plan,Map_plan2node), title(['Politique temporaire : itération',num2str(j)]), pause(0.0001);
end

toc;