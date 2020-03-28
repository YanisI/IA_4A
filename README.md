Yanis Imekraz - Jonathan Andrieu

4 IR - IC2

# Rapport TRAVAUX PRATIQUES D'I.A

## ALGORITHME A* - APPLICATION AU TAQUIN

### 1. Familiarisation avec le problème du Taquin 3x3

#### a) Quelle clause Prolog permettrait de représenter la situation finale du Taquin 4x4 ?
```
final_state([[1, 2, 3, 4],
             [5, 6, 7, 8],
             [9, 10, 11, 12],
             [13, 14, 15, vide]).
```

#### b) A quelles questions permettent de répondre les requêtes suivantes :
```
?- initial_state(Ini), nth1(L,Ini,Ligne), nth1(C,Ligne, d).
?- final_state(Fin), nth1(3,Fin,Ligne), nth1(2,Ligne,P)
```
La première question permet de trouver la ligne et la colonne de l'élément "d" dans la matrice "Ini".
La deuxième permet de trouver l'élément présent aux coordonnées Ligne=3 et Colonne=2.

#### c) Quelle requête Prolog permettrait de savoir si une pièce donnée P (ex : a) est bien placée dans U0 (par rapport à F) ?
```
final_state(F),
initial_state(U0),
nth1(L,U0,Ligne),
nth1(C,Ligne,d),
nth1(L1,F,Ligne1),
nth1(C1,Ligne1,d)
```
Réponse de Swi-Prolog:

```
F = [[a, b, c], [h, vide, d], [g, f, e]],
U0 = [[b, h, c], [a, f, d], [g, vide, e]],
L = L1, L1 = 2,
Ligne = [a, f, d],
C = C1, C1 = 3,
Ligne1 = [h, vide, d] 
```
#### On s'intéresse maintenant au prédicat rule/4. Comment l'utiliser pour répondre aux questions suivantes :
#### d) quelle requête permet de trouver une situation suivante de l'état initial du Taquin 3x3 (3 sont possibles) ?

```
initial_state(Ini), rule(R,1,Ini,S2).
```

#### e) quelle requête permet d'avoir ces 3 réponses regroupées dans une liste ? (cf. findall/3 en Annexe).

```
initial_state(Ini), findall(R, rule(R,1,Ini,S2), L).
```

#### f) quelle requête permet d'avoir la liste de tous les couples [A, S] tels que S est la situation qui résulte de l'action A en U0 ?

```
initial_state(U0),findall([A,S],rule(A,1,U0,S),L). 
```

### 2. Développement des 2 heuristiques

Voir le code source disponible dans le dossier TP1.

### 3. Implémentation de A*

#### Noter le temps de calcul de A* et l’influence du choix de l’heuristique : quelle taille de séquences optimales (entre 2 et 30 actions) peut-on générer avec chaque heuristique (H1, H2) ? Présenter les résultats sous forme de tableau.

```
test_time(Runtime) :-
    statistics(runtime,[Start,_]),
    main,
    statistics(runtime,[Stop,_]),
    Runtime is Stop-Start.
```

#### Quelle longueur de séquence peut-on envisager de résoudre pour le Taquin 4x4 ?

#### A* trouve-t-il la solution pour la situation initiale suivante ?

```
initial_state([ [a, b, c], [g,vide,d], [h, f, e]]).
```

#### Quelle représentation de l’état du Rubik’s Cube et quel type d’action proposeriez-vous si vous vouliez appliquer A*?

## ALGO MINMAX - APPLICATION AU TICTACTOE
