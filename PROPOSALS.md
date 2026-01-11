# Propositions d'évolutions pour Presentate

Ce document détaille les fonctionnalités inspirées de LaTeX Beamer à intégrer dans le package pour améliorer la flexibilité du sommaire progressif et des thèmes.

---

## 1. Évolutions de la fonction `progressive-outline`

L'objectif est d'ajouter ces paramètres à la fonction existante dans `src/progressive-outline.typ`.

### A. Sommaire Animé (`animated`)
Permet de découvrir le plan étape par étape sur une diapositive de transition.
- **Paramètre** : `animated: bool` (défaut: `false`)
- **Fonctionnement** : Insère un `#pause` entre chaque élément rendu.
- **Usage** : 
  ```typ
  #progressive-outline(animated: true)
  ```

### B. Marqueurs Personnalisables (`marker`)
Ajoute un symbole visuel devant chaque entrée du sommaire selon son état.
- **Paramètre** : `marker: (state, level) => content`
- **Exemple** :
  ```typ
  marker: (state, level) => {
    if state == "active" { sym.arrow.r }
    else if state == "completed" { sym.checkmark }
    else { sym.circle.filled.small }
  }
  ```

### C. Profondeur Maximale (`depth`)
Limite la profondeur du sommaire sans avoir à désactiver manuellement chaque niveau.
- **Paramètre** : `depth: int` (1, 2 ou 3)
- **Usage** : `#progressive-outline(depth: 2)` (ignore le niveau 3 même s'il est dans le cache).

### D. Filtrage Avancé (`filter`)
Permet d'exclure certains titres basés sur leur contenu, leur hiérarchie ou leurs étiquettes (labels).
- **Paramètre** : `filter: (heading) => bool` (défaut: `none`)
- **Fonctionnement** : Pour chaque entrée du cache, la fonction `progressive-outline` appelle ce prédicat. Si celui-ci renvoie `false`, le titre est ignoré.
- **Exemples d'usage** : 
  - **Par contenu** : `filter: h => h.body != [Annexes]`
  - **Par étiquette (Label)** : `filter: h => h.label != <no-outline>` (nécessite le stockage du champ `label` dans le cache).
  - **Par logique complexe** : `filter: h => h.level < 3 or h.counter.at(0) == 2` (n'affiche les niveaux 3 que pour la deuxième section).

---

## 2. Barre de navigation (Mini-frames)

Une fonctionnalité de thème qui utilise le cache pour dessiner des indicateurs de progression.

- **Le concept** : Dessiner une ligne de petits cercles en haut de chaque slide.
- **Logique** : 
  1. Lire le cache des titres.
  2. Compter le nombre de pages entre `h[i].location()` et `h[i+1].location()`.
  3. Afficher autant de points que de pages, en mettant en évidence la page actuelle.
