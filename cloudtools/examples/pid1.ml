open Cloudtools.Docker

let _ = init @@ fun _ ->
  Printf.printf "Hello, fork\n";
  flush_all ();
  match Unix.fork () with
  | 0 ->
    Unix.sleep 1000; exit 0
  | _ -> Unix.sleep 1000; exit 0
