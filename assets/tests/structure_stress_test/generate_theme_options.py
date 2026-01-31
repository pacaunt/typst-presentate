import os

# --- CONFIGURATION ---
OUTPUT_DIR = "assets/tests/structure_stress_test"
THEMES = {
    "sidebar": "../../../src/themes/structured/sidebar.typ",
    "miniframes": "../../../src/themes/structured/miniframes.typ",
    "split": "../../../src/themes/structured/split.typ",
    "progressive-outline": "../../../src/themes/structured/progressive-outline.typ",
}

# --- THEME SPECIFIC SCENARIOS ---
scenarios = {
    "sidebar": [
        {
            "id": "LogoBottom",
            "title": "Logo en Bas",
            "opts": 'logo: circle(radius: 20pt, fill: white), logo-position: "bottom", width: 20%',
            "desc": "Test de l'affichage du logo en bas de la sidebar.",
            "expected": "Un cercle blanc doit apparaître en bas de la barre latérale."
        },
        {
            "id": "OutlineCustom",
            "title": "Outline Sidebar Custom",
            "opts": 'outline-options: (spacing: (v-between-1-1: 2em, indent-2: 3em))',
            "desc": "Test de la personnalisation de l'outline interne à la sidebar.",
            "expected": "Les titres de niveau 1 doivent être très espacés, et le niveau 2 très indenté."
        }
    ],
    "miniframes": [
        {
            "id": "NavFullCenter",
            "title": "Navigation Full Center",
            "opts": 'navigation: (style: "full", align-mode: "center", dots-align: "center", fill: rgb("#2980b9"))',
            "desc": "Style 'full' avec alignement centré pour les titres et les points.",
            "expected": "Barre de navigation centrée, occupant toute la largeur."
        },
        {
            "id": "MarkersDiamond",
            "title": "Marqueurs Losanges",
            "opts": 'navigation: (marker-shape: "diamond", marker-size: 6pt, active-color: rgb("#e67e22"))',
            "desc": "Test des marqueurs en forme de losange orange.",
            "expected": "Les points de navigation sont des losanges."
        },
        {
            "id": "NoTitles",
            "title": "Navigation Sans Titres",
            "opts": 'navigation: (show-level1-titles: false, show-level2-titles: false)',
            "desc": "Masquage des titres dans la barre de miniframes pour ne garder que les points.",
            "expected": "Seuls les points (dots) doivent apparaître dans la barre de navigation."
        }
    ],
    "split": [
        {
            "id": "ThreeCols",
            "title": "Header 3 Colonnes",
            "opts": 'header-columns: (1fr, 2fr, 1fr), primary: rgb("#8e44ad")',
            "desc": "Test d'un header split avec 3 colonnes de largeurs inégales.",
            "expected": "Header divisé en 3 zones distinctes avec le ratio 1:2:1."
        },
        {
            "id": "Aspect43",
            "title": "Aspect Ratio 4:3",
            "opts": 'aspect-ratio: "4-3"',
            "desc": "Changement du format de la présentation en 4:3.",
            "expected": "La diapositive doit être plus carrée (format traditionnel)."
        }
    ],
    "progressive-outline": [
        {
            "id": "ComplexFooter",
            "title": "Footer Complexe",
            "opts": 'footer: grid(columns: (1fr, 1fr), align: (left, right), [Confidentiel], [Page #context counter(page).display()])',
            "desc": "Utilisation d'une grille complexe dans le footer.",
            "expected": "Footer avec 'Confidentiel' à gauche et le numéro de page à droite."
        }
    ]
}

# --- TEMPLATE ---
typst_template = """
#import "{import_path}": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: {case_title}],
  author: [Gemini Agent],
  {case_opts},
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `{theme}`
  *Option testée :* `{case_title}`
  
  *Description :* 
  {case_desc}

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    {case_expected}
  ]
]

= Section A
#slide[Slide A.1]
== Subsection A.1
#slide[Slide A.1.1]
#slide[Slide A.1.2]
= Section B
#slide[Slide B.1]
"""

# --- GENERATION ---
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

count = 0
for theme, scenarios_list in scenarios.items():
    import_path = THEMES[theme]
    for case in scenarios_list:
        filename = f"{OUTPUT_DIR}/test_OPTION_{theme}_{case['id']}.typ"
        
        file_content = typst_template.format(
            import_path=import_path,
            theme=theme,
            case_title=case['title'],
            case_desc=case['desc'],
            case_opts=case['opts'],
            case_expected=case['expected']
        )

        with open(filename, "w") as f:
            f.write(file_content)
        count += 1

print(f"Succès : {count} nouveaux fichiers de tests d'options générés.")