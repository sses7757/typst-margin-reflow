// Draw boundary guide lines on the example pages so readers can locate the
// symmetric and asymmetric content areas: a blue dashed line marks the
// symmetric content boundary, an orange dashed line marks the asymmetric one.
// Drawn as a page background, so it does not affect the reflow measurement.
//
// `sym` and `asym` are `(left, right)` margin pairs.
#let guides(sym: (1cm, 1cm), asym: (1cm, 2.5cm)) = context {
  let w = page.width
  let h = page.height
  let blue = rgb("#2b6cb0")
  let orange = rgb("#c05621")
  let vline(x, paint) = place(
    dx: x,
    dy: 0pt,
    line(length: h, angle: 90deg, stroke: (paint: paint, thickness: 0.6pt, dash: "dashed")),
  )
  let tag(x, paint, body) = place(
    dx: x + 2pt,
    dy: 5pt,
    text(size: 6pt, fill: paint, body),
  )
  [
    #place(rect(width: w, height: h, stroke: (paint: luma(150), thickness: 0.5pt)))
    #vline(sym.at(0), blue)
    #vline(w - sym.at(1), blue)
    #vline(asym.at(0), orange)
    #vline(w - asym.at(1), orange)
    #tag(w - sym.at(1), blue, [sym])
    #tag(w - asym.at(1), orange, [asym])
  ]
}
