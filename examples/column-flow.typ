// Example: two columns across the symmetric width on an asymmetric page.
//
// Compile to page images with:
//   typst compile -f png --ppi 144 examples/column-flow.typ "doc/images/column-flow-{p}.png"

#import "../lib.typ": column-flow
#import "assets/guides.typ": guides

#set page(
  paper: "a5",
  margin: (inside: 1cm, outside: 2.5cm),
  numbering: "1",
  background: guides(),
)
#set text(font: ("New Computer Modern", "SimSun"), size: 9pt, lang: "zh")
#set par(first-line-indent: (amount: 2em, all: true), justify: true, leading: 0.6em)

// Body text at the normal asymmetric margins.
#lorem(45)

#v(1em)

#column-flow(
  [
    双栏重排演示。本段开始时页面仍处于非对称页边距下，`column-flow` 会把随后的内容
    重新排入对称页面宽度的两栏之中，并让续排内容继续使用对称页边距。
    #footnote[位于重排内容开头的脚注。]

    #lorem(230)

    中文与英文混排 testing mixed CJK and Latin reflow across columns. 假文假文假文
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(250)
  ],
  gutter: 10pt,
)
