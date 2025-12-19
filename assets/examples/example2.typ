#import "@local/presentate:0.2.3": * 
#set page(paper: "presentation-16-9")
#set text(size: 25pt, font: "JetBrainsMono NF")
#set align(horizon)

#slide[
  = Welcome to Presentate! 
  \
  A lazy author \
  #datetime.today().display()
]

#set align(top)

#slide[
  == Tips for Typst.

  #set align(horizon)
  Do you know that $pi != 3.141592$?

  #show: pause 
  Yeah. Certainly.

  #show: pause 
  Also $pi != 22/7$.
]