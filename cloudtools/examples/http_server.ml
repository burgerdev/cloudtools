open Cloudtools.Http
open Lwt

(* A simple HTTP handler that responds to every request with the canonical
   greeting message. *)
let hello_handler _conn _req _body =
  Cohttp_lwt_unix.Server.respond_string ~status:`OK ~body:"Hello world!\n" ()

(* The main method starts an HTTP server on localhost:8080 that greets the world
   when accessed as [http://localhost:8080/hello]. It responds with an errpr
   404 to all requests for a different path. *)
let _ =
  Lwt_main.run
  @@ Server.serve ("localhost", 8080)
  @@ Proxy.reverse_proxy_opt
  @@ fun request -> match Cohttp.Request.uri request |> Uri.path with
  | "/hello" -> Some hello_handler
  | _ -> None
