#import "../../../src/export.typ": *
#import "../../../src/themes/progressive-outline.typ": template, slide
#import "common.typ": *

#show: template.with(
  title: [Progressive Outline 2-Level Demo],
  subtitle: [Section & Subsection only],
  author: [Presentate Team],
  mapping: (section: 1, subsection: 2),
  auto-title: true,
)

#introduction_slides(slide, [Simple 2-level hierarchy without Parts.])
#section_simple_demo(slide)
#section_nested_demo(slide)
#global_options_slides(slide)