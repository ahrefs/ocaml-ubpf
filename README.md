OCaml bindings for the [Userspace eBPF VM](https://github.com/iovisor/ubpf).

uBPF is patched to [initialize R2 with data size](https://github.com/iovisor/ubpf/pull/22)
and [build with -fPIC](https://github.com/iovisor/ubpf/pull/23).

[Example usage](example.ml)

Use [OCaml eBPF assembler](https://github.com/ygrek/ocaml-bpf) to assemble raw bpf in OCaml code.
