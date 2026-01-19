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
        "id": "T09_3Level_Full",
        "title": "3-Level Depth (Part/Sec/Sub)",
        "desc": "Full 3-level structure with Part, Section, and Subsection transitions.",
        "transitions": "(max-level: 3)",
        "mapping": "(part: 1, section: 2, subsection: 3)",
        "content": """
= Part I
== Section A
=== Subsection A.1
#slide[Content A.1]
=== Subsection A.2
#slide[Content A.2]
== Section B
#slide[Content B]
""",
        "expected": "Transitions for Part (L1), Section (L2) and Subsection (L3). Outline should show 3 levels of depth."
    },
    {
        "id": "T10_3Level_Visibility",
        "title": "3-Level Focus (Current-Parent)",
        "desc": "Testing focus mode at depth 3.",
        "transitions": '(max-level: 3, subsections: (visibility: (part: "none", section: "current", subsection: "current-parent")))',
        "mapping": "(part: 1, section: 2, subsection: 3)",
        "content": """
= Part I
== Section A
=== Sub A.1
#slide[Slide A.1]
=== Sub A.2
#slide[Slide A.2]
== Section B
=== Sub B.1
#slide[Slide B.1]
""",
        "expected": "On Sub A.2 transition, should show Section A (active) and its children (Sub A.1, Sub A.2). Section B should be hidden."
    },
    {
        "id": "T11_3Level_Style",
        "title": "3-Level Custom Style",
        "desc": "Testing styles across 3 levels.",
        "transitions": '(max-level: 3, style: (inactive-opacity: 0.1, active-weight: "black", active-color: rgb("#e74c3c")))',
        "mapping": "(part: 1, section: 2, subsection: 3)",
        "content": """
= Part I
== Section A
=== Sub A.1
#slide[Slide]
""",
        "expected": "Very faint inactive items (0.1 opacity), very bold red active items on all 3 levels."
    }
]

# --- TEMPLATE ---
typst_template = """
#import "{import_path}": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Test {case_id}: {case_title}],
  subtitle: [3-Level Transition Test],
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
  
  *Description:* {case_desc}

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
        if theme == "split":
            extra = 'primary: rgb("#003366"), secondary: rgb("#336699"),'
        elif theme == "sidebar":
             extra = 'side: "left", active-color: rgb("#f39c12"),'
        elif theme == "miniframes":
             extra = 'color: rgb("#1a5fb4"),'

        filename = f"{OUTPUT_DIR}/test_TRANSITION_3LEVEL_{theme}_{case['id']}.typ"
        
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

print(f"Succès : {count} nouveaux fichiers de tests 3-niveaux générés.")