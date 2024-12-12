function z = surface_oreille_trace(COEFF)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   DEFINITION DES CONSTANTERS
% coorodnnées du point A, le point cible
xa = 11;
ya = 2.5;
za = 5;
a = [xa, ya, za];

% origine rayon
I = [0 0 -1];

% taille du carré
taille = 10;
xlimb = -10;
xlimh = 10;
ylimb = -10;
ylimh = 10;
zref = 100;

% Définir les limites de la grille
x = linspace(xlimb, xlimh, taille); % 1 = 1cm
y = linspace(ylimb, ylimh, taille);
% Créer une grille 2D
[X, Y] = meshgrid(x, y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   DEFINITION DE LA SURFACE

ZZ = @(XX,YY) COEFF(1)*XX^3 + COEFF(2)*YY^3 + COEFF(3)*XX^2*YY  + COEFF(4)*YY^2*XX + COEFF(5)*XX^2 + COEFF(6)*YY^2 + COEFF(7)*XX*YY +  COEFF(8)*XX +  COEFF(9)*YY +  COEFF(10);
Z = COEFF(1)*X.^3 + COEFF(2)*Y.^3 + COEFF(3)*X.^2.*Y  + COEFF(4)*Y.^2.*X + COEFF(5)*X.^2 + COEFF(6)*Y.^2 + COEFF(7)*X.*Y +  COEFF(8)*X +  COEFF(9)*Y +  COEFF(10);

% je calcul la zone de recherche pour alpha
vecteur = [max(X(:,:)) - min(X(:,:)), max(Y(:,:)) - min(Y(:,:)), max(Z(:,:)) - min(Z(:,:))];
normvect = norm(vecteur);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   CALCUL DU CRITERE 1 A MAXIMISER


% Calculer les dérivées partielles, la normale et la surface ds en chaque point de la grille
parfor ii = 1:taille
    for jj = 1:taille
    
     
        xm = X(ii, jj);
        ym = Y(ii, jj);
        zm = Z(ii, jj);
        m = [xm, ym, zm];
        
        
        % Calculer les dérivées partielles
        df_dx = 3*COEFF(1)*xm^2 + 2*COEFF(3)*xm.*ym + COEFF(4)*ym^2  + 2*COEFF(5)*xm + COEFF(7)*ym +  COEFF(8);
        df_dy = 3*COEFF(2)*ym^2 + COEFF(3)*xm^2 + 2*COEFF(4)*ym*xm + 2*COEFF(6)*ym + COEFF(7)*xm +  COEFF(9);
        
        % Normale à la surface au point (xm, ym)
        normal_surface = [df_dx, df_dy, -1];
        normal_surface = -normal_surface / norm(normal_surface);
        
        % Normale à la surface au point (xm, ym)
        normal_ma=[xa - xm,ya - ym, za-zm]/norm([xa - xm,ya - ym, za-zm]);
        
        % Surface ds en fonction du point considéré
        ds = sqrt(df_dx^2 + df_dy^2 + 1);
        uma = (a - m)/norm((a - m));
        
        % reflexion surface
        normal_reflexion = I - 2*dot(I,normal_surface)*normal_surface;
        
        
        
        % reflexion vers surface ? on part du point M suivant la
        % normale_reflexion et on souhaite savoir si on retombe sur la
        % surface
        % alpha = 0;
        % p = m + alpha * normal_reflexion;
        % on cherche la difference de p à la surface
        % Définir une fonction qui représente la différence
        difference_function = @(alpha) (m(3) + alpha*normal_reflexion(3) - (ZZ(m(1) + alpha*normal_reflexion(1),m(2) + alpha*normal_reflexion(2))));
        % Utiliser une méthode de résolution numérique pour trouver alpha
        try
            alpha_solution = fzero(difference_function, [0.01, normvect]);
        catch % ca veut dire qu'on a pas trouvé de surface à intersecteur
            alpha_solution = 0;
        end
        compteur = 0;
        while isreal(alpha_solution) & compteur<100 & alpha_solution ~= 0
            compteur = compteur + 1;
            p =  m + alpha_solution * normal_reflexion; % point P, point ou on impacte à nouveau la surface
            if p(1)<xlimh & xlimb<p(1) & p(2)<ylimh & ylimb<p(2)
                % le nouveau point d'impact est dans la boite...
            else
                ds = 0; % s'il n'y est pas, pas de reflexion
                break
            end
            % Calculer les dérivées partielles
            df_dx = 3*COEFF(1)*p(1)^2 + 2*COEFF(3)*p(1)*p(2) + COEFF(4)*p(2)^2  + 2*COEFF(5)*p(1) + COEFF(7)*p(2) +  COEFF(8);
            df_dy = 3*COEFF(2)*p(2)^2 + COEFF(3)*p(1)^2 + 2*COEFF(4)*p(2)*p(1) + 2*COEFF(6)*p(2) + COEFF(7)*p(1) +  COEFF(9);
            
            % Normale à la surface au point (xm, ym)
            normal_surface = [df_dx, df_dy, -1];
            normal_surface = -normal_surface / norm(normal_surface);
            % on remplace ces valeur dans le calcul du critere. On a fait
            % une reflexion vers la surface. Le point d'impact est p. On
            % calcule la normale de reflexion à partir de p et c'est celle
            % associée au critere finalement. Pareil pour ds
            % Surface ds en fonction du point considéré
            ds = sqrt(df_dx^2 + df_dy^2 + 1);
            % reflexion surface
            normal_reflexion = I - 2*dot(I,normal_surface)*normal_surface;
            difference_function = @(alpha) (p(3) + alpha*normal_reflexion(3) - (ZZ(p(1) + alpha*normal_reflexion(1),p(2) + alpha*normal_reflexion(2))));
            try
                alpha_solution = fzero(difference_function, [0.01, normvect]);
            catch % ca veut dire qu'on a pas trouvé de surface à intersecteur
                alpha_solution = 0;
            end
        end
        
        % Stocker les résultats
         ALPHAij(ii, jj) = alpha_solution;
         NORMALS_SURFACE(ii, jj, :) = normal_surface;
         DS(ii, jj) = ds;
         REFLEXION_SURFACE(ii,jj,:) = normal_reflexion;
         UMA(ii,jj,:) =uma;
         COMPTEUR(ii,jj,:) =compteur;
        CRITERE(ii,jj,:) = (dot(normal_reflexion,uma));
        DISTANCEMA(ii,jj) = (norm(a-m) - zm);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   CALCULER DES CONTRAINTES
% Calculer la variance des angles
z1 = mean(CRITERE(:)); % critere a maximiser convergence des rayon reflechi vers la cible

% Calculer la variance des distances
z2 = (var(DISTANCEMA(:)))^0.5; % critere a minimiser ecart type

z = [-z1 z2]'; % le moins vient du fait qu'on cherche à maximiser z1 et on cherche bien a minimser z2



% Tracer la surface
figure;subplot(2, 2, 1);
surf(X, Y, Z);
title('Surface');
hold on;
% Plot des vecteurs normals en utilisant quiver3
quiver3(X, Y, Z, NORMALS_SURFACE(:,:,1), NORMALS_SURFACE(:,:,2), NORMALS_SURFACE(:,:,3), 0.5);
% Mettez en surbrillance le point cible A
scatter3(xa, ya, za, 'r', 'filled');


% Tracer la surface
subplot(2, 2, 2);
surf(X, Y, Z);
title('reflection');
hold on;
% Plot des vecteurs normals en utilisant quiver3
quiver3(X, Y, Z, REFLEXION_SURFACE(:,:,1), REFLEXION_SURFACE(:,:,2), REFLEXION_SURFACE(:,:,3), 0.5);
% Mettez en surbrillance le point cible A
scatter3(xa, ya, za, 'r', 'filled');


% Tracer la surface
subplot(2, 2, 3);
surf(X, Y, Z);
title('Uma');
hold on;
% Plot des vecteurs normals en utilisant quiver3
quiver3(X, Y, Z, UMA(:,:,1), UMA(:,:,2), UMA(:,:,3), 0.5);
% Mettez en surbrillance le point cible A
scatter3(xa, ya, za, 'r', 'filled');


% Tracer la surface
subplot(2, 2, 4);
surf(X, Y, DS);
title('ds');
hold on;
scatter3(xa, ya, za, 'r', 'filled');

end


