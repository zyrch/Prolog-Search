remove_prev :-
  retract(visited(_)),
  fail.
remove_prev.

input :-
  
  clear,
  loading(5),
  
  remove_prev,

  delayedPrint("Choose search method:", 0.03), nl,
  delayedPrint("1. Best First Search", 0.03), nl,
  delayedPrint("2. Depth First Search", 0.03), nl,
  read(Choice),
  (not(Choice =:= 1; Choice =:= 2) -> delayedPrint('Input is not a valid', 0.03), nl, fail; true),
  delayedPrint("Enter the name of start city:", 0.03), nl,
  read(StartCity),
  delayedPrint("Enter the name of end city:", 0.03), nl,
  read(EndCity),
  (Choice =:= 2 -> dfs(StartCity, EndCity, Path, Result); best_first(StartCity, EndCity, [], Path, Result)),
  write_list(Path),
  delayedPrint(Result, 0.03).

%========================== Best First Search ===============================
%
best_first(U, U, _, [U], 0). 
best_first(U, Target, Queue, Path, Distance) :- 
  assert(visited(U)),
  findall((X, D, E), (connect(U, X, E), not(visited(X)), connect_air(X, Target, D)), NextAdd),
  append(Queue, NextAdd, NewQueue),
  poll_queue(NewQueue, Node, _, Cost, PolledQueue),
  best_first(Node, Target, PolledQueue, NewPath, NewDistance),
  append([U], NewPath, Path),
  Distance is Cost + NewDistance.

poll_queue(List, Node, Hcost, Cost, NewList):-
  getMinList(List, Node, Hcost, Cost),
  delete(List, (Node, Hcost, Cost), NewList).

getMinList([H|T], Node, Hcost, Cost) :-
  foldl(minCity, T, H, Min), 
  opener(Min, Node, Hcost, Cost).

opener((First,Second,Third), First, Second, Third).

minCity((A, B, E), (C, D, F), (MinA, MinB, MinC)) :- 
  (
    B > D -> (MinA = C, MinB = D, MinC = F)
  ; (MinA = A, MinB = B, MinC = E)
  ).


%========================== Depth First Search ===============================

dfs(U, U, [U], 0).
dfs(U, Target, Path, Distance):-
  assert(visited(U)),
  connect(U, X, D),
  not(visited(X)),
  dfs(X, Target, NewPath, NewDistance),
  append([U], NewPath, Path),
  Distance is D + NewDistance.
      

write_list([]).
write_list([A|T]) :-
  delayedPrint(A, 0.03), delayedPrint(' ', 0.03),
    write_list(T).

  
  

%================================ UTILS ====================================== %

% display text with delay between each character

 delayText([H|T], X) :- put_char(H), flush_output, sleep(X), delayText(T, X).
 delayText([], _).
 
 delayedPrint(P, X) :- atom_chars(P, Cs), delayText(Cs, X).
 
 % Clears the screen
 clear:-
   tty_clear.
 
 loading(A) :-
   ( A > 0 -> 
     (
       write('Loading  \\ '), flush_output, sleep(0.1),
       clear,
       write('Loading  | '), flush_output, sleep(0.1),
       clear,
       write('Loading  / '), flush_output, sleep(0.1),
       clear,
       write('Loading  - '), flush_output, sleep(0.1),
       clear,
       write('Loading  | '), flush_output, sleep(0.1),
       clear,
       write('Loading  \\ '), flush_output, sleep(0.1),
       clear,
       A1 is A - 1,
       loading(A1)
     ); true
   ).
 
 thinking(A) :-
   ( A > 0 -> 
     (
       write('Thinking █ '), flush_output, sleep(0.1), clear,
       write('Thinking ▇ '), flush_output, sleep(0.1), clear,
       write('Thinking ▆ '), flush_output, sleep(0.1), clear,
       write('Thinking ▅ '), flush_output, sleep(0.1), clear,
       write('Thinking ▄ '), flush_output, sleep(0.1), clear,
       write('Thinking ▃ '), flush_output, sleep(0.1), clear,
       write('Thinking ▁ '), flush_output, sleep(0.1), clear,
       write('Thinking ▃ '), flush_output, sleep(0.1), clear,
       write('Thinking ▄ '), flush_output, sleep(0.1), clear,
       write('Thinking ▅ '), flush_output, sleep(0.1), clear,
       write('Thinking ▆ '), flush_output, sleep(0.1), clear,
       write('Thinking ▇ '), flush_output, sleep(0.1), clear,
       write('Thinking █ '), flush_output, sleep(0.1), clear,
       A1 is A - 1,
       thinking(A1)
     ); true
   ).
