#import "@local/presentate:0.2.5": * 
#import "@preview/muchpdf:0.1.2": muchpdf

#let file-name = sys.inputs.at("name", default: "example-pdf-animation.pdf")

#let imgs = read(file-name, encoding: none)

#let all-pages = muchpdf(imgs).children

#set page(margin: 5pt, height: auto, width: auto, fill: gray)

#grid(
  columns: if file-name in ("example-pdf-animation.pdf", "example-simple-theme.pdf", "example-default-theme.pdf") { 3 } else { 2 }, 
  gutter: 5pt,
  ..all-pages.map(block.with(stroke: 1pt, fill: white))
)
