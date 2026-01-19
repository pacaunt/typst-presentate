# Spécification Technique : Moteur de Transition Unifié (Presentate)

## 1. Contexte & Périmètre
Ce projet vise à harmoniser la génération des diapositives de transition pour les **5 thèmes suivants uniquement** :
- `sidebar`, `miniframes`, `split`, `progressive-outline`, `custom-transition`.

**Limite technique** : Le système supporte au maximum 3 niveaux de transition (généralement Partie, Section, Sous-section).

## 2. API des Options (Dictionnaire `transitions`)
L'utilisateur configure les transitions via un dictionnaire unique. Voici les options qui doivent être supportées de manière identique par les 5 thèmes :

```typst
transitions: (
  enabled: true,         // Activation globale.
  max-level: 3,          // Niveau de titre Typst maximum (ex: 3 = '=', '==' et '==='). Basé sur le mapping. Si max-level: 2 : diapo de transition pour le niveau 1 et 2 uniquement. Si le mapping n'a que 2 niveaux mais que max-level: 3, c'est le mapping qui gagne. 
  show-numbering: true,  // Afficher/masquer les numéros (1., 1.1, etc.).
  background: "theme",   // "theme" (couleur principale du thème), "none" (blanc), ou une couleur.
  filter: none,          // Fonction (heading) => bool pour exclure des titres.

  // --- CONFIGURATION PAR TYPE DE DIAPOSITIVE DE TRANSITION - La configuration ci-dessous est celle voulue par défaut ---
  parts: (
    enabled: true,       // ou false si on ne veut pas de diapositive transition pour les parts. Non pris en compte si le mapping ne contient pas de part
    visibility: "(part: "all", section: "none", subsection: "none"),
    background: "theme",
  ),
  sections: (
    enabled: true,
    visibility: (part: "current", section: "current", subsection: "current-parent"), 
    background: "theme",
  ),
  subsections: (
    enabled: true,
    visibility: (part: "current", section: "current", subsection: "current-parent"), 
    background: "theme",
  ),

  // --- STYLE ---
  style: (
    inactive-opacity: 0.3,
    completed-opacity: 0.6,
    active-weight: "bold",
    active-color: none,   // Si none, résolution automatique (voir section 2.2).
  ),

)
```

## 3. Logique Métier & Mapping

### 3.1. Description des Options de Base

| Option | Type | Description |
| :--- | :--- | :--- |
| **`enabled`** | `bool` | **Interrupteur général.** Si `false`, aucune transition n'est générée. |
| **`max-level`** | `int` | **Limite de profondeur absolue.** Maximum 3. |
| **`show-numbering`** | `bool` | **Afficher/masquer les numéros (1., 1.1, etc.)** true par défaut. |
| **`background`** | `string\|color` | `"theme"` (couleur principale), `"none"` (fond par défaut) ou couleur Typst. |
| **`filter`** | `function` | Si définie, les titres pour lesquels `filter(h)` est `false` ne déclenchent pas de slide et n'apparaissent pas dans l'outline. |

### 3.2. Standardisation et Hiérarchie des Couleurs
Pour assurer la cohérence entre les thèmes (qui nomment leurs variables différemment), le moteur suit cette hiérarchie pour la couleur active (`active-color`) :
1.  Valeur explicite dans `transitions.style.active-color`.
2.  Variable `accent` du thème.
3.  Variable `primary` du thème.
4.  Couleur `black` (repli ultime).

Si tu trouves cela plus satisfaisant, il est aussi possible de changer les thèmes eux-mêmes, afin qu'ils utilisent tous des noms de variables cohérents entre eux. 

### 3.3. Déclenchement Dynamique
Le moteur utilise `is-role(mapping, level, role)` pour savoir si un titre doit déclencher une slide :
- Une slide est générée si le niveau du titre est inférieur ou égal à `max-level`.
- **Note** : Le `max-level` se réfère aux niveaux de titre Typst (1, 2, 3), pas aux noms logiques. Il peut être 1, 2 ou 3, sachant que 3 n'est possible que si le mapping à 3 niveaux de structure. 

### 3.4. Les Modes Techniques (Valeurs du dictionnaire)
- `"all"` : Affiche **tous** les titres du niveau.
- `"current"` : Affiche uniquement le titre **actif**.
- `"current-parent"` : Affiche les titres du niveau appartenant au **parent actif**.
- `"none"` : Masque le niveau.

### 3.5. Adaptabilité au Mapping
Le moteur lie les clés `parts`, `sections`, `subsections` aux niveaux réels via le `mapping` du thème. Les niveaux non mappés sont forcés à `"none"`.

## 4. Implémentation du Rendu (Composant Central)

Le fichier `src/components/transition-engine.typ` doit fournir une fonction `render-transition(...)` qui :
1.  **Vérifie les priorités** : Hook utilisateur > Options du moteur.
2.  **Assure le Zéro-Jitter** : Utilise un bloc avec alignement absolu (`top+left`) et des marges fixes pour que le texte ne saute pas d'une slide à l'autre.
3.  **Gère les orphelins** : Utilise le correctif permettant d'afficher une sous-section même si sa section parente est absente.

## 5. Documentation & Exemples

### 5.1. Matrice de Test (Transition Stress Test)
Le développement doit s'appuyer sur une automatisation rigoureuse de la génération des tests pour garantir la non-régression sur les 5 thèmes.

- **Automatisation** : Il faut adapter le script Python existant `assets/tests/structure_stress_test/generate_comprehensive.py` pour créer un nouveau générateur dédié (`generate_transitions.py`). 
- **Auto-Documentation** : Chaque fichier de test généré doit obligatoirement commencer par une **Slide de Contexte** affichant :
    1.  **Options testées** : Le dictionnaire `transitions` complet passé au template.
    2.  **Structure & Mapping** : Le mapping actif et la hiérarchie de titres utilisée.
    3.  **Résultat attendu** : Une description précise de ce que l'utilisateur doit observer (ex: "La transition de Section doit afficher le plan en mode 'focus' sur fond bleu").
- **Objectif** : Permettre une comparaison visuelle instantanée entre l'attendu (décrit sur la slide) et l'observé (le comportement réel du thème).

**Scénarios de validation obligatoires :**
- **Custom Dictionary and Mapping** : Test de configurations complexes de mappings et de transitions pour valider la flexibilité totale.
- **Mapping Adaptability** : Vérifier que les transitions fonctionnent sans erreur avec des mappings à 2 niveaux (`section`, `subsection`) et des mappings décalés (commençant au niveau 2 ou 3).
- **Skip Levels** : Vérifier le rendu de l'outline sur une slide de transition déclenchée par une sous-section dont la section parente est manquante.
- **Filter Logic** : Confirmer qu'un titre filtré ne déclenche AUCUNE slide et n'apparaît dans aucun outline de transition.

Tu peux t'inspirer du script actuel pour inventer des scénarios. 

---
*Spécification mise à jour le 18 Janvier 2026.*
