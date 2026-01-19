#import "../../../src/themes/structured/sidebar.typ": template, slide

#show: template.with(
  title: [Test Typographie],
  text-font: "Courier",
  text-size: 15pt,
)

#slide("Changement de Style")[
  Cette slide utilise la police *Courier* avec une taille de *15pt*.
  
  Toutes les proportions (sidebar, titres) doivent s'adapter à cette nouvelle base.
]
