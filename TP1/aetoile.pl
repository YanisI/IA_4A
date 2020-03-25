%*******************************************************************************
%                                    AETOILE
%*******************************************************************************

/*
Rappels sur l'algorithme
 
- structures de donnees principales = 2 ensembles : P (etat pendants) et Q (etats clos)
- P est dedouble en 2 arbres binaires de recherche equilibres (AVL) : Pf et Pu
 
   Pf est l'ensemble des etats pendants (pending states), ordonnes selon
   f croissante (h croissante en cas d'egalite de f). Il permet de trouver
   rapidement le prochain etat a developper (celui qui a f(U) minimum).
   
   Pu est le meme ensemble mais ordonne lexicographiquement (selon la donnee de
   l'etat). Il permet de retrouver facilement n'importe quel etat pendant

   On gere les 2 ensembles de fa�on synchronisee : chaque fois qu'on modifie
   (ajout ou retrait d'un etat dans Pf) on fait la meme chose dans Pu.

   Q est l'ensemble des etats deja developpes. Comme Pu, il permet de retrouver
   facilement un etat par la donnee de sa situation.
   Q est modelise par un seul arbre binaire de recherche equilibre.

Predicat principal de l'algorithme :

   aetoile(Pf,Pu,Q)

   - reussit si Pf est vide ou bien contient un etat minimum terminal
   - sinon on prend un etat minimum U, on genere chaque successeur S et les valeurs g(S) et h(S)
	 et pour chacun
		si S appartient a Q, on l'oublie
		si S appartient a Ps (etat deja rencontre), on compare
			g(S)+h(S) avec la valeur deja calculee pour f(S)
			si g(S)+h(S) < f(S) on reclasse S dans Pf avec les nouvelles valeurs
				g et f 
			sinon on ne touche pas a Pf
		si S est entierement nouveau on l'insere dans Pf et dans Ps
	- appelle recursivement etoile avec les nouvelles valeurs NewPF, NewPs, NewQs

*/

%*******************************************************************************

:- ['avl.pl'].       % predicats pour gerer des arbres bin. de recherche   
:- ['taquin.pl'].    % predicats definissant le systeme a etudier

%*******************************************************************************

main :-
    initial_state(S0),   %calcul de S0
    heuristique(S0, H0), %calcul de H0
 
    % F0 is G0 + H0 et à l'initialisation G0 = 0 donc F0 = H0  
    G0 is 0,
    F0 is G0 + H0,
 
    % initialisations Pf, Pu et Q 
    empty(Pf), 
    empty(Pu), 
    empty(Q), 
 
    %insertion des premiers noeuds dans Pf et Pu
    insert([[F0,H0,G0],S0], Pf, Pf_New),
    insert([S0,[F0,H0,G0],nil,nil], Pu, Pu_New),

    % lancement de Aetoile
    aetoile(Pf_New, Pu_New, Q). 


%*******************************************************************************

aetoile([],[],_) :- 
    writeln("PAS DE SOLUTION! L’ETAT FINAL N’EST PAS ATTEIGNABLE !").

aetoile(Pf, Pu, Qs) :-
    final_state(Fin), 
    suppress_min([[_,_,G],U], Pf, Pf2), 
    (U = Fin -> %si min = l'état final alors on a trouve la solution
        suppress([U,FHG,P,A], Pu, _),
        insert([U,FHG,P,A], Qs, Qs_New),
        affiche_solution(Qs_New, U) 
    ; 
        suppress([U,FHG,P,A],Pu,Pu2),
        expand(U,G,Res),
        loop_successors(Res,Pu2,Pf2,Qs,Pu_New,Pf_New),
        insert([U,FHG,P,A], Qs, Qs_New),
        aetoile(Pf_New,Pu_New,Qs_New)
    ).
 
 affiche_solution(_,nil).
 affiche_solution(Q,U):-
    belongs([U,_,P,A], Q), %on vérifie que le noeuf appartient à Qs
    affiche_solution(Q,P),
    (A=nil -> %si noeud initial (A représente le coup joué: down, up, right, left)
        write('Start'),
        write(' -> '),
        initial_state(I),
        writeln(I)
    ;
        write(A), write(' -> '), write(U), writeln("")
    ).

expand(U,Gu,S) :- %U situation, Gu cout de U, S état successeurs
    findall([S2, [F,H,G2], U, R], (rule(R,1,U,S2),heuristique(S2,H),G2 is Gu+H,F is G2+H), S).

loop_successors([],Pu,Pf,_,Pu,Pf).

loop_successors([S1|Reste],Pu,Pf,Q,Pu_New,Pf_New):-
    process_one_successor(S1,Pu,Pf,Q,Pu_aux,Pf_aux),
    loop_successors(Reste,Pu_aux,Pf_aux,Q,Pu_New,Pf_New).

process_one_successor([U,FHG1,P1,A1],Pu,Pf,Q,Pu_aux,Pf_aux):-
    
    (belongs([U,_,_,_],Q) -> %si U est connu dans Q alors oublier cet état (U a déjà été développé)
        
        Pu_aux = Pu, 
        Pf_aux = Pf
    ; 
        ((suppress([U,FHG2,_,_],Pu,Pu1)),
        suppress_min([FHG2,U],Pf,Pf1) -> %si U est connu dans Pu alors garder le terme associé à la meilleure évaluation (dans Pu et dans Pf)
           
            ( FHG1 @< FHG2 -> %ici on choisit le terme associé à la meilleure évaluation
                
                insert([U,FHG1,P1,A1],Pu1,Pu_aux),
                insert([FHG1,U],Pf1,Pf_aux)
            ;
                
                Pf_aux = Pf,
                Pu_aux = Pu
            )

        ; %sinon (U est une situation nouvelle) il faut créer un nouveau terme à insérer dans Pu (idem dans Pf)
            
            insert([FHG1,U],Pf,Pf_aux),
            insert([U,FHG1,P1,A1],Pu,Pu_aux)
        )
        
    ).

test_time(Runtime) :-
    statistics(runtime,[Start,_]),
    main,
    statistics(runtime,[Stop,_]),
    Runtime is Stop-Start.

