
(* $Id$ *)

(*i*)
open Pp
open Pcoq
(*i*)

(* Parsing. *)

type nonterm =
  | NtShort of string
  | NtQual of string * string

val qualified_nterm : (string * gram_universe) -> nonterm ->
  (string * gram_universe) * string

type prod_item =
  | Term of Token.pattern
  | NonTerm of nonterm * entry_type * string option

type grammar_rule = { 
  gr_name : string; 
  gr_production : prod_item list; 
  gr_action : Ast.act }

type grammar_entry = { 
  ge_name : string;
  ge_type : entry_type;
  gl_assoc : Gramext.g_assoc option;
  gl_rules : grammar_rule list }

type grammar_command = { 
  gc_univ : string; 
  gc_entries : grammar_entry list }

val gram_assoc: Coqast.t -> Gramext.g_assoc option
val gram_of_ast: string -> Coqast.t list -> grammar_command


(*s Pretty-print. *)

(* Dealing with precedences *)

type precedence = int * int * int

type parenRelation = L | E | Any

(* Checks if the precedence of the parent printer (None means the
   highest precedence), and the child's one, follow the given
   relation. *)

val tolerable_prec : ((string * precedence) * parenRelation) option ->
  (string * precedence) -> bool

val prec_of_ast : Coqast.t -> precedence

(* unparsing objects *)

type ppbox =
  | PpHB of int
  | PpHOVB of int
  | PpHVB of int
  | PpVB of int
  | PpTB

type unparsing_hunk = 
  | PH of Ast.pat * string option * parenRelation
  | RO of string
  | UNP_BOX of ppbox * unparsing_hunk list
  | UNP_BRK of int * int
  | UNP_TBRK of int * int
  | UNP_TAB
  | UNP_FNL

val ppcmd_of_box : ppbox -> std_ppcmds -> std_ppcmds

val unparsing_of_ast : Ast.entry_env -> Coqast.t -> unparsing_hunk list

type syntax_entry = {
  syn_id : string;
  syn_prec: precedence;
  syn_astpat : Ast.pat;
  syn_hunks : unparsing_hunk list }

val rule_of_ast : string -> precedence -> Coqast.t -> syntax_entry

val level_of_ast : string -> Coqast.t -> syntax_entry list


