Twelf Tutorial
===============

Background
----------
[Twelf][twelf] is a proof assistant tool for checking and deriving proofs of
mathematical properties.
The Twelf system provides useful software features,
such as [higher-order abstract syntax][hoas], for reasoning
about formal languages and deductive logics.

Contents
---------
This package is a tutorial on Twelf and type theory.
Concepts are presented using a *Twelf encoding* of
programming language *MiniLang*.
*MiniLang* is a language of numbers and strings
that is rigorously defined in the paper
[`typetheory_paper.pdf`][paper_pdf].
The paper, its LaTeX source, and its released PDFs are in the
[typetheory_paper][paper_repo] repository.
Line numbers that the paper cites in the Twelf files
refer to tag [`v1.0`][v1.0] of this repository.

### Documentation
 * [`typetheory_paper.pdf`][paper_pdf] (latest release of the paper):
    Presents a type theory tutorial using *MiniLang* as an
    example language for presenting concepts.
 * [`typetheory_slides.pdf`](typetheory_slides.pdf):
    Slide presentation of material in
    [`typetheory_paper.pdf`][paper_pdf].
 * [`twelf_slides.pdf`](twelf_slides.pdf):
    More detailed slide presentation of Twelf and Twelf
    encoding of *MiniLang*.

### Twelf Files
 * [`sources.cfg`](sources.cfg):
    Tells Twelf the files to read and the order in which to process them.
 * [`syntax.elf`](syntax.elf):
    Twelf encoding of *MiniLang*'s syntax.
 * [`typing.elf`](typing.elf):
    Twelf encoding of *MiniLang*'s typing rules or static semantics.
 * [`evaluation.elf`](evaluation.elf):
    Twelf encoding of *MiniLang*'s evaluation rules or dynamic semantics.
 * [`preservation.elf`](preservation.elf):
    Contains the preservation theorem and its proof.
 * [`progress.elf`](progress.elf):
    Contains the progress theorem and its proof.
 * [`test_typing.elf`](test_typing.elf):
    Provides example judgments that can be automatically derived by Twelf.
 * [`progress_testing.elf`](progress_testing.elf):
    Provides example queries that evaluate an expression and
    apply the progress proof.

The two test files are not listed in `sources.cfg`;
load them after the files in `sources.cfg` have been loaded.


Running Twelf
-------------
The Twelf Live Server that previously let you run Twelf
in a web browser is no longer available.
The easiest way to check the proofs is with the pinned
toolchain in [`Dockerfile`](Dockerfile), which builds Twelf
from source with MLton:

```sh
docker build --platform linux/amd64 -t twelf-tutorial .
docker run --rm --platform linux/amd64 -v "$PWD":/workdir twelf-tutorial
```

This runs [`check.sh`](check.sh), which loads `sources.cfg` and both
test files and prints `twelf-check: all files OK` if Twelf accepts
everything.
MLton has no Linux arm64 build, so the image is always `linux/amd64`;
on Apple Silicon, Docker Desktop runs it under emulation.
The [`.devcontainer/`](.devcontainer) folder opens the same image in
VS Code, with `twelf-server` on the `PATH`.
It also installs Claude Code (the VS Code extension and the `claude` CLI),
whose login and settings persist in a Docker volume.

To install Twelf directly instead, follow the
instructions on the [Twelf download page][twelf_download].


[twelf]: https://twelf.org/
[hoas]: https://twelf.org/wiki/higher-order-abstract-syntax/
[twelf_download]: https://twelf.org/download/
[paper_repo]: https://github.com/jgaltidor/typetheory_paper
[paper_pdf]: https://github.com/jgaltidor/typetheory_paper/releases/latest/download/typetheory_paper.pdf
[v1.0]: https://github.com/jgaltidor/twelf_tutorial/tree/v1.0
