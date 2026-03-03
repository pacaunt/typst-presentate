#set page(margin: 2cm)
#set text(font: "Lato")
#show raw: set text(font: "JetBrainsMono NF")
#set raw(lang: "typc")
#let info = toml("../../../typst.toml")
#show "Typst": set text(font: "Libertinus Serif", weight: "bold")

#set document(title: [Presentate #info.package.version User Manual])


#[
  #set page(fill: eastern)
  #set align(horizon)
  #set text(fill: white, size: 1.8em)
  #show link: underline
  
  #text(size: .8em)[Version #info.package.version]
  #v(1fr)
  #text(size: 2.2em, fill: white, weight: "bold")[
    Presentate
  ]  
  #v(-1.7em)
  Integrable, Dynamic Presentation in Typst

  *User Manual* 
 
  #v(1fr)
  #text(size: .8em)[
    GitHub: #link("https://github.com/pacaunt/typst-presentate") \
    Compiled on #datetime.today().display("[day] [month repr:long] [year]")
  ]
]