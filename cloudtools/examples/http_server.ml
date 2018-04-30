open Cloudtools.Http
open Lwt

let hello_handler _conn _req _body =
  Cohttp_lwt_unix.Server.respond_string ~status:`OK ~body:"Hello world!\n" ()

let _ =
  Lwt_main.run
  @@ Server.serve ("localhost", 8080)
  @@ Proxy.reverse_proxy_opt
  @@ fun r -> match Cohttp.Request.uri r |> Uri.path with
  | "/echo" -> Some hello_handler
  | _ -> None
