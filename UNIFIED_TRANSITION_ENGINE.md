# Spécification Technique : Moteur de Transition Unifié (Presentate)

## 1. Contexte & Périmètre
Ce projet vise à harmoniser la génération des diapositives de transition pour les **5 thèmes suivants uniquement** :
- `sidebar`, `miniframes`, `split`, `progressive-outline`, `custom-transition`.

## 2. API des Options (Dictionnaire `transitions`)
L'utilisateur configure les transitions via un dictionnaire unique. Voici les options qui doivent être supportées de manière identique par les 5 thèmes :

```typst
transitions: (
  enabled: true,         // Activation globale.
  mode: "outline",       // "outline" (le plan) ou "title-card" (titre seul).
  max-level: 2,          // Profondeur de déclenchement (basé sur le mapping).
  show-all: false,       // Philosophie : Roadmap complète (true) vs Focus (false).
  show-numbering: true,  // Afficher/masquer les numéros (1., 1.1, etc.).
  background: "theme",   // "theme" (couleur principale), "none" (blanc), ou une couleur.
)
```

## 3. Logique Métier & Mapping

### 3.1. Déclenchement Dynamique
Le moteur utilise `is-role(mapping, level, role)` pour savoir si un titre doit déclencher une slide :
- Une slide est générée si le niveau du titre est inférieur ou égal à `max-level`.
- **Note** : Le `max-level` se réfère aux niveaux de titre Typst (1, 2, 3), pas aux noms logiques.

### 3.2. Visibilité Hiérarchique (Le Focus "Pilier")
En mode `mode: "outline"`, le moteur applique ces règles de visibilité automatique pour garantir l'orientation de l'auditeur :

| Rôle Mappé | Si `show-all: true` | Si `show-all: false` |
| :--- | :--- | :--- |
| **"part"** | `"all"` (Tout voir) | **`"all"`** (Toujours visible pour le contexte) |
| **"section"** | `"all"` | `"current-parent"` (Voisins du même parent) |
| **"subsection"** | `"all"` | `"current"` (Uniquement l'élément actif) |

### 3.3. Le mode "Title-Card"
Si `mode: "title-card"`, le composant ignore `progressive-outline` et génère une slide avec le `h.body` centré, utilisant une taille de police massive (ex: 2.5em).

## 4. Implémentation du Rendu (Composant Central)

Le fichier `src/components/transition-engine.typ` doit fournir une fonction `render-transition(...)` qui :
1.  **Vérifie les priorités** : Hook utilisateur > Options du moteur.
2.  **Assure le Zéro-Jitter** : Utilise un bloc avec alignement absolu (`top+left`) et des marges fixes pour que le texte ne saute pas d'une slide à l'autre.
3.  **Gère les orphelins** : Utilise le correctif permettant d'afficher une sous-section même si sa section parente est absente.

## 5. Protocole de Test et Validation

Le répertoire `assets/tests/structure_stress_test/` est le juge de paix.

### 5.1. Scénarios à valider prioritairement
- **D01 (Skip Level)** : Vérifier que la transition affiche la Part parente et la Sous-section orpheline.
- **D02 (Mapping Overflow)** : Vérifier que les niveaux non mappés sont absents des transitions.
- **E01 (Isolation)** : Vérifier que les titres internes aux slides ne déclenchent aucune transition.
- **Test Mode Title-Card** : Créer un test spécifique vérifiant que le plan disparaît au profit d'un titre unique centré.

## 6. Critères d'Acceptation
- **Homogénéité** : Un changement de `show-all: true` vers `false` doit produire le même effet visuel sur les 5 thèmes.
- **Robustesse** : Le passage direct de L1 à L3 ne doit jamais produire de slide vide.
- **Élégance** : En mode focus (`show-all: false`), les Parties (L1) restent visibles pour ne pas perdre l'auditeur.

---
*Spécification mise à jour le 18 Janvier 2026.*
