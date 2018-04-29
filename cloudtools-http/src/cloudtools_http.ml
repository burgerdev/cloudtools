open Lwt

type http_handler =
  Cohttp_lwt_unix.Server.conn ->
  Cohttp.Request.t ->
  Cohttp_lwt.Body.t ->
  (Cohttp.Response.t * Cohttp_lwt.Body.t) Lwt.t

let not_found_handler _conn _req _body =
  Cohttp_lwt_unix.Server.respond_not_found ()

let forbidden_handler _conn _req _body =
  Cohttp_lwt_unix.Server.respond_string ~status:`Forbidden ~body:"Forbidden.\n" ()

let reverse_proxy_opt f =
  fun conn req body -> match f req with
  | Some handler -> handler conn req body
  | None -> not_found_handler conn req body

let reverse_proxy f =
  fun conn req body -> (f req) conn req body

type address = string * int

let serve (src, port) callback =
  let mode = (`TCP (`Port port)) in
  Conduit_lwt_unix.init ~src () >>= fun ctx ->
  let ctx = Cohttp_lwt_unix.Net.init ~ctx () in
  Cohttp_lwt_unix.(Server.create ~ctx ~mode (Server.make ~callback ()))
