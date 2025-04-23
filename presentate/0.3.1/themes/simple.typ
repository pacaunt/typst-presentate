#import "../slides.typ": * 
#let info = (
  author: [AUTHOR], 
  title: [TITLE], 
  date: [DATETIME], 
  institute: [INSTITUTE OF PRESENTATION],
  logo: box(width: 1cm, height: 1cm, fill: eastern, [LOGO]),
  last-topic: context query(selector(heading.where(level: 2, outlined: true).before(here()))).at(-1, default: [])
)

#let title-slide(body, info: info) = {
  set text(weight: "bold", size: 2.5em)
  centered-slide(body)
}