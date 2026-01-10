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
Permet d'exclure certains titres basés sur leur contenu ou des tags.
- **Paramètre** : `filter: (heading) => bool`
- **Usage** : `#progressive-outline(filter: h => h.body != [Annexes])`

---

## 2. Nouveau Thème : "Custom Transitions"

Ce thème permettrait à l'utilisateur de définir lui-même le "look" de ses diapositives de changement de section.

### Interface proposée pour le `template` :
L'utilisateur peut passer des fonctions de rappel (callbacks) qui reçoivent le titre en cours et renvoient le contenu de la slide.

```typ
#import themes.progressive-outline: template

#show: template.with(
  // Personnalisation de la slide de Section (H1)
  on-section-change: (h) => {
    set align(center + horizon)
    grid(
      columns: (1fr, 1fr),
      image("section-hero.png"),
      [
        #text(size: 2em, weight: "bold", h.body)
        #v(1em)
        #progressive-outline(level-1-mode: "current")
      ]
    )
  },
  
  // Désactivation des slides de transition pour les sous-sections (H2)
  on-subsection-change: none, 
)
```

### Avantages :
1. **Flexibilité totale** : On sort du modèle rigide "Sommaire au milieu".
2. **Modularité** : On peut n'activer les transitions que pour le niveau 1.
3. **Identité visuelle** : Facilite la création de présentations avec une charte graphique forte.

---

## 3. Barre de navigation (Mini-frames)

Une fonctionnalité de thème qui utilise le cache pour dessiner des indicateurs de progression.

- **Le concept** : Dessiner une ligne de petits cercles en haut de chaque slide.
- **Logique** : 
  1. Lire le cache des titres.
  2. Compter le nombre de pages entre `h[i].location()` et `h[i+1].location()`.
  3. Afficher autant de points que de pages, en mettant en évidence la page actuelle.
