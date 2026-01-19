import os

# --- CONFIGURATION ---
OUTPUT_DIR = "assets/tests/structure_stress_test"
THEMES = {
    "sidebar": "../../../src/themes/structured/sidebar.typ",
}

# --- DEEP SIDEBAR SCENARIOS ---
scenarios = {
    "sidebar": [
        {
            "id": "MappingFilter",
            "title": "Sidebar: Mapping Filter (L1 only)",
            "opts": 'mapping: (section: 1), numbering: "1."',
            "desc": "Seul le niveau 1 est mappé. Le niveau 2 (==) ne doit pas apparaître dans la sidebar.",
            "expected": "Sidebar montre uniquement '1. Section Test'. La sous-section est masquée."
        },
        {
            "id": "ModeOverride",
            "title": "Sidebar: Mode Override (Accordion)",
            "opts": 'outline-options: (level-2-mode: "current-parent")',
            "desc": "Override pour n'afficher que les sous-sections de la section active.",
            "expected": "Au début, seules les sections sont visibles. Les sous-sections n'apparaissent que lorsqu'on entre dans leur section parent."
        },
        {
            "id": "NoNumbering",
            "title": "Sidebar: No Numbering",
            "opts": 'outline-options: (show-numbering: false), numbering: "1.1"',
            "desc": "Les titres de slides ont des numéros, mais la sidebar n'en a pas.",
            "expected": "Titres: '1. Section'. Sidebar: 'Section' (sans numéro)."
        }
    ]
}

# --- TEMPLATE ---
typst_template = """
#import "{import_path}": template, slide

#show: template.with(
  title: [Deep Test: {case_title}],
  author: [Gemini Agent],
  {case_opts}
)

#slide("CONTEXTE")[
  *Test :* {case_title}
  *Attendu :* {case_expected}
]

= Section 1
#slide[Slide 1.0]
== Subsection 1.1
#slide[Slide 1.1]
= Section 2
== Subsection 2.1
#slide[Slide 2.1]
"""

# --- GENERATION ---
count = 0
for theme, scenarios_list in scenarios.items():
    import_path = THEMES[theme]
    for case in scenarios_list:
        filename = f"{OUTPUT_DIR}/test_SIDEBAR_DEEP_{case['id']}.typ"
        with open(filename, "w") as f:
            f.write(typst_template.format(
                import_path=import_path,
                case_title=case['title'],
                case_opts=case['opts'],
                case_expected=case['expected']
            ))
        count += 1

print(f"Généré {count} tests profonds pour la Sidebar.")
