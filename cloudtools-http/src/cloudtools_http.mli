
type http_handler =
  Cohttp_lwt_unix.Server.conn ->
  Cohttp.Request.t ->
  Cohttp_lwt.Body.t ->
  (Cohttp.Response.t * Cohttp_lwt.Body.t) Lwt.t
(** [http_handler] handles HTTP requests. *)

val not_found_handler: http_handler
(** [not_found_handler] answers '404 Not Found' to all incoming requests. *)

val forbidden_handler: http_handler
(** [forbidden_handler] answers '403 Forbidden' to all incoming requests. *)

val reverse_proxy: (Cohttp.Request.t -> http_handler) -> http_handler
(** [reverse_proxy delegate] delegates incoming requests to the handler returned
    by [delegate]. *)

val reverse_proxy_opt: (Cohttp.Request.t -> http_handler option) -> http_handler
(** [reverse_proxy_opt delegate_opt] delegates incoming requests to the handler
    returned by [delegate_opt]. If no handler is returned, [reverse_proxy_opt]
    responds with '404 Not Found'. *)

type address = string * int
(** [address] is a TCP/IP bind address. *)

(* TODO allow TLS *)
val serve: address -> http_handler -> unit Lwt.t
(** [serve addr handler] establishes an HTTP server listening on [addr] that
    delegates requests to [handler]. *)
