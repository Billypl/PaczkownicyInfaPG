%{
  /* This program implements finite-state automata construction
   * regular expressions. Its input is a regular expression.
   * The output is a graph with 3 subgraphs representing:
   *
   * 1. A nondeterministic automaton resulting from Yamada-McNaughton-Glushkov
   *	construction.
   *
   * 2. Determinized automaton from point 1.
   *
   * 3. Minimized automaton from point 2.
   *
   * The output is in the format of program dot from a package graphviz
   * available from AT&T.
   *
   * This program was written by Jan Daciuk in 2007. It was written
   * in order to teach students the use of bison and finite-state automata.
   * Modified in 2008, in 2011, and in 2013 by Jan Daciuk.
   */
  #include	<stdio.h>
  #include	<string.h>
  #include	<stdlib.h>
  #define	MAXSTATES	1000
  #define	MAXTRANSITIONS	10000
  #define	MAXSUBRES	1000
  #define	MAXLISTS	10000
  #define	MAXPAIRLISTS	50000
  #define	EPSILON		'-'

  typedef struct {
    int		null;		/* true if epsilon belongs to this RE */
    int		first;		/* list of symbols that can be first */
    int		last;		/* list of symbols that can be last */
    int		follow;		/* list  of   pairs  of  symbols  that
				   follow one another */
  } REinfo;

  typedef struct {
    int		source;		/* source state */
    int		target;		/* target state */
    int		label;		/* label */
    int		next;		/* next transition for the state */
  } transition;

  typedef struct {
    int		first;
    int		next;
  } state_list;

  typedef struct {
    int 	source;
    int		target;
    int		next;
  } pair_list;

  REinfo	subREs[MAXSUBRES]; /* subexpressions of regular expressions */
  transition	transitions[MAXTRANSITIONS];
  int		final[MAXSTATES]; /* final states marked with 1's */
  int		state_syms[MAXSTATES]; /* symbols and positions for states */
  pair_list	state_pairs[MAXTRANSITIONS]; /* transitions as pairs of states*/
  int		first_trans[MAXSTATES]; /* first transition number of state */
  REinfo	curr_subRE;	/* current subexpression states */
  int		states;		/* number of states */
  int		no_trans;	/* number of transitions */
  int		no_subREs;	/* number of subexpressions created */
  int		alphabet_size;	/* size of the alphabet */
  char		*alphabet;
  char		*in_alphabet; 	/* in_alphabet[a]=1 if a is in alphabet */
  char		title[MAXTRANSITIONS]; /* graph title - RE as text */
  char		*title_start;	/* where to put the rest of the title */
  state_list	lists[MAXLISTS];/* stores first and last lists */
  int		list_pointer;	/* number of items on `lists' */
  int		pair_pointer;	/* number of intems on `state_pairs' */
  

  int RE_NULL(const int x);
  int RE_FIRST(const int x);
  int RE_LAST(const int x);
  int RE_FOLLOW(const int x);
  int create_state(const int sym);
  int merge_lists(const int l1, const int l2);
  int create_list(const int s);
  int merge_pairlist(const int l1, const int l2);
  int list_product(const int l1, const int l2);
  int create_transition(const int source, const int target, const int label);
  int createRE(const int null, const int first, const int last,
	       const int follow);
  int create_NFA(void);
  void process_automaton(const int nfa_start);
  int determinize(const int sr);
  int *check_transition(const int *sset, const int symbol);
  int epsilon_closure(int *current_set);
  int add_to_set(int *set, const int item);
  int minimize(const int dfa_first_state, const int dfa_last_state,
	       const int dfa_first_trans, const int dfa_last_trans);
  int main(const int argc, const char *argv);
  void print_automaton(const int nfa_states, const int nfa_trans,
		       const int nfa_start, const int dfa_states,
		       const int dfa_trans, const int dfa_start,
		       const int min_states, const int min_trans,
		       const int min_start, const char *graph_title);

%}

%token EMPTY
%token SYMBOL
%token EPS
%left '|'
%left CONCAT
%left '*'
%nonassoc '(' ')'


%%


/* empty set */

/* epsilon (empty symbol sequence) */
RE: EPS {
  $$ = createRE(1, -1, -1, -1);
 }

/* symbol from the alphabet and epsilon (empty symbol sequence) */
RE: SYMBOL {
  int s = create_state($1);
  int l = create_list(s);
  $$ = createRE(0, l, l, -1);
}
;

/* concatenation (note operator precedence) */

/* alternative */

/* Kleene's star */

/* parentheses */

%%

/* Name:	RE_NULL
 * Purpose:	Extracts Null value for a regular expression.
 * Parameters:	x		- (i) regular expression number.
 * Returns:	Null() (does epsilon belong to the RE) for the expression.
 * Globals:	subREs		- (i) regular expressions data.
 *		no_subREs	- (i) number of regular (sub)expressions.
 * Remarks:	This used to be a macro, but it was converted to a function
 *		to check validity of its parameter.
 */
int
RE_NULL(const int x) {
  if (x >= no_subREs || x < 0) {
    fprintf(stderr, "Fake expression number %d given to RE_NULL().\n", x);
    fprintf(stderr, "Can you count to 3?\n");
    exit(3);
  }
  return subREs[x].null;
}/*RE_NULL*/

/* Name:	RE_FIRST
 * Purpose:	Extracts First value for a regular expression.
 * Parameters:	x		- (i) regular expression number.
 * Returns:	First() (the set of first symbols) for the expression.
 * Globals:	subREs		- (i) regular expressions data.
 *		no_subREs	- (i) number of regular (sub)expressions.
 * Remarks:	This used to be a macro, but it was converted to a function
 *		to check validity of its parameter.
 */
int
RE_FIRST(const int x) {
  if (x >= no_subREs || x < 0) {
    fprintf(stderr, "Fake expression number %d given to RE_FIRST().\n", x);
    fprintf(stderr, "Can you count to 3?\n");
    exit(3);
  }
  return subREs[x].first;
}/*RE_FIRST*/

/* Name:	RE_LAST
 * Purpose:	Extracts Last value for a regular expression.
 * Parameters:	x		- (i) regular expression number.
 * Returns:	Last() (the set of last symbols) for the expression.
 * Globals:	subREs		- (i) regular expressions data.
 *		no_subREs	- (i) number of regular (sub)expressions.
 * Remarks:	This used to be a macro, but it was converted to a function
 *		to check validity of its parameter.
 */
int
RE_LAST(const int x) {
  if (x >= no_subREs || x < 0) {
    fprintf(stderr, "Fake expression number %d given to RE_LAST().\n", x);
    fprintf(stderr, "Can you count to 3?\n");
    exit(3);
  }
  return subREs[x].last;
}/*RE_LAST*/

/* Name:	RE_FOLLOW
 * Purpose:	Extracts Follow value for a regular expression.
 * Parameters:	x		- (i) regular expression number.
 * Returns:	Follow() (the set of follow symbol pairs) for the expression.
 * Globals:	subREs		- (i) regular expressions data.
 *		no_subREs	- (i) number of regular (sub)expressions.
 * Remarks:	This used to be a macro, but it was converted to a function
 *		to check validity of its parameter.
 */
int
RE_FOLLOW(const int x) {
  if (x >= no_subREs || x < 0) {
    fprintf(stderr, "Fake expression number %d given to RE_FOLLOW().\n", x);
    fprintf(stderr, "Can you count to 3?\n");
    exit(3);
  }
  return subREs[x].follow;
}/*RE_FOLLOW*/


/* Name:	create_state
 * Purpose:	Creates a new state in the automaton and registeres a new
 *		numbered symbol.
 * Parameters:	sym		- (i) symbol to be a label on all incoming
 *					transitions.
 * Returns:	A new state number.
 * Globals:	states		- (i/o) number of states in the automaton;
 *		first_trans	- (o) index of first transition of the state
 *					in the transition vector (-1 = no);
 *		state_syms	- (o) stores symbols for the states.
 * Remarks:	There cannot be more than MAXSTATES states.
 */
int
create_state(const int sym) {
  if (states + 1 < MAXSTATES) {
    first_trans[states] = -1;
    state_syms[states] = sym;
    return states++;
  }
  else {
    fprintf(stderr, "Not enough memory for states. Increase MAXSTATES.\n");
    exit(2);
  }
}/*create_state*/
    
/* Name:	merge_lists
 * Purpose:	Merges two lists of numbered symbols.
 * Parameters:	l1		- (i) head index of the first list;
 *		l2		- (i) head index of the second list.
 * Returns:	A list being a result of the merger.
 * Globals:	lists		- (i/o) list of numbered symbols storing
 *					lists of first and last symbol sets.
 *		list_pointer	- (i/o) number of items on the list `lists'.
 * Remarks:	A new list is created. l1 and l2 remain intact.
 *		The lists are sorted.
 */
int
merge_lists(const int l1, const int l2) {
  int v1 = l1;
  int v2 = l2;
  int v3 = list_pointer;
  int result = v3;
  if (v1 >= v3) {
    fprintf(stderr, "The first list %d to be merged does not exist.\n", v1);
    exit(3);
  }
  if (v2 >= v3) {
    fprintf(stderr, "The second list %d to be merged does not exist.\n", v2);
    exit(3);
  }
  if (l1 == -1 && l2 == -1) {
    return -1;			/* empty list from two empty lists */
  }
  while (v1 != -1 && v2 != -1) {
    if (list_pointer >= MAXLISTS) {
      fprintf(stderr, "Number of items on lists exceeds %d\n", MAXLISTS);
      fprintf(stderr, "Increase MAXLISTS constant and recompile.\n");
      exit(2);
    }
    if (lists[v1].first <= lists[v2].first) {
      /* Take an item from l1 */
      lists[list_pointer].first = lists[v1].first;
      v1 = lists[v1].next;
    }
    else {
      /* Take an item from l2 */
      lists[list_pointer].first = lists[v2].first;
      v2 = lists[v2].next;
    }
    lists[list_pointer].next = list_pointer + 1;
    list_pointer++;
  }
  while (v1 != -1) {
    /* Append l1 by copying */
    if (list_pointer >= MAXLISTS) {
      fprintf(stderr, "Number of items on lists exceeds %d\n", MAXLISTS);
      fprintf(stderr, "Increase MAXLISTS constant and recompile.\n");
      exit(2);
    }
    lists[list_pointer].first = lists[v1].first;
    v1 = lists[v1].next;
    lists[list_pointer].next = list_pointer + 1;
    list_pointer++;
  }
  while (v2 != -1) {
    /* Append l2 by copying */
    if (list_pointer >= MAXLISTS) {
      fprintf(stderr, "Number of items on lists exceeds %d\n", MAXLISTS);
      fprintf(stderr, "Increase MAXLISTS constant and recompile.\n");
      exit(2);
    }
    lists[list_pointer].first = lists[v2].first;
    v2 = lists[v2].next;
    lists[list_pointer].next = list_pointer + 1;
    list_pointer++;
  }
  /* Finish the list */
  lists[list_pointer - 1].next = -1;
  return result;
} /* merge_lists */

/* Name:	create_list
 * Purpose:	Creates a list in `lists' with one initial item.
 * Parameters:	s		- (i) initial item.
 * Returns:	Index of s on the list.
 * Globals:	lists		- (o) list of numbered symbols storing
 *					lists of first and last symbol sets.
 *		list_pointer	- (i/o) number of items on the list `lists'.
 * Remarks:	Since a list pointer to an empty list is -1, it does not
 *		make sense to create an empty list. On the other hand,
 *		in Glushkov construction, we never create a list with more
 *		than one item from scratch.
 */
int
create_list(const int s) {
  if (list_pointer >= MAXLISTS) {
    fprintf(stderr, "Number of items on lists exceeds %d\n", MAXLISTS);
    fprintf(stderr, "Increase MAXLISTS constant and recompile.\n");
    exit(2);
  }
  lists[list_pointer].first = s;
  lists[list_pointer].next = -1;
  return list_pointer++;
} /* create_list */

/* Name:	merge_pairlist
 * Purpose:	Merges two lists consisting of pairs of states or pairs
 *		of numbered symbols.
 * Parameters:	l1		- (i) first list;
 *		l2		- (i) second list.
 * Returns:	A new list pointer.
 * Globals:	state_pairs	- (i/o) list of pairs of adjacent numbered
 *					symbols in the language of a regular
 *					expression or (equivalently)
 *					of pairs of states to be linked;
 *		pair_pointer	- (i/o) number of items on `state_pairs'.
 * Remarks:	The lists are sorted.
 */
int
merge_pairlist(const int l1, const int l2) {
  int v1 = l1;
  int v2 = l2;
  int v3 = pair_pointer;
  int result = v3;
  if (v1 >= v3) {
    fprintf(stderr, "The first pairlist %d to be merged is bogus\n", v1);
    exit(3);
  }
  if (v2 >= v3) {
    fprintf(stderr, "The second pairlist %d to be merged is bogus\n", v2);
    exit(3);
  }
  if (l1 == -1 && l2 == -1) {
    return -1;			/* empty list from two empty lists */
  }
  while (v1 != -1 && v2 != -1) {
    if (pair_pointer >= MAXPAIRLISTS) {
      fprintf(stderr, "Number of items on state_pairs exceeds %d\n",
	      MAXPAIRLISTS);
      fprintf(stderr, "Increase MAXPAIRLISTS constant and recompile.\n");
      exit(2);
    }
    if (state_pairs[v1].source < state_pairs[v2].source ||
	(state_pairs[v1].source == state_pairs[v2].source &&
	 state_pairs[v1].target < state_pairs[v2].target)) {
      /* Take an item from l1 */
      state_pairs[pair_pointer].source = state_pairs[v1].source;
      state_pairs[pair_pointer].target = state_pairs[v1].target;
      v1 = state_pairs[v1].next;
    }
    else {
      /* Take an item from l2 */
      state_pairs[pair_pointer].source = state_pairs[v2].source;
      state_pairs[pair_pointer].target = state_pairs[v2].target;
      v2 = state_pairs[v2].next;
    }
    state_pairs[pair_pointer].next = pair_pointer + 1;
    pair_pointer++;
  }
  while (v1 != -1) {
    /* Append l1 by copying */
    if (pair_pointer >= MAXPAIRLISTS) {
      fprintf(stderr, "Number of items on state_pairs exceeds %d\n",
	      MAXPAIRLISTS);
      fprintf(stderr, "Increase MAXPAIRLISTS constant and recompile.\n");
      exit(2);
    }
    state_pairs[pair_pointer].source = state_pairs[v1].source;
    state_pairs[pair_pointer].target = state_pairs[v1].target;
    v1 = state_pairs[v1].next;
    state_pairs[pair_pointer].next = pair_pointer + 1;
    pair_pointer++;
  }
  while (v2 != -1) {
    /* Append l2 by copying */
    if (pair_pointer >= MAXPAIRLISTS) {
      fprintf(stderr, "Number of items on state_pairs exceeds %d\n",
	      MAXPAIRLISTS);
      fprintf(stderr, "Increase MAXPAIRLISTS constant and recompile.\n");
      exit(2);
    }
    state_pairs[pair_pointer].source = state_pairs[v2].source;
    state_pairs[pair_pointer].target = state_pairs[v2].target;
    v2 = state_pairs[v2].next;
    state_pairs[pair_pointer].next = pair_pointer + 1;
    pair_pointer++;
  }
  /* Finish the list */
  state_pairs[pair_pointer - 1].next = -1;
  return result;
} /* merge_pairlist */

/* Name:	list_product
 * Purpose:	Creates a list of pairs of symbols/states from two lists
 *		of symbols/states, where each item from the first list
 *		is paired with each symbol from the second list.
 * Parameters:	l1		- (i) first list;
 *		l2		- (i) second list.
 * Returns:	A list of pairs, i.e. an index of the first pair instate_pairs.
 * Globals:	lists		- (i) list of numbered symbols storing
 *					lists of first and last symbol sets.
 *		state_pairs	- (o) list of pairs of adjacent numbered
 *					symbols in the language of a regular
 *					expression or (equivalently)
 *					of pairs of states to be linked;
 *		pair_pointer	- (i/o) number of items on `state_pairs'.
 * Remarks:	We assume that lists contain no duplicates.
 */
int
list_product(const int l1, const int l2) {
  int v1, v2;
  int prev = -1;
  int head = pair_pointer;
  if (l1 >= list_pointer) {
    fprintf(stderr, "The first list %d in a product is bogus.\n", l1);
    exit(3);
  }
  if (l2 >= list_pointer) {
    fprintf(stderr, "The second list %d in a product is bogus.\n", l2);
    exit(3);
  }
  if (l1 == -1 || l2 == -1) {
    return -1;
  }
  for (v1 = l1; v1 != -1; v1 = lists[v1].next) {
    for (v2 = l2; v2 != -1; v2 = lists[v2].next) {
      if (pair_pointer >= MAXPAIRLISTS) {
	fprintf(stderr, "Number of items on state_pairs exceeds %d\n",
		MAXPAIRLISTS);
	fprintf(stderr, "Increase MAXPAIRLISTS constant and recompile.\n");
	exit(2);
      }
      state_pairs[pair_pointer].source = lists[v1].first;
      state_pairs[pair_pointer].target = lists[v2].first;
      state_pairs[pair_pointer].next = pair_pointer + 1;
      prev = pair_pointer++;
    } /* for v2 */
  }   /* for v1 */
  state_pairs[prev].next = -1;
  return head;
} /* list_product */

/* Name:	create_transition
 * Purpose:	Creates a new transition.
 * Parameters:	source		- (i) source state number;
 *		target		- (i) target state number;
 *		label		- (i) transition label.
 * Returns:	A new transition number.
 * Globals:	transitions	- (i/o) transitions of the automaton;
 *		no_trans	- (i/o) number of transitions in the automaton.
 * Remarks:	There cannot be more than MAXTRANSITIONS transitions.
 *		Source and target states must already be created.
 */
int
create_transition(const int source, const int target, const int label) {
  if (no_trans + 1 < MAXTRANSITIONS) {
    transitions[no_trans].source = source;
    transitions[no_trans].target = target;
    transitions[no_trans].label = label;
    transitions[no_trans].next = first_trans[source];
    first_trans[source] = no_trans;
    return no_trans++;
  }
  else {
    fprintf(stderr, "Not enough memory for transitions. Increase MAXTRANSITIONS.\n");
    exit(2);
  }
}/* create_transition */

/* Name:	createRE
 * Purpose:	Stores the the values of null, first, last, and follow
 *		of a subexpression of a regular expression in subREs
 *		and returns its index.
 * Parameters:	null		- (i) whether epsilon is recognized;
 *		first		- (i) list of numbered symbols that can start
 *					words in the subexpression;
 *		last		- (i) list of numbered symbols that can end
 *					words in the subexpression;
 *		follow		- (i) list of pairs of numbered symbols
 *					that can appear adjacent and
 *					in that order in a subexpression.
 * Returns:	Index of the subexpression (start and final state) in subREs.
 * Globals:	subREs		- (i/o) stores initial and final states
 *					of all subexpressions of a regular
 *					expression in Thompson Construction;
 *		no_subREs	- (i/o) number of subexpressions in subREs.
 * Remarks:	To avoid problems with returning structures in pure C,
 *		we store the values of null, first, last and follow of each
 *		regular subexpression in Glushkov Construction in a vector.
 *		Then we can return an index to a particular entry, and retrieve
 *		the pair of states when needed.
 *		Lists are represented as indexes of their heads
 *		in the appropriate vectors.
 */
int
createRE(const int null, const int first, const int last, const int follow) {
  if (first >= list_pointer) {
    fprintf(stderr, "The set FIRST %d in an expression is bogus.\n", first);
    exit(3);
  }
  if (last >= list_pointer) {
    fprintf(stderr, "The set LAST %d in an expression is bogus.\n", last);
    exit(3);
  }
  if (follow >= pair_pointer) {
    fprintf(stderr, "The set FOLLOW %d in an expression is bogus.\n", follow);
    exit(3);
  }
  if (no_subREs + 1 < MAXSUBRES) {
    subREs[no_subREs].null = null;
    subREs[no_subREs].first = first;
    subREs[no_subREs].last = last;
    subREs[no_subREs].follow = follow;
    return no_subREs++;
  }
  else {
    fprintf(stderr,
	    "Not enough memory for subexpressions. Increase MAXSUBRES.\n");
    exit(2);
  }
}//createRE

/* Name:	create_NFA
 * Purpose:	Creates a nondeterministic automaton using the quadruple
 *		null, first, last, and follow information.
 * Parameters:	None.
 * Returns:	The initial state of the NFA.
 * Globals:	subREs		- (i) null, first, last, and follow
 *					of subexpressions;
 *		state_syms	- (i) symbols for the states.
 * Remarks:	None.
 */
int
create_NFA(void) {
  /* Create the initial state */
  int s = create_state(0);
  /* Establish its finality */
  if (RE_NULL(no_subREs - 1)) {
    final[s] = 1;
  }
  /* Set finality of final states */
  int l;
  for (l = RE_LAST(no_subREs - 1); l != -1; l = lists[l].next) {
    final[lists[l].first] = 1;
  }
  /* Set up transitions from the initial state */
  for (l = RE_FIRST(no_subREs - 1); l != -1; l = lists[l].next) {
    create_transition(s, lists[l].first, state_syms[lists[l].first]);
  }
  /* Set up remaining transitions */
  for (l = RE_FOLLOW(no_subREs - 1); l != -1; l = state_pairs[l].next) {
    create_transition(state_pairs[l].source,
		      state_pairs[l].target,
		      state_syms[state_pairs[l].target]);
  }
  return s;
} /* create_NFA */

/* Name:	process_automaton
 * Purpose:	Determinizes, minimizes, and prints the automaton.
 * Parameters:	None.
 * Returns:	Nothing.
 * Globals:	final		- (o) final[i]=1 if ith state is final;
 *		subREs		- (i) first and last state of subexpressions;
 *		no_subREs	- (i) number of subexpressions.
 * Remarks:	Most data is shared by global variables because it is needed
 *		by the parser.
 *		The automaton is printed in 3 versions:
 *		1. The original NFA from Glushkov construction.
 *		2. DFA resulting from determinization of 1.
 *		3. Minimal DFA resulting from minimization of 2.
 */
void
process_automaton(const int nfa_start) {
  int i, nfa_states, nfa_trans, dfa_states, dfa_trans, min_states, min_trans;
  int dfa_start, min_start;
  nfa_states = states;
  nfa_trans = no_trans;
  dfa_start = determinize(nfa_start);
  dfa_states = states;
  dfa_trans = no_trans;
  min_start = minimize(nfa_states, dfa_states - 1, nfa_trans, dfa_trans - 1);
  min_states = states;
  min_trans = no_trans;
  print_automaton(nfa_states, nfa_trans, nfa_start, dfa_states, dfa_trans,
		  dfa_start, min_states, min_trans, min_start, title);
}//process_automaton

/* Name:	determinize
 * Purpose:	Determinizes a nondeterministic automaton (NFA).
 * Parameters:	sr	- (i) start state of the NFA.
 * Returns:	The initial state of the resulting DFA.
 * Globals:	states	- (i/o) number of states of NFA (i) and NFA+DFA (o);
 *		no_trans- (i/o) # of transitions of NFA (i) and NFA+DFA (o);
 *		subREs	- (i) subexpressions of REs in NFA;
 *		transitions
 *			- (i/o) transitions of NFA (i) and NFA+DFA (o).
 * Remarks:	Standard subset construction.
 *		Subsets of states are represented as vectors of state
 *		numbers. If ss is a subset, then ss[0] is the number of states
 *		in the subset, ss[1] is the first state in the subset,
 *		ss[2] -- the second one, and so on.
 */
int
determinize(const int sr) {
  int ii, i, j, f, q, current_state, final_state, s, ss, unique, equal;
  current_state = sr;
  int det_first_state = states++;
  int nfa_trans = no_trans;
  int *subsets[MAXSTATES];
  first_trans[det_first_state] = -1; /* no transitions yet */
  /* Allocate memory for the current subset */
  int *current_subset;
  if ((current_subset = (int *)malloc(sizeof(int) * states)) == NULL) {
    fprintf(stderr, "Not enough memory\n");
    exit(1);
  }
  /* Put the current state (the first state of the expression) into it */
  current_subset[0] =  1; current_subset[1] = current_state;
  ss = epsilon_closure(current_subset);
  if ((subsets[det_first_state] = (int *)malloc(sizeof(int)*(ss+1))) == NULL) {
    fprintf(stderr, "Not enough memory\n");
    exit(1);
  }
  /* Check whether the initial state is final */
  f = 0;
  subsets[det_first_state][0] = ss;
  for (ii = 1; ii <= ss; ii++) {
    subsets[det_first_state][ii] = current_subset[ii];
    if (final[current_subset[ii]]) {
      f = 1;
    }
  }
  final[det_first_state] = f;
  free(current_subset);

  for (j = det_first_state; j < states; j++) {
    for (i = 0; i < alphabet_size; i++) {
      current_subset = check_transition(subsets[j], alphabet[i]);
      /* See if current_subset is unique */
      unique = 1;
      for (s = det_first_state; s < states; s++) {
	if (current_subset[0] == subsets[s][0]) {
	  f = 0; equal = 1;
	  for (ss = 1; ss <= current_subset[0]; ss++) {
	    if (current_subset[ss] != subsets[s][ss]) {
	      equal = 0;
	      break;
	    }
	  }
	  if (equal) {
	    unique = 0;
	    break;
	  }
	}
      }
      if (current_subset[0]) {	/* if not empty */
	f = 0;
	if (unique) {
	  /* found new state */
	  for (ii = 1; ii <= current_subset[0]; ii++) {
	    if (final[current_subset[ii]]) {
	      f = 1;		/* it is a final state */
	    }
	  }
	  final[states] = f;	/* set finality */
	  transitions[no_trans].target = states;
	  subsets[states++] = current_subset; 
	}
	else {
	  transitions[no_trans].target = s; /* existing state s */
	}
	transitions[no_trans].source = j;
	transitions[no_trans].label = alphabet[i];
	transitions[no_trans].next = -1;
	if (first_trans[j] == -1) {
	  first_trans[j] = no_trans;
	}
	else {
	  /* Previous transition for the state is right below */
	  transitions[no_trans - 1].next = no_trans;
	}
	no_trans++;
      }
    }
  }
  for (ii = det_first_state; ii < states; ii++) {
    free(subsets[ii]);
  }
  return det_first_state;
}//determinize


/* Name:	check_transition
 * Purpose:	Constructs a subset of NFA states (a DFA state) reached
 *		from a DFA state by following transitions labelled with
 *		a particular symbol from any of its constituent states,
 *		and then computing epsilon closure.
 * Parameters:	sset		- (i) source DFA state (set of NFA states);
 *		symbol		- (i) current symbol.
 * Returns:	A set of NFA states forming a DFA state - target of
 *		a transition labelled with the given symbol.
 * Globals:	transitions	- (i) transitions of NFA, DFA and minimal DFA.
 * Remarks:	We check what should be the target of a transition labelled
 *		with the given symbol and going from a DFA state
 *		that is equivalent to a set of NFA states contained
 *		in sset. The target DFA state is also a set of NFA states
 *		that are targets of all transitions from any of the NFA states
 *		in sset labelled with with the given symbol. Epsilon closure
 *		is computed on the resulting set, so that states reachable
 *		via epsilon-transitions are also included.
 *
 *		A set of states is represented in a vector, where the 0th item
 *		is the set size.
 */
int *
check_transition(const int *sset, const int symbol) {
  int i, j, k, t, state_no;
  int *result;
  int current_set[MAXSTATES];
  current_set[0] = 0;
  for (k = 1; k <= sset[0]; k++) { /* for all states in the source DFA state  */
    state_no = sset[k];		   /* current source NFA state */
    if ((t = first_trans[state_no]) != -1) {
      do {
	if (transitions[t].label == symbol) {
	  add_to_set(current_set, transitions[t].target);
	}
	t = transitions[t].next;
      } while (t != -1);
    }
  }
  epsilon_closure(current_set);

  /* Create a copy of current set to be returned */
  if ((result = malloc(sizeof(int) * (current_set[0] + 1))) == NULL) {
    fprintf(stderr, "Not enough memory\n");
    exit(1);
  }
  for (j = 0; j <= current_set[0]; j++) {
    result[j] = current_set[j];
  }
  return result;
}//check_transition


/* Name:	epsilon_closure
 * Purpose:	Calculates epsilon closure of a set of NFA states.
 * Parameters:	current_set	- (i/o) set of NFA states.
 * Returns:	Number of states in the epsilon closure of current_set.
 * Globals:	transitions	- (i) transitions of NFA, DFA and minimal DFA.
 * Remarks:	current_set is sorted.
 *		A set of states is represented in a vector, where the 0th item
 *		is the set size.
 *		Since current_set is sorted, and we add items to it
 *		while keeping it sorted, and we process every state in it
 *		by moving an index inside the set, we need to keep an unsorted
 *		copy in queue.
 *		The epsilon closure is returned in the current_set.
 */
int
epsilon_closure(int *current_set) {
  int result = current_set[0];	/* number of states in the closure */
  int queue[MAXSTATES];
  int i, t;
  /* Create a queue of states to be processed (a copy of current_set) */
  for (i = 0; i < result; i++) {
    queue[i] = current_set[i + 1];
  }
  for (i = 0; i < result; i++) { /* for every state in the current_set */
    if ((t = first_trans[queue[i]]) != -1) {
      do {			/* for every transition of the state */
	if (transitions[t].label == EPSILON) {
	  if (add_to_set(current_set, transitions[t].target)) {
	    queue[result++] = transitions[t].target;
	  }
	}
	t = transitions[t].next;
      } while (t != -1);
    }
  }
  return result;
}//epsilon_closure

/* Name:	get_target_block
 * Purpose:	Gets the block number of a DFA state reachable from
 *		state state_no+first via transition labelled with "a".
 * Parameters:	state_no	- (i) source DFA state;
 *		first		- (i) first DFA state number;
 *		in_block	- (i) translates state numbers to blocks;
 *		a		- (i) transition label;
 *		trans_start	- (i) first transition numbers for states.
 * Returns:	Block number for the target state of a transition leading
 *		from state state_no+first with label "a", or -1 if no such
 *		transition exists.
 * Globals:	transitions	- (i) transitions of NFA, DFA and minimal DFA.
 */
int
get_target_block(const int state_no, const int first, const int *in_block,
		 const int a, const int *trans_start) {
  int rs = state_no + first;
  int last_trans = trans_start[state_no + 1];
  int target_state = -1;
  int t;
  for (t = trans_start[state_no]; t < last_trans; t++) {
    if (transitions[t].source == rs && transitions[t].label == a) {
      target_state = transitions[t].target;
      break;
    }
  }
  return (target_state == -1 ? -1 : in_block[target_state - first]);
}//get_target_block

/* Name:	Minimize
 * Purpose:	Minimizes a DFA.
 * Parameters:	dfa_first_state	- (i) state number of the first state
 *					of the DFA;
 *		dfa_last_state	- (i) highest state number for the DFA;
 *		dfa_first_trans	- (i) first transition number of the DFA;
 *		dfa_last_trans	- (i) highest transition number of the DFA.
 * Returns:	The initial state of the resulting minimal DFA.
 * Remarks:	It is assumed that the first DFA state is the start state,
 *		and that the DFA transitions are sorted on the source state.
 *		Minimization algorithm from Aho, Sethi, and Ullman.
 */
int
minimize(const int dfa_first_state, const int dfa_last_state,
	 const int dfa_first_trans, const int dfa_last_trans) {
  int i, f, b, a, tb, nb, state_no, prev_state, prev_block, next_state, blocks;
  int min_states = dfa_last_state - dfa_first_state + 1;
  int split, ncb, new_block, t;
  /* sizes of each block */
  int *block_size = (int *)malloc(min_states * sizeof(int));
  if (block_size == NULL) {
    fprintf(stderr, "Nor enough memory\n");
    exit(1);
  }
  block_size[0] = block_size[1] = 0; /* initially empty */
  /* next[s1]=s2 if state s2+dfa_first_state is the next state in its block
     after state s1+dfa_first_state */
  int *next = (int *)malloc(min_states * sizeof(int));
  if (next == NULL) {
    fprintf(stderr, "Nor enough memory\n");
    exit(1);
  }
  /* in_block[s]=b if state s+dfa_first_state is in block b */
  int *in_block = (int *)malloc(min_states * sizeof(int));
  if (in_block == NULL) {
    fprintf(stderr, "Nor enough memory\n");
    exit(1);
  }
  /* block_start[b] points to the beginning of a chain of states forming
     block b in the vector next */
  int *block_start = (int *)malloc(min_states * sizeof(int));
  if (block_start == NULL) {
    fprintf(stderr, "Nor enough memory\n");
    exit(1);
  }
  block_start[0] = block_start[1] = -1;
  int *trans_start = (int *)malloc((min_states + 1) * sizeof(int));
  if (trans_start == NULL) {
    fprintf(stderr, "Nor enough memory\n");
    exit(1);
  }
  /* set starting transitions for states */
  prev_state = -1;
  for (i = 0; i < min_states; i++) {
    trans_start[i] = -1;
  }
  for (t = dfa_first_trans; t <= dfa_last_trans; t++) {
    if (transitions[t].source != prev_state) {
      /* Note that this sets trans_start only for states that have outgoing
         transitions; all other states have -1 there! */
      trans_start[transitions[t].source - dfa_first_state] = t;
      prev_state = transitions[t].source;
    }
  }
  for (i = prev_state - dfa_first_state + 1; i <= min_states + 1; i++) {
    trans_start[i] = dfa_last_trans + 1;
  }
  for (i = min_states - 1; i >= 0; --i) {
    if (trans_start[i] == -1) {
      /* fix it for states without outgoing transitions
	 (it would be hard to do that earlier) */
      trans_start[i] = trans_start[i+1];
    }
  }
  
  /* split all states into two blocks containing final and non-final states */
  for (i = min_states - 1; i >= 0; --i) {
    f = 1 - final[i + dfa_first_state];
    next[i] = block_start[f];
    block_start[f] = i;
    block_size[f]++;
    in_block[i] = f;
  }
  blocks = 2;
  if (block_size[1] == 0) {
    /* delete empty block for non-final states */
    --blocks;
  }
  /* split blocks until no further division possible */
  do {
    split = 0;
    for (b = 0; b < blocks; b++) {
      if (block_size[b] > 1) {
	/* split block b */
	for (a = 0; a < alphabet_size; a++) {
	  prev_state = block_start[b];
	  prev_block = get_target_block(prev_state, dfa_first_state,
					in_block, alphabet[a], trans_start);
	  ncb = blocks;		/* mark newly created blocks */
	  for (state_no = next[prev_state]; state_no != -1;
	       state_no = next_state) {
	    next_state = next[state_no];
	    if ((tb = get_target_block(state_no, dfa_first_state, in_block,
				       alphabet[a], trans_start))
		!= prev_block) {
	      /* move the state to a different block */
	      split = 1;
	      /* find if there is already an appropriate block */
	      new_block = 1;
	      for (nb = ncb; nb < blocks; nb++) {
		if (tb == get_target_block(block_start[nb], dfa_first_state,
					   in_block, alphabet[a],
					   trans_start)) {
		  new_block = 0;
		  tb = nb;
		  block_size[tb]++;
		  break;
		}
	      }
	      if (new_block) {
		/* create new block */
		tb = blocks++;
		block_size[tb] = 1;
		block_start[tb] = -1;
	      }
	      /* move */
	      next[prev_state] = next[state_no]; /* omit in original block */
	      next[state_no] = block_start[tb];	/* prepend to block tb */
	      block_start[tb] = state_no;
	      in_block[state_no] = tb;
	      --block_size[b];
	    }
	    else {
	      prev_state = state_no;
	    }
	  }
	}
      }
    }
  } while (split);

  /* create the minimal automaton based on blocks */
  if (no_trans + b >= MAXTRANSITIONS) {
    fprintf(stderr, "No space for transitions. Increase MAXTRANSITIONS.\n");
    exit(2);
  }
  for (b = 0; b < blocks; b++) {
    for (a = 0; a < alphabet_size; a++) {
      if ((tb = get_target_block(block_start[b], dfa_first_state, in_block,
				 alphabet[a], trans_start)) != -1) {
	transitions[no_trans].source = b + dfa_last_state + 1;
	transitions[no_trans].target = tb + dfa_last_state + 1;
	transitions[no_trans].label = alphabet[a];
	no_trans++;
      }
    }
    final[b + dfa_last_state + 1] = final[block_start[b] + dfa_first_state];
    states++;
  }
  return in_block[0] + dfa_last_state + 1;
}//minimize

/* Name:	print_automaton_cluster
 * Purpose:	Prints one automaton: either NFA, DFA or minimal DFA.
 * Parameters:	start_state	- (i) smallest state number in the automaton;
 *		last_state	- (i) largest state number in the automaton;
 *		start_trans	- (i) smallest transition number in the
 *					automaton;
 *		last_trans	- (i) largest transition number in the
 *					automaton;
 *		initial_state	- (i) start state of the automaton;
 *		node_prefix	- (i) node name prefix;
 *		cluster_title	- (i) name of the automaton.
 * Returns:	Nothing.
 * Globals:	transitions	- (i) transitions of NFA, DFA and minimal DFA.
 * Remarks:	One automaton is printed as a cluster of a larger graph.
 *		Since states and transitions of different automata
 *		share the same data structures, state numbers are printed
 *		relative to the first state number belonging to the given
 *		automaton. Also, to distinguish among different automata,
 *		their states are named with different prefixes.
 */
void
print_automaton_cluster(const int start_state, const int last_state,
			const int start_trans, const int last_trans,
			const int initial_state,
			const char *node_prefix, const char *cluster_title) {
  int i, j;
  printf("\n  subgraph \"cluster%s\" {\n    color=blue;\n", node_prefix);
  /* print final states */
  for (i = start_state; i <= last_state; i++) {
    if (final[i]) {
      printf("    %s%d [shape=doublecircle];\n", node_prefix, i - start_state);
    }
  }
  /* create a dummy source for initial transition */
  printf("    %s [shape=plaintext, label=\"\"]; // dummy state\n",
	 node_prefix);
  /* create the initial transition */
  printf("    %s -> %s%d; // arc to the start state from nowhere\n",
	 node_prefix, node_prefix, initial_state - start_state);
  for (j = start_trans; j <= last_trans; j++) {
    if (transitions[j].label != EPSILON) {
      printf("    %s%d -> %s%d [label=\"%c\"];\n",
	     node_prefix, transitions[j].source - start_state,
	     node_prefix, transitions[j].target - start_state,
	     transitions[j].label);
    }
    else {
      printf("    %s%d -> %s%d [fontname=\"Symbol\", label=\"e\"];\n",
	     node_prefix, transitions[j].source - start_state,
	     node_prefix, transitions[j].target - start_state);
    }
  }
  printf("    label=\"%s\"\n  }\n", cluster_title);
}//print_automaton_cluster


/* Name:	print_automaton
 * Purpose:	Prints all versions of an automaton: an NFA, a DFA, and
 *		a minimal DFA.
 * Parameters:	nfa_states	- (i) number of states in the NFA;
 *		nfa_trans	- (i) number of transitions in the NFA;
 *		nfa_start	- (i) start state of NFA;
 *		dfa_states	- (i) number of states in the DFA;
 *		dfa_trans	- (i) number of transitions in the DFA;
 *		dfa_start	- (i) start state of DFA;
 *		min_states	- (i) number of states in the minimal DFA;
 *		min_trans	- (i) number of transitions in the minimal DFA;
 *		min_start	- (i) start state of minimal DFA.
 * Returns:	Nothing.
 * Globals:	None.
 * Remarks:	Versions of automata are printed as clusters in a larger
 *		graph.
 */
void
print_automaton(const int nfa_states, const int nfa_trans, const int nfa_start,
		const int dfa_states, const int dfa_trans, const int dfa_start,
		const int min_states, const int min_trans,
		const int min_start, const char *graph_title) {
  printf("digraph \"\\\"%s\\\"\" {\n  rankdir=LR;\n  node[shape=circle];\n",
	 graph_title);
  print_automaton_cluster(0, nfa_states - 1, 0, nfa_trans - 1, nfa_start,
			  "n", "NFA");
  print_automaton_cluster(nfa_states, dfa_states - 1, nfa_trans, dfa_trans - 1,
			  dfa_start, "d", "DFA");
  print_automaton_cluster(dfa_states, min_states - 1, dfa_trans, min_trans - 1,
			  min_start, "m", "min DFA");
  printf("}\n");
}//print_automaton

/* Name:	add_to_set
 * Purpose:	Adds an item (an int) to an ordered set.
 * Parameters:	set	- (i/o) the set to be augmented;
 *		item	- (i) the item to be added.
 * Returns:	1 if item added;
 *		0 if item already present in the set.
 * Globals:	None.
 * Remarks:	Sets are represented as ordered vectors of items (intergers)
 *		with the first item, i.e. set[0], being the size of the set.
 */
int
add_to_set(int *set, const int item) {
  int left, right, middle, found;
  left = 1; right = set[0]; found = 0;
  while (left <= right) {
    middle = (left + right) / 2;
    if (set[middle] == item) {
      found = 1;
      break;
    }
    else if (item < set[middle]) {
      right = middle - 1;
    }
    else {
      left = middle + 1;
    }
  }
  if (!found) {
    memmove(set + right + 2, set + right + 1, sizeof(int) * (set[0] - right));
    set[right + 1] = item;
    set[0]++;
    return 1;
  }
  return 0;
}

int
yyerror(char const *str) {
  fprintf(stderr, "%s\n", str);
  return 1;
}

int
main(const int argc, const char *argv) {
  int i;
  title_start = title;
  alphabet_size = 0;
  in_alphabet = (char *)malloc(256);
  if (in_alphabet == NULL) {
    fprintf(stderr, "Not enough memory\n");
    exit(1);
  }
  memset(in_alphabet, 0, 256);
  alphabet = (char *)malloc(256);
  if (alphabet == NULL) {
    fprintf(stderr, "Not enough memory\n");
    exit(1);
  }
  no_subREs = 0; states = 0; no_trans = 0;
  for (i = 0; i < states - 1; i++) {
    final[i] = 0;
  }
  yyparse();
  process_automaton(create_NFA());
  return 0;
}
