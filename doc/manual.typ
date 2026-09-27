#set page(paper: "a4", margin: 2.2cm, numbering: "1")
#set text(font: ("New Computer Modern", "SimSun"), size: 10.5pt, lang: "en")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#show raw.where(block: true): set text(size: 8.5pt)
#show raw.where(block: true): it => block(
  fill: luma(248),
  inset: 8pt,
  radius: 2pt,
  width: 100%,
  it,
)

// The example sources live next to the package; the page images are rendered
// from them with `typst compile -f png`.
#let source(name) = raw(read("../examples/" + name + ".typ"), lang: "typ", block: true)
#let pages(name) = grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  image("images/" + name + "-1.png", width: 100%),
  image("images/" + name + "-2.png", width: 100%),
)
#let example(name, title, note) = {
  heading(title)
  source(name)
  v(0.7em)
  pages(name)
  v(0.3em)
  align(center)[#text(size: 8.5pt, fill: luma(110))[
    Rendered output — page 1 (left) and page 2 (right). #note
  ]]
  v(0.6em)
}

#align(center)[
  #text(size: 26pt, weight: "bold")[margin-reflow] \
  #v(0.3em)
  #text(size: 14pt)[Reflow content into new margins in the middle of a page] \
  #v(0.3em)
  #text(size: 11pt)[Manual · version 0.1.0]
]

#v(2em)

= Introduction

This package reflows a stream of content into new page margins, starting exactly
where the content appears and *without forcing a page break*. It is designed for
documents that mix an asymmetric (book-style, wide outer margin) layout with
blocks that read better at a different width.

Three functions cover the three directions:

- `column-flow` — reflows content into two columns across the symmetric width.
- `single-flow` — reflows content into a single column across the symmetric
  width.
- `asymmetric-flow` — reflows content from symmetric margins back into a given
  asymmetric layout (the reverse direction).

All of them pull footnotes out of the flow and render them at the bottom of the
reflowed block, preserve footnote numbering and `ref`s, lay the reflowed block
flush to the bottom of the available height, and keep the new margins on the
pages that follow.

= Requirements

The functions measure the current page and position, so use them in normal
document flow (they are `context` functions and handle this themselves). The
first-line indentation of the reflowed content follows the ambient
`par.first-line-indent`, so set it explicitly:

```typ
#set par(first-line-indent: (amount: 2em, all: true), justify: true)
```

= Installation

The package is available on Typst Universe:

```typ
#import "@preview/margin-reflow:0.1.0": column-flow, single-flow, asymmetric-flow
```

= API reference

== column-flow

Reflows content into symmetric two-column pages when it begins partway down an
asymmetric page. The columns are widened to the symmetric content width and
shifted into the symmetric position; text already on the page is untouched.

```typ
#column-flow(content, gutter: 4%, count: 2, footnote-entry: none)
```

- `content` *(content)*: the content to reflow. Paragraph breaks are honored.
- `gutter` *(length, default `4%`)*: the gap between columns.
- `count` *(int, default `2`)*: the number of columns.
- `footnote-entry` *(none, dictionary, or function)*: styling for the manually
  laid-out footnote entries, mirroring `footnote.entry`.

== single-flow

The single-column counterpart of `column-flow`: one column spanning the whole
symmetric content width.

```typ
#single-flow(content, footnote-entry: none)
```

- `content` *(content)*: the content to reflow.
- `footnote-entry` *(none, dictionary, or function)*: as in `column-flow`.

== asymmetric-flow

The reverse direction: content that begins partway down a symmetric page is
reflowed into a single column spanning the whole asymmetric content area given
by `margin`, and the following pages use that asymmetric margin.

```typ
#asymmetric-flow(content, margin, footnote-entry: none)
```

- `content` *(content)*: the content to reflow.
- `margin` *(auto, length, or dictionary)*: the asymmetric horizontal margin to
  switch to, e.g. `(inside: 1cm, outside: 3cm)` or `(left: 1cm, right: 3cm)`.
  `inside`/`outside` are resolved against the current page parity, like
  `page.margin`. Only the horizontal margins are taken from `margin`; the top and
  bottom margins of the current page are preserved.
- `footnote-entry` *(none, dictionary, or function)*: as in `column-flow`.

= Examples

Each example below is a complete, compilable file. Its two rendered pages are
shown next to it. The body text before the reflow and the reflowed content are
separated by a `#v(1em)` in the sources; this gap is cosmetic and optional. In
the page images, the *blue* dashed line marks the symmetric content boundary and
the *orange* dashed line the asymmetric one.

#example("column-flow", [Two columns on an asymmetric page],
  [The reflowed content spans two pages, so the page-break behaviour is visible.])

#example("single-flow", [One column on an asymmetric page],
  [A single column across the symmetric width.])

#example("asymmetric-flow", [Returning to an asymmetric layout],
  [Starting from symmetric margins and switching to asymmetric ones.])

#example("footnotes-figure", [Footnotes and a figure],
  [A footnote at the very start, a figure in the middle, and a second footnote,
  all inside the reflowed block.])

= Compatibility and CJK

== Content-processing packages

The functions split and rebuild content, so packages that *transform content*
should be applied to the content *before* it is passed in. For example, with
`cjk-unbreak`:

```typ
#import "@preview/cjk-unbreak:0.2.3": remove-cjk-break-space

#column-flow(remove-cjk-break-space[
  中文与英文混排 content ...
])
```

== CJK and mixed scripts

The splitter is aware of Han characters, CJK punctuation and spaces, so it
handles Chinese, Japanese and Korean text as well as mixed CJK/Latin reflow. For
best results, set a CJK-capable font and enable justification and first-line
indentation:

```typ
#set text(font: ("New Computer Modern", "SimSun"), lang: "zh")
#set par(first-line-indent: (amount: 2em, all: true), justify: true)
```

== Layout packages

The functions build their own fixed-height `grid`/`block` structure and change
`page.margin`, so packages that also control pagination, columns or page
geometry may conflict. Packages that only *decorate* content (colours, boxes,
emphasis) generally work; layout packages have not been tested. Footnote styling
is rendered manually, so use the `footnote-entry` parameter if a package restyles
`footnote.entry`.

== Margin-note packages (e.g. marginalia)

Using this package together with a margin-note package such as `marginalia` is a
common case, but because the flow functions manage the page and change
`page.margin` mid-page, a few precautions are needed:

- Do *not* wrap the output of a flow function in `marginalia.wideblock`. A
  wideblock computes its width from the marginalia configuration rather than from
  the current page margins, and a multi-page wideblock does not work with
  alternating margins.
- Do *not* use `marginalia.wideblock` or `marginalia.header` for headers and
  footers. Instead, align the header/footer directly from `page.margin` (a
  broader alignment that follows the margins this package sets). A minimal
  example adapted from the book template:

  ```typ
  #set page(header: context {
    let m = page.margin
    let pad-fn = if "inside" in m {
      if calc.even(here().page()) {
        pad.with(left: m.inside - m.outside, rest: 0pt)
      } else {
        pad.with(right: m.inside - m.outside, rest: 0pt)
      }
    } else {
      it => it
    }
    pad-fn(align(end + horizon)[#counter(page).display()])
  })
  ```

- An *empty* `marginalia.wideblock` may still be used to reserve the widened area
  so that margin notes do not overflow into the body text.

= Inspiration

The idea of reflowing content mid-page comes from
[meander.typ](https://github.com/Vanille-N/meander.typ). This package focuses on
the asymmetric ⇄ symmetric reflow direction and, in particular, on the multi-page
asymmetric case that could previously fail to
[converge](https://github.com/Vanille-N/meander.typ/issues/1#issuecomment-3306100761).
It also supports mixed CJK and Latin reflow.

= License

Licensed under the MIT license.
