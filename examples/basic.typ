// Minimal runnable example for riffle.
//
// Compile with:
//   typst compile examples/basic.typ

#import "../lib.typ": column-flow, single-flow, asymmetric-flow

#set page(paper: "a5", margin: (inside: 1cm, outside: 3cm))
#set par(first-line-indent: (amount: 2em, all: true), justify: true, leading: 0.65em)

= column-flow

Text before the reflow sits at the normal asymmetric margins.

#lorem(30)

#column-flow(
  [
    #lorem(50) #footnote[A footnote inside the reflowed content.]

    #lorem(60)
  ],
  gutter: 10pt,
)

= single-flow

#set page(margin: (inside: 1cm, outside: 3cm))
#lorem(30)

#single-flow(
  [
    #lorem(50) #footnote[Another footnote.]

    #lorem(60)
  ],
)

= asymmetric-flow

#set page(margin: 1.5cm)
#lorem(30)

#asymmetric-flow(
  [ #lorem(50) #footnote[A footnote.] \ #lorem(60) ],
  (inside: 1cm, outside: 3cm),
)
