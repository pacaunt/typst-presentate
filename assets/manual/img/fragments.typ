#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#slide[
  These are the first 3 alphabets of Greek:

  #fragments[$alpha$/$Alpha$ ][$beta$/$Beta$ ][$gamma$/$Gamma$]
  #show: pause 
  
  which have been used widely in physics. // the fragments update the pause.
]