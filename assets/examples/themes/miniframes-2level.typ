#import "../../../src/export.typ": *
#import "../../../src/themes/miniframes.typ": template, slide
#import "common.typ": *

#show: template.with(
  title: [Miniframes 2-Level Demo],
  subtitle: [Section & Subsection only],
  author: [Presentate Team],
  mapping: (section: 1, subsection: 2),
  auto-title: true,
  color: rgb("#1a5fb4"),
  navigation: (style: "grid")
)

#introduction_slides(slide, [Simple 2-level hierarchy without Parts.])
#section_simple_demo(slide)
#section_nested_demo(slide)
#global_options_slides(slide)