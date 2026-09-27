// Example: complex content — footnotes at the start and in the middle, and an
// image, all inside the reflowed block.
//
// Compile to page images with:
//   typst compile -f png --ppi 144 examples/footnotes-figure.typ "doc/images/footnotes-figure-{p}.png"

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
#set figure(gap: 0.5em)

// Body text at the normal asymmetric margins.
#lorem(40)

#v(1em)

#column-flow(
  [
    #footnote[位于重排内容最开头的脚注。]第一段在重排内容的最开头就带有一个脚注。

    #lorem(220)

    #figure(image("assets/plot.svg", width: 75%), caption: [重排内容中的一张图片。])

    #footnote[位于中间的脚注。]第二段在中间带有一个脚注，其后继续排布文字。

    中文与英文混排 mixed CJK and Latin within a two-column reflow. 假文假文假文假文假文
    假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文假文。

    #lorem(240)
  ],
  gutter: 10pt,
  footnote-entry: (indent: 0em, size: 8pt),
)
