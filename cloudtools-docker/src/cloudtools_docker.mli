
val exit_on_signal: (unit -> 'a) -> 'a
(** [exit_on_signal func] quits the program if it catches a SIGINT or SIGTERM. *)

val init: (unit -> unit) -> 'a
(** [init prog] runs the given function [prog] in a forked process. After
    forking, it keeps running and waits on all children that get assigned to it,
    thus reaping zombies caused by double-forks (e.g. [Unix.establish_server]).
    When [init] is signalled with SIGINT or SIGTERM, it forwards this signal to
    all children, but keeps running until all children are dead. *)
