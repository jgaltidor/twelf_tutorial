# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A tutorial on Twelf and type theory: a Twelf (LF) encoding of *MiniLang*, a small language of numbers and strings, together with machine-checked proofs of type safety (preservation and progress). The slide PDFs (`typetheory_slides.pdf`, `twelf_slides.pdf`) are prebuilt; don't try to rebuild or edit them here. The paper itself lives in a separate repo (github.com/jgaltidor/typetheory_paper), which publishes `typetheory_paper.pdf` as a GitHub Release asset; the README links to the latest release rather than keeping a copy here.

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
```

`sources.cfg` sets the load order: `syntax.elf` → `typing.elf` → `evaluation.elf` → `preservation.elf` → `progress.elf`. Each file depends on the ones before it. The two test files are deliberately left out of `sources.cfg` and must be loaded after it.

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
- The paper (github.com/jgaltidor/typetheory_paper; locally `~/Documents/mywork/projects/writing/typetheory_paper_prj/typetheory_paper`) cites line numbers and quotes code and Twelf output from these files as of tag `v1.0`. Edits on `master` don't break those citations, but if an edit moves cited lines or changes quoted code, the paper must be updated, a new tag created here, and the paper's citation and links pointed at it. The paper's `CLAUDE.md` lists every cited line.
- Never write Twelf output by hand for the paper; generate it with `./check.sh` in the Docker image.
- Don't add a copy of the paper PDF here; link to the latest release of typetheory_paper instead.
- The slide PDFs (2013 and 2015) predate later corrections to the paper and are known to be stale in places (e.g., `twelf_slides.pdf` quotes the coverage error at `preservation.elf:69.8` instead of `98.8`, and links to the defunct Twelf Live Server at `twelf.org/live/`). Their sources aren't in this repo, so they can't be regenerated here; the README says the paper is authoritative.
- CI (`.github/workflows/check.yml`) builds the Docker image and runs `./check.sh` on every push and pull request.
