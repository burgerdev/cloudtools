# OCaml Cloud Tools

Taking lambda calculus to the cloud!

## Why?

OCaml is perfectly suited for cloud-native apps, think of Golang with a
real type system.

* high-level, multi-paradigm language for diverse applications
* compile statically to performant native code, run `FROM scratch`
* rich ecosystem with professional tooling

## How?

Everything you need is already there, free and open source. This library is just
a collection of tips, tricks and hacks to get you up to speed on your mission
to run OCaml in the cloud.

### Deploy Docker Image

OCaml is not really designed for running as process ID 1, but that is
fortunately easy to fix.

[examples/pid1.ml](examples/pid1.ml)

### Simple HTTP Server

[Cohttp](https://github.com/mirage/ocaml-cohttp) is a performant HTTP library
that leverages the power of 
[light-weight cooperative threads](http://ocsigen.org/lwt/).

[examples/http_server.ml](examples/http_server.ml)

## You're Hiding Something!

Yes, it's not perfect. Let's work on that. Things that I'm not aware of:

* [gRPC](https://grpc.io/docs/guides/) implementation
* [OpenTracing](http://opentracing.io/documentation/pages/api/api-implementations.html) library
* [Prometheus](https://prometheus.io/docs/instrumenting/writing_clientlibs/) metrics library
* [GELF](http://docs.graylog.org/en/latest/pages/gelf.html#gelf) logging (or similar)
