import os

# --- CONFIGURATION ---
OUTPUT_DIR = "assets/tests/structure_stress_test"
THEMES = {
    "sidebar": "../../../src/themes/sidebar.typ",
    "miniframes": "../../../src/themes/miniframes.typ",
    "split": "../../../src/themes/split.typ",
    "progressive-outline": "../../../src/themes/progressive-outline.typ",
    "custom-transition": "../../../src/themes/custom-transition.typ",
}

# --- SCENARIOS MATRIX ---
scenarios = [
    {
        "id": "A01_flat",
        "title": "Structure Plate (0 Niveaux)",
        "desc": "Aucun titre (=). Uniquement des slides brutes.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
#slide("Slide 1")[Contenu Slide 1]
#slide("Slide 2")[Contenu Slide 2]
""",
        "expected": "Barre de navigation vide (ou titre doc). Sidebar vide. Pas de transition."
    },
    {
        "id": "A02_orphan_start",
        "title": "Slide Orpheline (Avant H1)",
        "desc": "Une slide placée AVANT le premier titre de niveau 1.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
#slide("Orpheline")[Je suis avant la Section A]
= Section A
#slide("Slide A")[Dans Section A]
""",
        "expected": "Slide 1: Nav vide/neutre. Slide 2: Nav active sur Section A."
    },
    {
        "id": "B01_L1_only",
        "title": "Niveau 1 Uniquement",
        "desc": "Plusieurs sections, aucune sous-section.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section A
#slide[Slide A]
= Section B
#slide[Slide B]
""",
        "expected": "Navigation simple. Pas de sous-menus déroulants/points secondaires."
    },
    {
        "id": "B02_L2_only",
        "title": "Niveau 2 Uniquement (Démarrage Profond)",
        "desc": "Document commençant directement par == Titre.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
== Subsection 1
#slide[Slide 1]
== Subsection 2
#slide[Slide 2]
""",
        "expected": "Fonctionnel. La nav peut afficher '...' ou vide pour le parent manquant."
    },
    {
        "id": "B03_Standard_L1_L2",
        "title": "Standard (L1 + L2)",
        "desc": "Hiérarchie classique Section -> Subsection.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section A
#slide[Slide A]
== Sub A.1
#slide[Slide A.1]
= Section B
== Sub B.1
#slide[Slide B.1]
""",
        "expected": "Comportement nominal du thème."
    },
    {
        "id": "C01_sandwich_L1_L2",
        "title": "Sandwich L1 -> Slide -> L2",
        "desc": "Une slide insérée APRES L1 mais AVANT le premier L2.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section A
#slide("Sandwich")[Cette slide appartient à Section A, mais n'a pas de sous-section.]
== Subsection A.1
#slide("Normal")[Dans A.1]
""",
        "expected": "Slide Sandwich: Nav indique Section A, pas de sous-section active."
    },
    {
        "id": "C02_sandwich_mixed",
        "title": "Sandwich Complexe",
        "desc": "Slides placées à tous les niveaux d'interstice.",
        "mapping": "(part: 1, section: 2, subsection: 3)",
        "content": """
= Part I
#slide[Slide Niveau 1]
== Section A
#slide[Slide Niveau 2]
=== Subsection a
#slide[Slide Niveau 3]
""",
        "expected": "Chaque slide doit hériter du titre de son parent direct le plus proche."
    },
    {
        "id": "D01_skip_L1_to_L3",
        "title": "Saut L1 -> L3 (Pas de L2)",
        "desc": "On passe de = Part à === Subsection directement.",
        "mapping": "(part: 1, section: 2, subsection: 3)",
        "content": """
= Part I
=== Subsection Directe (1.0.1)
#slide[Slide Deep]
""",
        "expected": "Pas de crash. Numérotation type 1.0.1. Nav indique Part I et Sub."
    },
    {
        "id": "D02_mixed_mapping_overflow",
        "title": "Mapping vs Contenu (Overflow)",
        "desc": "Contenu L3 présent, mais Mapping configuré pour L1/L2 uniquement.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section 1
== Subsection 1.1
=== Detail 1.1.1 (Non mappé)
#slide[Slide Profonde]
""",
        "expected": "L3 est ignoré par la nav. Titre slide = 'Subsection 1.1'. Pas 'Detail'."
    },
     {
        "id": "D03_auto_title_logic",
        "title": "Test Auto-Title vs Manual",
        "desc": "Mélange de slides avec titre manuel et titre auto.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section Auto
#slide[Doit avoir titre 'Section Auto']
#slide("Manuel")[Doit avoir titre 'Manuel']
== Sub Auto
#slide[Doit avoir titre 'Sub Auto']
""",
        "expected": "Priorité : Titre Manuel > Titre Auto (Niveau le plus bas mappé)."
    },
    {
        "id": "E01_headings_inside_slide",
        "title": "Titres INTERNES à la Slide",
        "desc": "Utilisation de =, ==, === DANS le contenu d'une slide.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section Externe (Navigation)
#slide("Test Isolation")[
  Ceci est du texte normal.
  = Titre H1 Interne (Ne doit pas casser la nav)
  Texte sous H1.
  == Titre H2 Interne
  Texte sous H2.
]
#slide("Check")[Slide de vérification après le chaos.]
""",
        "expected": "Les titres internes doivent être stylisés MAIS ignorés par la navigation et ne pas créer de nouvelles sections."
    },
    {
        "id": "F01_deep_structure_L4",
        "title": "Structure Profonde (Niveau 4+)",
        "desc": "Utilisation de ==== et ===== à l'extérieur des slides.",
        "mapping": "(section: 1, subsection: 2)",
        "content": """
= Section 1
== Subsection 1.1
=== Sub-sub (L3)
==== Deep Level (L4)
#slide[Slide Profonde L4]
===== Very Deep (L5)
#slide[Slide Profonde L5]
""",
        "expected": "Pas de crash. Les niveaux > 3 sont ignorés par la nav mais le contenu s'affiche. Titre slide hérité de L2 ou L3 selon mapping."
    }
]

# --- TEMPLATE ---
typst_template = """
#import "{import_path}": template, slide

#show: template.with(
  title: [Test {case_id}: {case_title}],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: {mapping},
  auto-title: true, // Force auto-title pour verification
  {extra_args}
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* {case_title}
  
  *Description :* 
  {case_desc}

  *Mapping Actif :*
  `{mapping}`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    {case_expected}
  ]
]

// --- CONTENU DU TEST ---
{content}
"""

# --- GENERATION ---
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

count = 0
for theme, path in THEMES.items():
    for case in scenarios:
        # Theme specific overrides
        extra = ""
        if theme == "split":
            extra = 'primary: rgb("#003366"), secondary: rgb("#336699"),'
        elif theme == "sidebar":
             extra = 'side: "left", active-color: rgb("#f39c12"),'
        elif theme == "miniframes":
             extra = 'color: rgb("#1a5fb4"),'

        filename = f"{OUTPUT_DIR}/test_{theme}_{case['id']}.typ"
        
        file_content = typst_template.format(
            import_path=path,
            case_id=case['id'],
            case_title=case['title'],
            case_desc=case['desc'],
            mapping=case['mapping'],
            case_expected=case['expected'],
            content=case['content'],
            extra_args=extra
        )

        with open(filename, "w") as f:
            f.write(file_content)
        count += 1

print(f"Succès : {count} fichiers de tests générés dans {OUTPUT_DIR}")