(*
  Build as:

  ocamlfind ocamlopt -linkpkg -package ubpf example.ml -o example.exe

  or in toplevel:

  #require "ubpf";;
  #use "example.ml";;
*)

open Printf

let with_bpf bpf k =
  let open Ubpf in
  let vm = compile (`Bpf bpf) in
  try
    let () = k (exec vm) in
    release vm
  with exn ->
    release vm;
    raise exn

(*
  the following eBPF program returns 1 if the first byte of data is \001 or \002
  EBPF.assemble [
    jmpi `False R2 `EQ 0;
    ldx B R3 (R1,0);
    jmpi `True R3 `EQ 2;
    jmpi `True R3 `EQ 1;
    jump `False;
  label `True;
    movi R0 1;
    ret;
  label `False;
    movi R0 0;
    ret;
  ]
*)
let raw_bpf = "\
\x15\x02\x06\x00\x00\x00\x00\x00\
\x71\x13\x00\x00\x00\x00\x00\x00\
\x15\x03\x02\x00\x02\x00\x00\x00\
\x15\x03\x01\x00\x01\x00\x00\x00\
\x05\x00\x02\x00\x00\x00\x00\x00\
\xb7\x00\x00\x00\x01\x00\x00\x00\
\x95\x00\x00\x00\x00\x00\x00\x00\
\xb7\x00\x00\x00\x00\x00\x00\x00\
\x95\x00\x00\x00\x00\x00\x00\x00"

let () =
  with_bpf raw_bpf begin fun exec ->
    List.iter (fun input -> printf "%d\n" (exec input)) ["\000";"\001";"\002";"\003"]
  end
