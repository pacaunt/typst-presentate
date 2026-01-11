# Propositions d'évolutions pour Presentate

Ce document détaille les fonctionnalités inspirées de LaTeX Beamer et d'autres systèmes de présentation à intégrer dans le package pour améliorer la flexibilité du sommaire progressif et des thèmes.

---

## 1. Évolutions de la fonction `progressive-outline`

L'objectif est d'ajouter ces paramètres à la fonction existante dans `src/progressive-outline.typ`.

### A. Sommaire Animé (`animated`)
Permet de découvrir le plan étape par étape sur une diapositive de transition.
- **Paramètre** : `animated: bool` (défaut: `false`)
- **Fonctionnement** : Insère un `#pause` (ou équivalent `uncover`) entre chaque élément rendu pour dévoiler la structure progressivement.
- **Usage** : 
  ```typ
  #progressive-outline(animated: true)
  ```

### B. Marqueurs Personnalisables (`marker`)
Ajoute un symbole visuel devant chaque entrée du sommaire selon son état et son niveau.
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
- **Pré-requis technique** : Mettre à jour `register-heading` pour stocker le champ `label` et potentiellement d'autres métadonnées.
- **Exemples d'usage** : 
  - **Par contenu** : `filter: h => h.body != [Annexes]`
  - **Par étiquette (Label)** : `filter: h => h.label != <no-outline>`
  - **Par logique complexe** : `filter: h => h.level < 3 or h.counter.at(0) == 2`

### E. Interactivité (Liens Cliquables)
Rend les titres du sommaire cliquables pour naviguer rapidement vers la section correspondante dans le PDF.
- **Paramètre** : `clickable: bool` (défaut: `true`)
- **Fonctionnement** : Enveloppe le contenu du titre dans un `#link(location)[...]`.
- **Intérêt** : Facilite la navigation non-linéaire pendant la présentation ou la lecture du PDF.

### F. Opacité Progressive (`opacity`)
Simplifie la gestion visuelle des états inactifs en utilisant la transparence plutôt que des couleurs explicites.
- **Paramètres** : `opacity-inactive: float`, `opacity-completed: float`
- **Exemple** : `opacity-inactive: 0.5` rend les titres futurs semi-transparents automatiquement.

### G. Gestion de la longueur des titres (`truncate` / `short-title`)
Les titres longs cassent souvent la mise en page des sidebars.
- **Option 1 (Troncature)** : `truncate: length` (ex: `20em`). Coupe le texte et ajoute "..." s'il dépasse.
- **Option 2 (Titre Court)** : Utiliser un dictionnaire de mapping ou un métadata personnalisé pour fournir une version courte du titre.

### H. Ajustement automatique (`fit-to-height`)
Empêche le sommaire de déborder verticalement de la page ou de la sidebar.
- **Paramètre** : `fit-to-height: bool`
- **Fonctionnement** : Calcule la hauteur totale disponible et applique un facteur d'échelle (`scale`) si le contenu dépasse, garantissant que tout le plan reste visible.

---

## 2. Nouveaux Composants Visuels

### A. Mini-frames (Navigation Dots)
Inspiré des thèmes "Frankfurt" ou "Berlin" de Beamer.
- **Concept** : Afficher une série de petits symboles (ronds, carrés) sous le titre de la section. Chaque symbole représente une diapositive de cette section.
- **États** :
  - Rempli/Actif : Diapositive courante.
  - Rempli/Passé : Diapositive vue.
  - Vide : Diapositive à venir.
- **Défi technique** : Nécessite de connaître le nombre exact de diapositives par section (nécessite un calcul de contexte global ou une double compilation).

### B. Progress Bar (Barre de progression)
Une barre fine (généralement en bas ou en haut) indiquant le pourcentage d'avancement global de la présentation.
- **Intégration** : Peut être intégrée directement dans `progressive-outline` ou fournie comme un composant séparé.