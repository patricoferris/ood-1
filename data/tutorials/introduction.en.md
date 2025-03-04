---
title: A First Hour with OCaml
description: >
  Discover the OCaml programming language in this longer tutorial that takes you
  from absolute beginner to someone who is able to write programs in OCaml.
users:
  - beginner
date: 2021-04-28T21:50:24.228Z
---
You may follow along with this tutorial with just a basic OCaml installation,
as described in [Up and Running](up_and_running.html).

Alternatively, you may follow almost all of it by running OCaml in your browser
using [TryOCaml](http://try.ocamlpro.com), with no installation required!!!

## Running OCaml code

The easiest way to get started is to run an interactive session in
your browser thanks to [TryOCaml](http://try.ocamlpro.com).

To install OCaml on your computer, see the [Install](/docs/install.html) documentation.

To quickly try small OCaml expressions, you can use an interactive
toplevel, or REPL (Read–Eval–Print Loop). The `ocaml` command provides
a very basic toplevel (you should install `rlwrap` through your system
package manager and run `rlwrap ocaml` to get history navigation).

The recommended alternative REPL [utop](https://github.com/diml/utop) may be
installed through [OPAM](/docs/install.html#OPAM) or your system package
manager. It has the same basic interface but is much more convenient to use
(history navigation, auto-completion, etc.).

Use `;;` to indicate that you've finished entering each expression and prompt OCaml to evaluate it. Here is what running `ocaml` looks like:

```console
$ ocaml
        OCaml version OCaml version 4.12.0

# 1 + 1;;
- : int = 2
```

This is how running the same code looks when using `utop`:

```console
───────┬─────────────────────────────────────────────────────────────┬────
       │ Welcome to utop version 2.7.0 (using OCaml version 4.12.0)! │     
       └─────────────────────────────────────────────────────────────┘     

Type #utop_help for help about using utop.

─( 10:12:16 )─< command 0 >───────────────────────────────────────────────
utop # 1 + 1;;
- : int = 2
```

## Comments

OCaml comments are delimited by `(*` and `*)`, like this:

```ocaml
(* This is a single-line comment. *)

(* This is a
   multi-line
   comment.
*)
```

In other words, the commenting convention is very similar to original C
(`/* ... */`). There is no single-line comment syntax (like
`# ...` in Python or `// ...` in C99/C++/Java).

OCaml counts nested `(* ... *)` blocks, and this allows you to comment
out regions of code very easily:

```ocaml
(* This code is broken ...

(* Primality test. *)
let is_prime n =
  (* note to self: ask about this on the mailing lists *) XXX

*)
```

## Calling functions

Let's say you've written a function — we'll call it `repeated` — which
takes a string `s` and a number `n`, and returns a new string which
contains original `s` repeated `n` times.

In most C-derived languages a call to this function will look like this:

```C
repeated ("hello", 3)  /* this is C code */
```

This means "call the function `repeated` with two arguments, first
argument the string hello and second argument the number 3".

OCaml, in common with other functional languages, writes and brackets
function calls differently, and this is the cause of many mistakes. Here
is the same function call in OCaml:

```ocaml
let repeated a b = a ^ (Int.to_string b);;
repeated "hello" 3  (* this is OCaml code *)
```

Note — **no** brackets, and **no** comma between the arguments.

The syntax `repeated ("hello", 3)` **is** meaningful in OCaml. It means
"call the function `repeated` with ONE argument, that argument being a
'pair' structure of two elements". Of course that would be a mistake,
because the `repeated` function is expecting two arguments, not one, and
the first argument should be a string, not a pair. But let's not worry
about pairs ("tuples") just yet. Instead, just remember that it's a
mistake to put the brackets and commas in around function call
arguments.

Let's have another function — `prompt_string` — which takes a string to
prompt and returns the string entered by the user. We want to pass this
string into `repeated`. Here are the C and OCaml versions:

```C
/* C code: */
repeated (prompt_string ("Name please: "), 3)
```

```ocaml
let prompt_string p = "";;
(* OCaml code: *)
repeated (prompt_string "Name please: ") 3
```

Take a careful look at the bracketing and the missing comma. In the
OCaml version, the brackets enclose the first argument of repeated
because that argument is the result of another function call. In general
the rule is: "bracket around the whole function call — don't put
brackets around the arguments to a function call". Here are some more
examples:

```ocaml
let f a b c = "";;
let g a = "";;
let f2 a = "";;
let g2 a b = "";;
f 5 (g "hello") 3;;    (* f has three arguments, g has one argument *)
f2 (g2 3 4)            (* f2 has one argument, g2 has two arguments *)
```

```ocaml
# repeated ("hello", 3)     (* OCaml will spot the mistake *)
Line 1, characters 10-22:
Error: This expression has type 'a * 'b
       but an expression was expected of type string
```

## Defining a function

We all know how to define a function (or static method, in Java)
in our existing languages. How do we do it in OCaml?

The OCaml syntax is pleasantly concise. Here's a function which takes
two floating point numbers and calculates the average:

```ocaml
let average a b =
  (a +. b) /. 2.0
```

Type this into the OCaml interactive toplevel (on Unix, type the command `ocaml`
from the shell) and you'll see this:

```ocaml
# let average a b =
    (a +. b) /. 2.0;;
val average : float -> float -> float = <fun>
```

If you look at the function definition closely, and also at what OCaml
prints back at you, you'll have a number of questions:

* What are those periods in `+.` and `/.` for?
* What does `float -> float -> float` mean?

I'll answer those questions in the next sections, but first I want to go
and define the same function in C (the Java definition would be fairly
similar to C), and hopefully that should raise even more questions.
Here's our C version of `average`:

```C
double average (double a, double b)
{
  return (a + b) / 2;
}
```

Now look at our much shorter OCaml definition above. Hopefully you'll be
asking:

* Why don't we have to define the types of `a` and `b` in the OCaml
  version? How does OCaml know what the types are (indeed, *does*
  OCaml know what the types are, or is OCaml completely dynamically
  typed?).
* In C, the `2` is implicitly converted into a `double`, can't OCaml
  do the same thing?
* What is the OCaml way to write `return`?

OK, let's get some answers.

* OCaml is a strongly *statically typed* language (in other words,
  there's nothing dynamic going on between int, float and string).
* OCaml uses *type inference* to work out the types, so you don't have
  to.  If you use the OCaml interactive toplevel as above, then OCaml
  will tell you
  its inferred type for your function.
* OCaml doesn't do any implicit casting. If you want a float, you have
  to write `2.0` because `2` is an integer. OCaml does **no automatic
  conversion** between int, float, string or any other type.
* As a side-effect of type inference in OCaml, functions (including
  operators) can't have overloaded definitions. OCaml defines `+` as
  the *integer* addition function. To add floats, use `+.` (note the
  trailing period). Similarly, use `-.`, `*.`, `/.` for other float
  operations.
* OCaml doesn't have a `return` keyword — the last expression in a
  function becomes the result of the function automatically.

We will present more details in the following sections and chapters.

## Basic types

The basic types in OCaml are:

```text
OCaml type  Range

int         31-bit signed int (roughly +/- 1 billion) on 32-bit
            processors, or 63-bit signed int on 64-bit processors
float       IEEE double-precision floating point, equivalent to C's double
bool        A boolean, written either 'true' or 'false'
char        An 8-bit character
string      A string
unit        Written as ()
```

OCaml uses one of the bits in an `int` internally in order to be able to
automatically manage the memory use (garbage collection). This is why
the basic `int` is 31 bits, not 32 bits (63 bits if you're using a 64
bit platform). In practice this isn't an issue except in a few
specialised cases. For example if you're counting things in a loop, then
OCaml limits you to counting up to 1 billion instead of 2 billion. However if you need to do things
such as processing 32 bit types (eg. you're writing crypto code or a
network stack), OCaml provides a `nativeint` type which matches the
native integer type for your platform.

OCaml doesn't have a basic unsigned integer type, but you can get the
same effect using `nativeint`. OCaml doesn't have built-in single-precision 
floating point numbers.

OCaml provides a `char` type which is used for characters, written `'x'`
for example. Unfortunately the `char` type does not support Unicode or
UTF-8, There are [comprehensive Unicode libraries](https://github.com/yoriyuki/Camomile)
which provide this functionality.

Strings are not just lists of characters. They have their own, more
efficient internal representation. Strings are immutable.

The `unit` type is sort of like `void` in C, but we'll talk about it
more below.

## Implicit vs. explicit casts

In C-derived languages ints get promoted to floats in certain
circumstances. For example if you write `1 + 2.5` then the first
argument (which is an integer) is promoted to a floating point number,
and the result is also a floating point number. It's as if you had
written `((double) 1) + 2.5`, but all done implicitly.

OCaml never does implicit casts like this. In OCaml, `1 + 2.5` is a type
error. The `+` operator in OCaml requires two ints as arguments, and
here we're giving it an int and a float, so it reports this error:

```ocaml
# 1 + 2.5;;
Line 1, characters 5-8:
Error: This expression has type float but an expression was expected of type
         int
```

To add two floats together you need to use a different operator, `+.`
(note the trailing period).

OCaml doesn't promote ints to floats automatically so this is also an
error:

```ocaml
# 1 +. 2.5
Line 1, characters 1-2:
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `1.'?
```

Here OCaml is now complaining about the first argument.

What if you actually want to add an integer and a floating point number
together? (Say they are stored as `i` and `f`). In OCaml you need to
explicitly cast:

```ocaml
let i = 1;;
let f = 2.0;;
float_of_int i +. f
```

`float_of_int` is a function which takes an `int` and returns a `float`.
There are a whole load of these functions, called such things as
`int_of_float`, `char_of_int`, `int_of_char`, `string_of_int` and so on,
and they mostly do what you expect.

Since converting an `int` to a `float` is a particularly common
operation, the `float_of_int` function has a shorter alias: the above
example could simply have been written

```ocaml
float i +. f
```

(Note that it is perfectly valid in OCaml for a type and a
function to have the same name.)

### Is implicit or explicit casting better?

You might think that these explicit casts are ugly, time-consuming even,
and you have a point, but there are at least two arguments in their
favour. Firstly, OCaml needs this explicit casting to be able to do type
inference (see below), and type inference is such a wonderful
time-saving feature that it easily offsets the extra keyboarding of
explicit casts. Secondly, if you've spent time debugging C programs
you'll know that (a) implicit casts cause errors which are hard to find,
and (b) much of the time you're sitting there trying to work out where
the implicit casts happen. Making the casts explicit helps you in
debugging. Thirdly, some casts (particularly int <-> float) are
actually very expensive operations. You do yourself no favours by hiding
them.

## Ordinary functions and recursive functions

Unlike in C-derived languages, a function isn't recursive unless you
explicitly say so by using `let rec` instead of just `let`. Here's an
example of a recursive function:

```ocaml
# let rec range a b =
    if a > b then []
    else a :: range (a + 1) b
val range : int -> int -> int list = <fun>
```

Notice that `range` calls itself.

The only difference between `let` and `let rec` is in the scoping of the
function name. If the above function had been defined with just `let`,
then the call to `range` would have tried to look for an existing
(previously defined) function called `range`, not the
currently-being-defined function. Using `let` (without `rec`) allows you
to re-define a value in terms of the previous definition. For example:

```ocaml
# let positive_sum a b = 
    let a = max a 0
    and b = max b 0 in
    a + b
val positive_sum : int -> int -> int = <fun>
```

This redefinition hides the previous "bindings" of `a` and `b` from the
function definition. In some situations coders prefer this pattern to
using a new variable name (`let a_pos = max a 0`) as it makes the old
binding inaccessible, so that only the latest values of `a` and `b` are
accessible.

There is no performance difference between functions defined using `let`
and functions defined using `let rec`, so if you prefer you could always
use the `let rec` form and get the same semantics as C-like languages.

## Types of functions

Because of type inference you will rarely if ever need to explicitly
write down the type of your functions. However, OCaml often prints out
what it thinks are the types of your functions, so you need to know the
syntax for this. For a function `f` which takes arguments `arg1`,
`arg2`, ... `argn`, and returns type `rettype`, the compiler will print:

```
f : arg1 -> arg2 -> ... -> argn -> rettype
```

The arrow syntax looks strange now, but when we come to so-called
"currying" later you'll see why it was chosen. For now I'll just give
you some examples.

Our function `repeated` which takes a string and an integer and returns
a string has type:

```ocaml
# repeated
- : string -> int -> string = <fun>
```

Our function `average` which takes two floats and returns a float has
type:

```ocaml
# average
- : float -> float -> float = <fun>
```

The OCaml standard `int_of_char` casting function:

```ocaml
# int_of_char
- : char -> int = <fun>
```

If a function returns nothing (`void` for C and Java programmers), then
we write that it returns the `unit` type. Here, for instance, is the
OCaml equivalent of C's *[fputc(3)](https://pubs.opengroup.org/onlinepubs/009695399/functions/fputc.html)*:

```ocaml
# output_char
- : out_channel -> char -> unit = <fun>
```

### Polymorphic functions

Now for something a bit stranger. What about a function which takes
*anything* as an argument? Here's an odd function which takes an
argument, but just ignores it and always returns 3:

```ocaml
let give_me_a_three x = 3
```

What is the type of this function? In OCaml we use a special placeholder
to mean "any type you fancy". It's a single quote character followed by
a letter. The type of the above function would normally be written:

```ocaml
# give_me_a_three
- : 'a -> int = <fun>
```

where `'a` (pronounced alpha) really does mean any type. You can, for example, call this
function as `give_me_a_three "foo"` or `give_me_a_three 2.0` and both
are quite valid expressions in OCaml.

It won't be clear yet why polymorphic functions are useful, but they are
very useful and very common, and so we'll discuss them later on. (Hint:
polymorphism is kind of like templates in C++ or generics in Java).

## Type inference

So the theme of this tutorial is that functional languages have many
really cool features, and OCaml is a language which has all of these
really cool features stuffed into it at once, thus making it a very
practical language for real programmers to use. But the odd thing is
that most of these cool features have nothing to do with "functional
programming" at all. In fact, I've come to the first really cool
feature, and I still haven't talked about why functional programming is
called "functional". Anyway, here's the first really cool feature: type
inference.

Simply put: you don't need to declare the types of your functions and
variables, because OCaml will just figure them out for you!

In addition OCaml goes on to check all your types match up (even across
different files).

But OCaml is also a practical language, and for this reason it contains
backdoors into the type system allowing you to bypass this checking on
the rare occasions that it is sensible to do this. Only gurus will
probably need to bypass the type checking.

Let's go back to the `average` function which we typed into the OCaml
interactive toplevel:

```ocaml
# let average a b =
    (a +. b) /. 2.0
val average : float -> float -> float = <fun>
```

OCaml worked out all on its own that the function takes
two `float` arguments and returns a `float`!

How did it do this? Firstly it looks at where `a` and `b` are used,
namely in the expression `(a +. b)`. Now, `+.` is itself a function
which always takes two `float` arguments, so by simple deduction, `a`
and `b` must both also have type `float`.

Secondly, the `/.` function returns a `float`, and this is the same as
the return value of the `average` function, so `average` must return a
`float`. The conclusion is that `average` has this type signature:

```ocaml
# average
- : float -> float -> float = <fun>
```

Type inference is obviously easy for such a short program, but it works
even for large programs, and it's a major time-saving feature because it
removes a whole class of errors which cause segfaults,
`NullPointerException`s and `ClassCastException`s in other languages (or
important but often ignored runtime warnings).