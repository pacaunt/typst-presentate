#import "../../../src/export.typ": *
#import "../../../src/themes/split.typ": template, slide
#import "common.typ": *

#show: template.with(
  title: [Split 2-Level Demo],
  subtitle: [Section & Subsection only],
  author: [Presentate Team],
  mapping: (section: 1, subsection: 2),
  auto-title: true,
  primary: rgb("#003366"),
  secondary: rgb("#336699"),
)

#introduction_slides(slide, [Simple 2-level hierarchy without Parts.])
#section_simple_demo(slide)
#section_nested_demo(slide)
#global_options_slides(slide)