import os

# --- CONFIGURATION ---
OUTPUT_DIR = "assets/tests/structure_stress_test"
THEMES = {
    "sidebar": "../../../src/themes/structured/sidebar.typ",
    "miniframes": "../../../src/themes/structured/miniframes.typ",
    "split": "../../../src/themes/structured/split.typ",
    "progressive-outline": "../../../src/themes/structured/progressive-outline.typ",
    "custom-transition": "../../../src/themes/structured/custom-transition.typ",
}

# --- SCENARIOS ---
scenarios = [
    {
        "id": "T01_Baseline",
        "title": "Baseline Defaults",
        "desc": "Default configuration with standard mapping.",
        "transitions": "()",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section 1
== Subsection 1.1
#slide[Content 1.1]
= Section 2
== Subsection 2.1
#slide[Content 2.1]
""",
        "expected": "Transitions for Section (Level 1) and Subsection (Level 2). Standard styling."
    },
    {
        "id": "T02_Filter_Level1",
        "title": "Filter: Level 1 Only",
        "desc": "Filter function allowing only level 1 headings.",
        "transitions": "(filter: h => h.level == 1)",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section 1 (Transition)
== Subsection 1.1 (No Transition)
#slide[Content]
= Section 2 (Transition)
""",
        "expected": "Transition slide ONLY for 'Section'. Subsection headings appear in outline but trigger no slide."
    },
    {
        "id": "T03_MaxLevel_1",
        "title": "Max Level: 1",
        "desc": "Explicit max-level set to 1.",
        "transitions": "(max-level: 1)",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section 1 (Transition)
== Subsection 1.1 (No Transition)
#slide[Content]
""",
        "expected": "Similar to Filter, but using max-level. Only Section transition."
    },
    {
        "id": "T04_Custom_Colors",
        "title": "Custom Colors",
        "desc": "Black background, Yellow active text.",
        "transitions": '(background: black, style: (active-color: yellow, active-weight: "black"))',
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section 1
#slide[Content]
""",
        "expected": "Transition slide with BLACK background and YELLOW text."
    },
    {
        "id": "T05_Visibility_All",
        "title": "Visibility: Show All",
        "desc": "Sections show ALL items instead of current.",
        "transitions": '(sections: (visibility: (section: "all", subsection: "all")))',
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section A
== Sub A.1
= Section B
== Sub B.1
""",
        "expected": "On Section A transition, Section B is visible (not hidden). Subsections also visible."
    },
    {
        "id": "T06_Mapping_Shift",
        "title": "Mapping Shift (Part/Section)",
        "desc": "Mapping Part=1, Section=2.",
        "transitions": "()",
        "mapping": "(part: 1, section: 2)",
        "content": """
= Part I
== Section A
#slide[Content]
== Section B
""",
        "expected": "Level 1 treated as 'Part', Level 2 as 'Section'. Part transition should show Parts only (default)."
    },
    {
        "id": "T07_Orphan_Subsection",
        "title": "Orphan Subsection",
        "desc": "Subsection without parent Section.",
        "transitions": "()",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
== Orphan Subsection
#slide[Content]
= Section A
== Normal Subsection
""",
        "expected": "Orphan Subsection triggers transition. Outline should handle missing parent gracefully."
    },
     {
        "id": "T08_Disable_Subsections",
        "title": "Disable Subsections",
        "desc": "Subsections enabled: false.",
        "transitions": "(subsections: (enabled: false))",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section 1
== Subsection 1.1 (No Slide)
#slide[Content]
""",
        "expected": "No transition slide for Subsection."
    }
]

# --- TEMPLATE ---
typst_template = """
#import "{import_path}": template, slide

#show: template.with(
  title: [Test {case_id}: {case_title}],
  subtitle: [Transition Engine Test],
  author: [Gemini Agent],
  mapping: {mapping},
  transitions: {transitions},
  auto-title: true, 
  {extra_args}
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* {case_title} ({case_id})
  
  *Description:* 
  {case_desc}

  *Mapping:* `{mapping}`
  
  *Transitions Options:* 
  ```typ
  {transitions}
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    {case_expected}
  ]
]

// --- CONTENT ---
{content}
"""

# --- GENERATION ---
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

count = 0
for theme, path in THEMES.items():
    for case in scenarios:
        extra = ""
        # Theme specific defaults for test visual clarity
        if theme == "split":
            extra = 'primary: rgb("#003366"), secondary: rgb("#336699"),'
        elif theme == "sidebar":
             extra = 'side: "left", active-color: rgb("#f39c12"),'
        elif theme == "miniframes":
             extra = 'color: rgb("#1a5fb4"),'
        elif theme == "custom-transition":
             # Custom needs at least some hook or it falls back to engine. 
             # We want to test engine, so we leave hooks as none (default).
             pass

        filename = f"{OUTPUT_DIR}/test_TRANSITION_{theme}_{case['id']}.typ"
        
        file_content = typst_template.format(
            import_path=path,
            case_id=case['id'],
            case_title=case['title'],
            case_desc=case['desc'],
            mapping=case['mapping'],
            transitions=case['transitions'],
            case_expected=case['expected'],
            content=case['content'],
            extra_args=extra
        )

        with open(filename, "w") as f:
            f.write(file_content)
        count += 1

print(f"Generated {count} test files in {OUTPUT_DIR}")
