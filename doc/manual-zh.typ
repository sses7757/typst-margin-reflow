#set page(paper: "a4", margin: 2.2cm, numbering: "1")
#set text(font: ("New Computer Modern", "SimSun"), size: 10.5pt, lang: "zh")
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

// 示例源码位于包旁边；页面图片由 `typst compile -f png` 生成。
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
    渲染结果 —— 左为第 1 页，右为第 2 页。#note
  ]]
  v(0.6em)
}

#align(center)[
  #text(size: 26pt, weight: "bold")[margin-reflow] \
  #v(0.3em)
  #text(size: 14pt)[在页面中途把内容重排到新的页边距] \
  #v(0.3em)
  #text(size: 11pt)[手册 · 版本 0.1.0]
]

#v(2em)

= 简介

本包把一段内容在它出现的位置直接重排到新的页边距，且*不强制换页*。它适用于
混用非对称（书籍式、外侧留白较宽）版式与需要不同宽度的内容块（例如习题）的文档。

三个函数对应三个方向：

- `column-flow`：把内容重排为横跨对称页面宽度的两栏。
- `single-flow`：把内容重排为横跨对称页面宽度的单栏。
- `asymmetric-flow`：把内容从对称页边距重排回指定的非对称版式（反方向）。

三者都会把脚注从正文流中取出，在重排块底部手动排版，保留脚注编号与引用；重排块
底部与可用高度齐平；并让其后的页面沿用新的页边距。

= 使用要求

函数会测量当前页面与位置，请在正常文档流中使用（它们本身是 `context` 函数，会自
行处理）。重排内容的首行缩进跟随环境的 `par.first-line-indent`，请显式设置：

```typ
#set par(first-line-indent: (amount: 2em, all: true), justify: true)
```

= 安装

本包已发布在 Typst Universe：

```typ
#import "@preview/margin-reflow:0.1.0": column-flow, single-flow, asymmetric-flow
```

= API 参考

== column-flow

当内容从非对称页面的中部开始时，把它重排为对称宽度的两栏。栏宽会扩展到对称的
内容宽度并平移到对称位置；页面上已有的文字不受影响。

```typ
#column-flow(content, gutter: 4%, count: 2, footnote-entry: none)
```

- `content` *（content）*：要重排的内容。会识别段落分隔。
- `gutter` *（length，默认 `4%`）*：栏间距。
- `count` *（int，默认 `2`）*：栏数。
- `footnote-entry` *（none、dictionary 或 function）*：手动排版脚注条目的样式，
  与 `footnote.entry` 对应。

== single-flow

`column-flow` 的单栏版本：一栏占据整个对称内容宽度。

```typ
#single-flow(content, footnote-entry: none)
```

- `content` *（content）*：要重排的内容。
- `footnote-entry` *（none、dictionary 或 function）*：同 `column-flow`。

== asymmetric-flow

反方向：从对称页面的中部开始的内容会被重排为占据 `margin` 所指定的整个非对称内容
区域的单栏，其后各页使用该非对称页边距。

```typ
#asymmetric-flow(content, margin, footnote-entry: none)
```

- `content` *（content）*：要重排的内容。
- `margin` *（auto、length 或 dictionary）*：要切换到的非对称水平页边距，例如
  `(inside: 1cm, outside: 3cm)` 或 `(left: 1cm, right: 3cm)`。`inside`/`outside`
  会像 `page.margin` 一样依据当前页面的奇偶解析。只取 `margin` 的水平页边距；当前
  页面的上下页边距会被保留。
- `footnote-entry` *（none、dictionary 或 function）*：同 `column-flow`。

= 示例

下列每个示例都是完整、可编译的文件，旁边是其渲染出的两页。源码中正文与重排内容之
间用 `#v(1em)` 留出了间隔；该间隔只是观感上的，可有可无。在页面图片中，*蓝色*虚线
标记对称内容边界，*橙色*虚线标记非对称内容边界。

#example("column-flow", [非对称页面上的两栏],
  [重排内容跨两页，因此可以清楚看到换页效果。])

#example("single-flow", [非对称页面上的单栏],
  [横跨对称宽度的单栏。])

#example("asymmetric-flow", [回到非对称版式],
  [从对称页边距开始，再切换到非对称页边距。])

#example("footnotes-figure", [脚注与图片],
  [在最开头放置脚注、在中间放置图片，再在中间放置脚注，全部位于重排块内。])

= 兼容性与中文 / CJK

== 处理内容的包

函数会拆分并重建内容，因此“*转换内容*”的包应在把内容传入*之前*先应用。例如与
`cjk-unbreak` 连用：

```typ
#import "@preview/cjk-unbreak:0.2.3": remove-cjk-break-space

#column-flow(remove-cjk-break-space[
  中文与英文混排内容……
])
```

== 中文与混排

拆分器能够识别汉字、中文标点与空格，因此可以处理中文、日文、韩文文本，以及中英文
混排的重排。建议设置支持中文的字体并开启两端对齐与首行缩进：

```typ
#set text(font: ("New Computer Modern", "SimSun"), lang: "zh")
#set par(first-line-indent: (amount: 2em, all: true), justify: true)
```

== 版式相关的包

函数会自行构建固定高度的 `grid`/`block` 结构并修改 `page.margin`，因此与同样控制
分页、分栏或页面几何的包可能冲突。仅对内容做装饰（颜色、盒子、强调等）的包通常可以
使用；版式类包尚未测试。脚注是手动排版的，如果某个包重设了 `footnote.entry`，请改用
`footnote-entry` 参数。

= 灵感来源

在页面中途重排内容的想法来自
[meander.typ](https://github.com/Vanille-N/meander.typ)。本包聚焦于“非对称 ⇄ 对称”
方向的重排，尤其是以往可能
[不收敛](https://github.com/Vanille-N/meander.typ/issues/1#issuecomment-3306100761)
的多页非对称重排，并支持中英文混排。

= 许可证

采用 MIT 许可证。
