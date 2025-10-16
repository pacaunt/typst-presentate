#import "@local/presentate:0.2.1": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
#set raw(lang: "typc")

#slide[
  = Relative `auto` and `none` Indices

  This is present first 

  #show: pause 

  #only(auto)[This came later, but *not* preserve space.]
 _This will shift._

 #uncover(none)[This comes with current `pause`.]

 #show: pause 
 This is the next `pause`.
]