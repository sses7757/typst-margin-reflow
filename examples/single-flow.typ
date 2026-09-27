// Example: one column across the symmetric width on an asymmetric page.
//
// Compile to page images with:
//   typst compile -f png --ppi 144 examples/single-flow.typ "doc/images/single-flow-{p}.png"

#import "../lib.typ": single-flow
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

#single-flow(
  [
    单栏重排演示。这一段会占据对称页面的整个可用宽度，而不是像双栏那样分成两列。
    #footnote[位于重排内容开头的脚注。]

    #lorem(240)

    中文与英文混排 testing mixed CJK and Latin reflow. 假文假文假文假文假文假文假文
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(260)
  ],
)
