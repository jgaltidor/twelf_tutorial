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
Specifically, this package contains a Twelf encoding of
*Minilang*, a language of number and strings.
*Minilang* is defined in file
[`typetheory_paper.pdf`](typetheory_paper.pdf).

### Documentation
 * [`typetheory_paper.pdf`](typetheory_paper.pdf):
    Presents a type theory tutorial using *Minilang* as an
    example language for presenting concepts.
 * [`typetheory_slides.pdf`](typetheory_slides.pdf):
    Slide presentation of material in
    [`typetheory_paper.pdf`](typetheory_paper.pdf).
 * [`twelf_slides.pdf`](twelf_slides.pdf):
    More detailed slide presentation of Twelf and Twelf
    encoding of *Minilang*.

### Twelf Files
 * [`sources.cfg`](sources.cfg):
    Tells Twelf the files to read and the order in which to process them.
 * [`syntax.elf`](syntax.elf):
    Twelf encoding of *Minilang*'s syntax.
 * [`typing.elf`](typing.elf):
    Twelf encoding of *Minilang*'s typing rules or static semantics.
 * [`evaluation.elf`](evaluation.elf):
    Twelf encoding of *Minilang*'s evaluation rules or dynamic semantics.
 * [`preservation.elf`](preservation.elf):
    Contains the preservation theorem and its proof.
 * [`progress.elf`](progress.elf):
    Contains the progress theorem and its proof.
 * [`test_typing.elf`](test_typing.elf):
    Provides example judgments that can be automatically derived by Twelf.


Twelf Live Server
------------------
The Twelf system can be used without installing it on
your local machine by using the
[Twelf Live Server][twelf_server].


[twelf]: http://twelf.org/wiki/Main_Page
[hoas]: http://twelf.org/wiki/Higher-order_abstract_syntax
[twelf_server]: http://twelf.org/live/
