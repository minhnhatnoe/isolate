# isolate

Isolate is a sandbox built to safely run untrusted executables, like
programs submitted by competitors in a programming contest. Isolate
gives them a limited-access environment, preventing them from affecting
the host system. It takes advantage of features specific to the Linux
kernel, like namespaces and control groups.

Isolate was developed by Martin Mareš (<mj@ucw.cz>) and Bernard Blackham
(<bernard@blackham.com.au>) and still maintained by the former author.
Several other people contributed patches for features and bug fixes
(see Git history for a list). Thanks!

Originally, Isolate was a part of the [Moe Contest Environment](http://www.ucw.cz/moe/),
but it evolved to a separate project used by different
contest systems, most prominently [CMS](https://github.com/cms-dev/cms).
It now lives at [GitHub](https://github.com/ioi/isolate),
where you can submit bug reports and feature requests.

If you are interested in more details, please read Martin's and Bernard's
papers on [Isolate's design](https://mj.ucw.cz/papers/isolate.pdf) and
[grading system security](https://mj.ucw.cz/papers/secgrad.pdf) published
in the Olympiads in Informatics journal.
Also, Isolate's [manual page](http://www.ucw.cz/moe/isolate.1.html)
is available online.

## Quick start

### Docker image

The fastest way to start is grabbing the pre-built docker image at `ghcr.io/minhnhatnoe/isolate:latest`, which can be used as a standalone image or a base image. The image includes:

- `isolate-cg-keeper`: Establish the Control Group subtree for running processes and future sandboxes. This should be started before running any `isolate` and `isolate-check-environment` commands. If `isolate-cg-keeper` is not the sole process at the root Control Group, execute this binary with `--move-cg-neighbors` to not violate [Control Group v2's No Internal Process Constraint](https://docs.kernel.org/admin-guide/cgroup-v2.html#no-internal-process-constraint).

To compile Isolate, you need:

- pkg-config
- headers for the libcap library (usually available in a libcap-dev package)
- headers for the libsystemd library (libsystemd-dev package) for compilation of isolate-cg-keeper

You may need `a2x` (found in [AsciiDoc](https://asciidoc-py.github.io/a2x.1.html)) for building manual.
But if you only want the isolate binary, you can just run `make isolate`

Recommended system setup is described in sections INSTALLATION and REPRODUCIBILITY
of the manual page.
