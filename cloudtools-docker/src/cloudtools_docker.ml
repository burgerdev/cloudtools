
let exit_on_signal f =
  let handle signo =
    exit 129
  in
  List.iter (fun signo -> Sys.(set_signal signo (Signal_handle handle) )) Sys.[sigint; sigterm];
  f ()

let reap_loop () =
  let rec reap () =
    try
      ignore (Unix.wait ());
      reap ()
    with
    | Unix.(Unix_error (EINTR, _, _)) -> reap ()
    | Unix.(Unix_error (ECHILD, _, _)) -> ()
  in reap()

(* Send signal to process, ignore occasional errors. *)
let kill ~pid ~signo () =
  try
    Unix.kill pid signo
  with
  | Unix.Unix_error (_, _, _) -> ()

let init p =
  match Unix.fork () with
  | 0 ->
    ignore (Unix.setsid ());
    p ();
    exit 0
  | child ->
    let pid = -child in
    let handle signo =
      let old = Sys.(signal signo Signal_ignore) in
      kill ~pid ~signo ();
      Sys.(set_signal signo old)
    in
    List.iter (fun signo -> Sys.(set_signal signo (Signal_handle handle) )) Sys.[sigint; sigterm];
    reap_loop ();
    ignore Sys.(signal sigterm Signal_ignore);
    kill ~pid ~signo:Sys.sigterm ();
    exit 0
