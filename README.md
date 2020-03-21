# Rapport TRAVAUX PRATIQUES D'I.A

## 1. Familiarisation avec le problème du Taquin 3x3

a) Quelle clause Prolog permettrait de représenter la situation finale du Taquin 4x4 ?

b) A quelles questions permettent de répondre les requêtes suivantes :
```
?- initial_state(Ini), nth1(L,Ini,Ligne), nth1(C,Ligne, d).
?- final_state(Fin), nth1(3,Fin,Ligne), nth1(2,Ligne,P)
```

c) Quelle requête Prolog permettrait de savoir si une pièce donnée P (ex : a) est bien placée dans U0 (par rapport à F) ?


On s'intéresse maintenant au prédicat rule/4. Comment l'utiliser pour répondre aux questions suivantes :

d) quelle requête permet de trouver une situation suivante de l'état initial du Taquin 3x3 (3 sont possibles) ?

e) quelle requête permet d'avoir ces 3 réponses regroupées dans une liste ? (cf. findall/3 en Annexe).

f) quelle requête permet d'avoir la liste de tous les couples [A, S] tels que S est la situation qui résulte de l'action A en U0 ?

## 2. Développement des 2 heuristiques

## 3. Implémentation de A*

Noter le temps de calcul de A* et l’influence du choix de l’heuristique : quelle taille de séquences optimales (entre 2 et 30 actions) peut-on générer avec chaque heuristique (H1, H2) ? Présenter les résultats sous forme de tableau.

Quelle longueur de séquence peut-on envisager de résoudre pour le Taquin 4x4 ?

A* trouve-t-il la solution pour la situation initiale suivante ?

Quelle représentation de l’état du Rubik’s Cube et quel type d’action proposeriez-vous si vous vouliez appliquer A*?
