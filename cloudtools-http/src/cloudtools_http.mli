
module Handlers: sig
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

end

module Proxy: sig

  val reverse_proxy: (Cohttp.Request.t -> Handlers.http_handler) -> Handlers.http_handler
  (** [reverse_proxy delegate] delegates incoming requests to the handler returned
      by [delegate]. *)

  val reverse_proxy_opt: (Cohttp.Request.t -> Handlers.http_handler option) -> Handlers.http_handler
  (** [reverse_proxy_opt delegate_opt] delegates incoming requests to the handler
      returned by [delegate_opt]. If no handler is returned, [reverse_proxy_opt]
      responds with '404 Not Found'. *)

end

module Server: sig

  type address = string * int
  (** [address] is a TCP/IP bind address. *)

  (* TODO allow TLS *)
  val serve: address -> Handlers.http_handler -> unit Lwt.t
  (** [serve addr handler] establishes an HTTP server listening on [addr] that
      delegates requests to [handler]. *)

end
