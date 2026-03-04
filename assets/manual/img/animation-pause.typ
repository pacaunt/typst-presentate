#import "../../../src/export.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example
#import "@preview/fletcher:0.5.8": diagram, edge 

#slide[
  = Fletcher Diagram 
  #set align(center + horizon)
  #render(s => ({
    import animation: * 
    diagram($
              A edge(->)  & pause(#s, B edge(->)) #s.push(auto) 
                          & pause(#s, C) #s.push(auto) \
                          & pause(#s, F edge(->, "t")) 
            $)
  }, s))
] 