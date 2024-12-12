
# Optimisation de Forme et Algorithme Génétique : Exemple en Python

Ce dépôt contient une mise en application simple de l'algorithme génétique NSGA-III pour illustrer l'optimisation multi-objectifs, en complément de l'article publié sur [selvasystems.net](https://selvasystems.net/optimisation-de-forme-et-algorithme-genetique-et-exemple-stupide).

## Contexte

Cet exemple a été conçu pour explorer de manière ludique l'optimisation multi-objectifs appliquée à un problème d'optimisation de forme en utilisant l'algorithme **NSGA-III**. 
L'objectif est d'optimiser une forme simple, une parabole, selon plusieurs critères. Ce dépôt est un simple exemple pédagogique utilisant l'implémentation originale.

**Article associé :**  
[Optimisation de forme et algorithme génétique : Exemple stupide](https://selvasystems.net/optimisation-de-forme-et-algorithme-genetique-et-exemple-stupide)

## Détails de l'implémentation

Ce dépôt est basé sur l'algorithme NSGA-III publié par Mostapha Kalami Heris et Yarpiz, avec des adaptations pour illustrer une application simplifiée.

**Source originale :**
- Auteur : Mostapha Kalami Heris, Yarpiz
- Titre : NSGA-III: Non-dominated Sorting Genetic Algorithm, the Third Version — MATLAB Implementation
- Lien : [https://yarpiz.com/456/ypea126-nsga3](https://yarpiz.com/456/ypea126-nsga3)
- Licence : BSD 3-Clause (voir [LICENSE](./LICENSE))

## Contenu

- Un exemple ludique d'optimisation de forme
- Code bien commenté pour faciliter l'exploration et l'apprentissage.

Les fichiers personnalisés pour cet exemple sont : 
- nsga3.m pour les paramètres généraux
- surface_oreille.m pour la fonction permettant le calcul des critères

## Utilisation

1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/votre-utilisateur/optimisation_forme_exemple_NSGAIII.git
   ```
2. Lancer dans Matlab le fichier nsga3.m

## Exemple d'optimisation

L'exemple optimise une forme géométrique selon deux critères contradictoires. Voici un aperçu des résultats attendus :

- **Objectif 1** : Minimiser la surface de la forme.
- **Objectif 2** : Maximiser le périmètre.

L'algorithme explore les compromis possibles entre ces deux objectifs et génère un ensemble de solutions Pareto optimales.

## Licence

Ce projet est distribué sous la licence BSD 3-Clause, conformément au projet original. Consultez le fichier [LICENSE](./LICENSE) pour les détails.

## Ressources complémentaires

- [Optimisation multi-objectifs](https://en.wikipedia.org/wiki/Multi-objective_optimization)
- [NSGA-III : Une introduction](https://yarpiz.com/456/ypea126-nsga3)
- [Article sur Selvasystems.net](https://selvasystems.net/optimisation-de-forme-et-algorithme-genetique-et-exemple-stupide)
