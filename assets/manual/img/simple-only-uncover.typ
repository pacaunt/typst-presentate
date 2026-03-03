#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#slide[
  Which of the following numbers are irrational? 
  
  (a) #only(2, $pi$) 
  (b) #uncover(3, $sqrt(4)$)  // The space here is peserved.
  (c) #only(4, $sqrt(2)$) 
  (d) None of them.
]