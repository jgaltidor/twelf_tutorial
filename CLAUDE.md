# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A tutorial on Twelf and type theory: a Twelf (LF) encoding of *MiniLang*, a small language of numbers and strings, together with machine-checked proofs of type safety (preservation and progress). The slides live in separate repos (github.com/jgaltidor/typetheory_slides and github.com/jgaltidor/twelf_slides; locally `~/Documents/mywork/repos/typetheory_slides` and `.../twelf_slides`), which publish `typetheory_slides.pdf` and `twelf_slides.pdf` as GitHub Release assets; the README links to their latest releases. The paper itself lives in a separate repo (github.com/jgaltidor/typetheory_paper), which publishes `typetheory_paper.pdf` as a GitHub Release asset; the README links to the latest release rather than keeping a copy here.

## Checking the proofs

There is no build system; "building" means having Twelf typecheck the files. `./check.sh` does it all and exits non-zero if Twelf rejects anything. Twelf isn't installed on the host; use the pinned image in `Dockerfile` (Twelf built from a pinned commit with MLton, `linux/amd64` only because MLton has no Linux arm64 build), or the devcontainer, which uses the same image:

```sh
docker build --platform linux/amd64 -t twelf-tutorial .
docker run --rm --platform linux/amd64 -v "$PWD":/workdir twelf-tutorial   # runs ./check.sh
```

Build and run with the same `--platform` flag; with Docker's containerd image store, an image built without it can't be run with `--platform linux/amd64`.

Interactively, from `twelf-server` in the repo root:

```
make sources.cfg          % load and check all core files in order
loadFile test_typing.elf  % optional: example derivations (%solve)
loadFile progress_testing.elf
loadFile let_testing.elf
```

`sources.cfg` sets the load order: `syntax.elf` → `typing.elf` → `evaluation.elf` → `preservation.elf` → `progress.elf`. Each file depends on the ones before it. The three test files are deliberately left out of `sources.cfg` and must be loaded after it. Keep `test_typing.elf` unchanged: the paper and `twelf_slides` quote its Twelf output. New examples go in another test file, as the `let` examples do in `let_testing.elf`.

`exercises/numsubtype/` holds the subtyping exercise from the "More Exercises" slide of `twelf_slides` (starter and solution). It is self-contained and declares its own `typ`, `num`, `of`, etc., which clash with MiniLang's, so `check.sh` loads each exercise file after `reset`; load it the same way interactively. Its `sources.cfg` lists only the starter, for students using the extension's "Load configuration". These files moved here in October 2026 from the home page repo (jgaltidor.github.io), which no longer hosts them.

A file "passes" when every `%worlds`/`%total` declaration is accepted. That is how Twelf checks that a relation is a total function (and so a valid proof of a ∀∃ theorem).

## Architecture of the encoding

- **Syntax** (`syntax.elf`): `exp`, `typ`, `nat`, `str` (with infix `,` for char-cons). Values are wrapped into expressions with `enat`/`estr`. `let` uses higher-order abstract syntax (`let : exp -> (exp -> exp) -> exp`), so there are no explicit variables or substitution. Substitution is meta-level application (`E2 E1` in `step/letV`).
- **Static semantics** (`typing.elf`): judgment `of E T`. The `of/let` premise is hypothetical (`{x:exp} of x T1 -> of (E2 x) T2`), which is why `of-block` is declared for its worlds.
- **Dynamic semantics** (`evaluation.elf`): small-step `step E E'` with left-to-right eager evaluation, plus `value`. Primitive operations are the relations `cadd`/`ccat`/`clen`. Their `*-total` lemmas (`cadd-total`, etc.) exist so that progress can *produce* a derivation for given inputs.
- **Theorems** are type families whose `%mode` marks inputs (∀) and outputs (∃). Each `- :` clause is one proof case, `<-` premises are inductive calls or lemmas, and `%total` checks coverage and termination.
  - `preservation.elf`: `preservation : of E T -> step E E' -> of E' T -> type`, by induction on the typing derivation.
  - `progress.elf`: `progress : of E T -> not_stuck E -> type`. Nested case analysis on sub-results uses separate "output factoring" lemmas (`progress-add`, `progress-cat`, `progress-len`, `progress-let`), because Twelf can't case-split on an output inside one clause.

Adding a new expression form means touching every layer: a constructor in `syntax.elf`, an `of/*` rule, `step/*` rules (and a primitive relation with a `-total` lemma if needed), a preservation case for each step rule, and a progress case (usually with a new factoring lemma). The `%total` checks will report any missing case.

## Conventions

- Derivation variables are named after what they prove, e.g. `E1-num : of E1 num`, `E1~>E1' : step E1 E1'`, `N1+N2=N3 : cadd ...`.
- Commented-out blocks (`%{ ... }%`) in `preservation.elf` and the `%prove` lines are intentional teaching material (an explicitly typed version of a case, a deliberately invalid proof, and Twelf's automated prover failing on progress). Keep them.
- The paper (github.com/jgaltidor/typetheory_paper; locally `~/Documents/mywork/repos/typetheory_paper`) cites line numbers and quotes code and Twelf output from these files as of tag `v1.0`. Edits on `master` don't break those citations, but if an edit moves cited lines or changes quoted code, the paper must be updated, a new tag created here, and the paper's citation and links pointed at it. The paper's `CLAUDE.md` lists every cited line.
- The README's "Quick start" quotes Twelf output (a `readDecl` query result, and the coverage error at `preservation.elf:99.8` from deleting the `step/letV` preservation case). It was generated with the Docker image on 2026-10-05; if a change alters it, regenerate it (on a scratch copy for the broken-proof example) rather than editing it by hand.
- Never write Twelf output by hand for the paper; generate it with `./check.sh` in the Docker image.
- Don't add copies of the paper or slide PDFs here; link to the latest releases of typetheory_paper, typetheory_slides, and twelf_slides instead.
- The slides were checked against the paper and this code on 2026-10-03 (every Twelf output and error they quote was checked against current Twelf; some is line-wrapped by hand to fit a slide). If a change here moves lines or alters code or output that the slides quote (e.g., the coverage error at `preservation.elf:98.8`, or the world violation at `syntax.elf:36.15`), update the slide sources and publish a new release of that slide repo. The README says the paper is authoritative where the slides differ.
- The devcontainer installs the Twelf Extension Pack (`ivan-m.twelf-extension-pack`: `.elf` highlighting and commands that run `twelf-server`, which must be on the `PATH`, as it is in the image). Its publisher has no public source repository; its code was reviewed on 2026-10-02 (it only uses the VS Code API and spawns `twelf-server`, with no network access). Don't also install `yaene.twelf-lang`: both register the `twelf` language for `.elf` files. Its "Run current file" sends only `loadFile <file>`, so files that depend on earlier ones fail with "Undeclared identifier" unless "Load configuration" (`Config.read sources.cfg` + `Config.load`) has been run first in the same server session. Its buttons appear in the editor title bar only while a `.cfg` or `.elf` file is the active editor, and the devcontainer opens with no file open, so the README walks new users through it: open `sources.cfg` and choose "Load configuration" from the **ELF ▾** dropdown button (which loads the open `.cfg`; the Load configuration button on an `.elf` file opens a file picker instead), then use the play button ("Run current file", Ctrl+Enter) on individual files. This is the intended workflow, the same as Twelf's Emacs mode (C-c C-c to load the config, then C-c C-s per file), not a bug: Twelf files have no imports.
- `.vscode/tasks.json` defines the default build task "Twelf: check all proofs", which runs `./check.sh` (core files, test files, exercises) with a problem matcher for Twelf's `file:line.col-line.col Error:` lines (message on the following line). Prefer it over the extension's commands, whose server keeps state between runs; the task runs its own server and loads nothing into the extension's.
- CI (`.github/workflows/check.yml`) builds the Docker image and runs `./check.sh` on every push and pull request. Dependabot (`.github/dependabot.yml`) opens monthly pull requests to bump the SHA-pinned GitHub Actions.
