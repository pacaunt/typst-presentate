#import "../../../src/export.typ": *
#import "../../../src/themes/sidebar.typ": template, slide
#import "common.typ": *

#show: template.with(
  title: [Sidebar Mixed Mapping Demo],
  subtitle: [2-Level Mapping vs 3-Level Content],
  author: [Presentate Team],
  mapping: (section: 1, subsection: 2), // L3 is ignored
  auto-title: true,
)

#introduction_slides(slide, [Testing what happens when content has more levels than the mapping.])
#mixed_levels_demo(slide)
