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
 * [`typetheory_slides.pdf`][tt_slides_pdf] (latest release):
    Slide presentation of material in
    [`typetheory_paper.pdf`][paper_pdf].
    Its LaTeX source is in the [typetheory_slides][tt_slides_repo] repository.
 * [`twelf_slides.pdf`][twelf_slides_pdf] (latest release):
    More detailed slide presentation of Twelf and Twelf
    encoding of *MiniLang*.
    Its LaTeX source is in the [twelf_slides][twelf_slides_repo] repository.

The slides were first written in 2013 (`typetheory_slides.pdf`) and
2014–2016 (`twelf_slides.pdf`), and corrected in October 2026 to match
the paper and the Twelf files. Where the slides and the paper differ,
the paper is authoritative.

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
GitHub Actions runs the same check on every push and pull request
([`.github/workflows/check.yml`](.github/workflows/check.yml)).
MLton has no Linux arm64 build, so the image is always `linux/amd64`;
on Apple Silicon, Docker Desktop runs it under emulation.
The [`.devcontainer/`](.devcontainer) folder opens the same image in
VS Code, with `twelf-server` on the `PATH`.
It also installs Claude Code (the VS Code extension and the `claude` CLI),
whose login and settings persist in a Docker volume, the
[Twelf Extension Pack](https://marketplace.visualstudio.com/items?itemName=ivan-m.twelf-extension-pack)
(syntax highlighting for `.elf` files, plus commands to run `twelf-server`
on the current file or `sources.cfg`, with errors shown in the Problems tab),
and the GitHub Actions extension for editing the CI workflow.

The simplest way to check every proof from VS Code is the build task
**Twelf: check all proofs** (<kbd>Cmd</kbd>/<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>B</kbd>),
defined in [`.vscode/tasks.json`](.vscode/tasks.json). It runs `check.sh`
in a fresh `twelf-server` and lists any Twelf errors in the Problems tab,
linked to their location in the source.

The extension's commands talk to a single `twelf-server` that keeps its state
between commands; it is separate from the one the build task starts, so running
the build task loads nothing into it.
Twelf files have no import mechanism: a file can only use what is already
loaded in the server. So, as in Twelf's own
[Emacs mode](https://twelf.org/wiki/twelf-with-emacs/)
("load your entire project … when you start working"), use the extension like this:

1. When you start working, run **Twelf: Load configuration** (the button next
   to the play button in the editor toolbar) and choose `sources.cfg`. This loads
   and checks all the core files in order.
2. Then use **Twelf: Run current file** (the play button) to reload the file you
   are editing, including the two test files.

Pressing the play button without step 1 fails with "Undeclared identifier"
errors for any file that depends on earlier ones, such as `preservation.elf`.

To install Twelf directly instead, follow the
instructions on the [Twelf download page][twelf_download].


[twelf]: https://twelf.org/
[hoas]: https://twelf.org/wiki/higher-order-abstract-syntax/
[twelf_download]: https://twelf.org/download/
[paper_repo]: https://github.com/jgaltidor/typetheory_paper
[paper_pdf]: https://github.com/jgaltidor/typetheory_paper/releases/latest/download/typetheory_paper.pdf
[v1.0]: https://github.com/jgaltidor/twelf_tutorial/tree/v1.0
[tt_slides_repo]: https://github.com/jgaltidor/typetheory_slides
[twelf_slides_repo]: https://github.com/jgaltidor/twelf_slides
[tt_slides_pdf]: https://github.com/jgaltidor/typetheory_slides/releases/latest/download/typetheory_slides.pdf
[twelf_slides_pdf]: https://github.com/jgaltidor/twelf_slides/releases/latest/download/twelf_slides.pdf
