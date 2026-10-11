#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#import "@preview/gentle-clues:1.3.1": info
#slide[
  = History of English 

  #let info = bridge(info, mode: "content") // specify the mode of content inside 
  #info[
    Do you know that #pause 
    English is *not* one of #alert(auto)[romance languages]?
  ]
]