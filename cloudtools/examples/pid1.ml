open Cloudtools.Docker

(* This example runs under supervision of [init]. It forks off an additional
   process that just falls asleep for a period of time and kills itself with a
   SIGTERM. Try running this example without [init] - the sleeping child process
   will not be signalled, thus stick around with new parent PID 1. Wrapped with
   [init], the process won't exit until all children are gone, and if you signal
   the process (by hitting Ctrl-C), child and parent will terminate as expected. *)
let _ = init @@ fun _ ->
  match Unix.fork () with
  | 0 -> Unix.sleep 1000; exit 0
  | _ ->
    Printf.printf "Committing suicide.\n";
    flush_all ();
    Unix.kill (Unix.getpid ()) Sys.sigterm; exit 0
