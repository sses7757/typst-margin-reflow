// Example: switch from symmetric margins to an asymmetric layout.
//
// Compile to page images with:
//   typst compile -f png --ppi 144 examples/asymmetric-flow.typ "doc/images/asymmetric-flow-{p}.png"

#import "../lib.typ": asymmetric-flow
#import "assets/guides.typ": guides

#set page(
  paper: "a5",
  margin: 1.5cm,
  numbering: "1",
  background: guides(sym: (1.5cm, 1.5cm), asym: (1cm, 2.5cm)),
)
#set text(font: ("New Computer Modern", "SimSun"), size: 9pt, lang: "zh")
#set par(first-line-indent: (amount: 2em, all: true), justify: true, leading: 0.6em)

// Body text at symmetric margins.
#lorem(40)

#v(1em)

#asymmetric-flow(
  [
    回到非对称页边距。本段开始时页面是对称页边距，随后内容会收窄到由 `margin`
    指定的非对称页边距（内侧 1cm、外侧 2.5cm），并在其后各页保持该页边距。
    #footnote[位于重排内容开头的脚注。]

    #lorem(240)

    中文与英文混排 testing mixed CJK and Latin reflow. 假文假文假文假文假文假文假文
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(260)
  ],
  (inside: 1cm, outside: 2.5cm),
)
