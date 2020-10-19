%% Par it�ration de valeur
tic; 
FixedNodes=[5,10,11]; % cases dont les utilit�s sont fixes durant l'algorithme

% initialisation des utilit�s
[w x]=size(R);
 U = reshape(R,x*w,1) %initialisation de U � R
% U =  [-0.5;-0.5;-0.5;-0.5;-0.5;-0.5;-0.5;-0.5;-0.5;1;-1;-0.5];


% affichage des utilit�s initiales
AfficheUtilites(reshape(U(:,end),RowMax,ColMax),Map_plan2node,0); pause();

% valeur d'escompte
escompte = 1;
%erreur admise
epsilon = 0.000001;
%nmbre d'iteration maximal
NbrIterationMax =150 ;
% structure pour stocker les r�sultats de chaque action
CasesPossibles = cell(1,length(A)); 
% vecteur pour stocker le gain d'utilit� associ� � chaque action
GainU = zeros(1,length(A));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for  j = 1:NbrIterationMax
    % Pendant chaque iteration, on Calcul l'utilit� de la case in 
    %1-on determine si elle est fixe ou non, si non 
    %2-on determine toute les deplacments possibles selon les
    %particularit�s de la case
    %3-on calcul le gain de la case
    %on calcul l'utilit� 
    for i = 1 : 12
        [l,c] = find(Map_plan2node == i);  %on determine tout d'abord la position de l'�tat
        if (i == 5 || i==10 || i==11)
                U(i,j+1) = R(l,c);   %Dans cette partie on met des conditions pour conserver les valeurs des Cases 5,10 et 11  
        else   
            for n = 1 : 4    %Dans cette boucle on determine les cases de deplacement possibles selon les particularit�s de l'�tat
                if n == 1    %Cas Nord
                    if(l == 1)  %si ligne 1 ===> deplacement vers [N W E] 
                          CasesPossibles{n} = [i i+3  i-3];
                    else        %autres lignes ====>deplacement vers [S W E] 
                          CasesPossibles{n} = [i-1 i+3  i-3];
                    end
                end
                if n == 2    %Cas West
                     if(l == 3) %si ligne 1 ===> deplacement vers [N W E]
                          CasesPossibles{n} = [i-1 i-3 i];
                     else       %autres lignes ====>deplacement vers [S W E]
                    CasesPossibles{n} = [i-1 i-3 i+1];
                     end
                end
                if n == 3    %Cas Sud
                     if(l == 3)  %si ligne 3 ===> deplacement vers [N W E]
                          CasesPossibles{n} = [i-3 i  i-3]; 
                     else        %autres lignes ====>deplacement vers [S W E]
                           CasesPossibles{n} = [ i-3 i+1 i+3];
                     end
                end
                if n == 4    %Cas Est
                     if(l == 3)  %si ligne  ===> deplacement vers [N W E]
                          CasesPossibles{n} = [i-1 i i+3];
                     else        %autres lignes ====>deplacement vers [S W E]
                          CasesPossibles{n} = [i-1  i+1 i+3];
                     end
                end
                for m = 1:length(CasesPossibles{n}) %Ici on met une condition que si l'une des cases possibles est un neoud fix,
%                     %ou hors champs  on garde la meme case 
                    if CasesPossibles{n}(m) <= 0 || CasesPossibles{n}(m) > 12 || CasesPossibles{n}(m)== 5 
                        CasesPossibles{n}(m) = i;
                    end
                end
                CasesPossibles{n} = unique(CasesPossibles{n}); %on elemine les cas qui se repete, pour eviter les doublements dans le gain 
                for k = 1:length(CasesPossibles{n})
                    %on �value le gain pour chaque case possible
                        GainU(n) = GainU(n) + U(CasesPossibles{n}(k),j)*T(i,n,CasesPossibles{n}(k));
                end
               
            end
              U(i,j+1) = R(l,c) + escompte * max(GainU)   %Calcul de l'utilit� de la case i
              GainU = zeros(1,length(A)); %remise � zero du gain a zero pour la prochaine case i+1
        end 
    end
    %Affichage des utilit�s
    AfficheUtilites(reshape(U(:,end),RowMax,ColMax),Map_plan2node,j),pause(0.1);
    erreur = immse(U(:,j+1),U(:,j)); %on calcul l'erreur quadratique en utilisant la fonction immse
    
    if(erreur < epsilon)
        break;   %si lerreur quadratique est inferieur a epsilon on quitte la boucle 
    end
    
  

end
 figure; 
 hold on 
 plot(U(9,:),'r');
 plot(U(6,:),'g');
 plot(U(3,:),'b');
 hold off
%###########################%

%prise en compte des derni�res valeurs d'utilit�
Uf = U(:,end);

 Politique = zeros(1,12);
% % recherche de la politique optimale pour chaque case
 for i = 1 :12 
     %la structure de cette partie est presque la meme que  la pr�cedente,
     %ce qui change ici est l'implementation de la formule pour d�terminer
     %l'action optimale pour chaque �tat.
      [l,c] = find(Map_plan2node == i);
          
        % si on on st dans cses FixedNodses, on garde la valeur de la
        % recompense
       
                Politique(FixedNodes) = 0;       % on met a zero la politique des cases 5, 10 et 11
        
        if (i ~=FixedNodes)
            for n = 1 : 4
                if n == 1    
                    if(l == 1)
                          CasesPossibles{n} = [i i+3  i-3];
                    else
                          CasesPossibles{n} = [i-1 i+3  i-3];
                    end
                end
                if n == 2    
                    
                     if(l == 3)
                          CasesPossibles{n} = [i-1 i-3 i];
                     else
                          CasesPossibles{n} = [i-1 i-3 i+1];
                     end
                end
                if n == 3   
                    
                     if(l == 3) 
                          CasesPossibles{n} = [i-3 i  i-3];
                     else
                           CasesPossibles{n} = [ i-3 i+1 i+3];
                     end
                end
                if n == 4  
                    
                     if(l == 3)
                          CasesPossibles{n} = [i-1 i i+3];
                     else
                          CasesPossibles{n} = [i-1  i+1 i+3];
                     end
                end
                for m = 1:length(CasesPossibles{n})
                    if CasesPossibles{n}(m) <= 0 || CasesPossibles{n}(m) > 12 || CasesPossibles{n}(m)== 5 
                        CasesPossibles{n}(m) = i;
                    end
                end
                CasesPossibles{n} = unique(CasesPossibles{n});
                for k = 1:length(CasesPossibles{n})
                        GainU(n) = GainU(n) + Uf(CasesPossibles{n}(k))*T(i,n,CasesPossibles{n}(k));
                end 
            end
            P_opt  =  find(GainU == max(GainU));
                 GainU = zeros(1,length(A));
                 Politique(i) = P_opt ;
        end
 end   
% % % affichage de la politique
 AffichePolitique(Politique,Plan,Map_plan2node);
 toc; 