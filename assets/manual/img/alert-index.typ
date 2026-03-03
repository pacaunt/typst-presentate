#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#show emph: set text(fill: red) // for apparent looking
#slide[
  #alert(from: 2)[Note!] // stays alerted from subslide 2

  I want to #alert(2)[emphasize] that \
  number under the square root must be #alert(3)[positive].
]