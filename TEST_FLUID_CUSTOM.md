# 🧪 Guide de Test - FluidCustom Feature

## ✅ Test 1 : Accès à la modal

### Depuis la page Ruler
1. Lancer l'app : `flutter run`
2. Aller sur "Règlette" (page principale)
3. Cliquer sur l'icône 🧪 en haut à droite de l'AppBar
4. **Résultat attendu** : La modal "Mes fluides personnalisés" s'ouvre

### Depuis la page Advanced Ruler
1. Aller sur "Règlette avancée"
2. Cliquer sur l'icône 🧪 en haut à droite
3. **Résultat attendu** : La même modal s'ouvre

---

## ✅ Test 2 : Création d'un fluide personnalisé

1. Ouvrir la modal
2. Cliquer sur "Créer un fluide"
3. **Résultat attendu** : Un nouveau fluide vide apparaît en mode édition

### Remplir le formulaire
1. **Nom** : Saisir "Mon R410A perso"
2. **Fluide 1** : Sélectionner "R32" dans le dropdown
3. **Quantité 1** : Saisir "70"
4. **Fluide 2** : Sélectionner "R125"
5. **Quantité 2** : Saisir "30"
6. **Total affiché** : Doit être "100.0%" en vert ✅

### Valider
1. Cliquer sur le bouton vert (✓)
2. **Résultat attendu** :
   - Le fluide passe en mode lecture
   - On voit les 2 fluides avec leurs pourcentages
   - Une barre de progression colorée en bas

---

## ✅ Test 3 : Validation automatique

### Test avec total incorrect
1. Créer un nouveau fluide
2. Mettre R32 à 50% et R125 à 30% (total = 80%)
3. **Résultat attendu** :
   - Badge total en rouge "80.0%"
   - Message d'erreur : "Le total doit être 100%"
   - Bouton de validation (✓) grisé/désactivé

### Test avec fluide non sélectionné
1. Créer un nouveau fluide
2. Laisser un dropdown vide
3. **Résultat attendu** :
   - Message d'erreur : "1 fluide(s) non sélectionné(s)"
   - Bouton de validation désactivé

---

## ✅ Test 4 : Auto-équilibrage

1. Créer un nouveau fluide
2. Sélectionner 3 fluides (ex: R32, R125, R134a)
3. Ne pas remplir les quantités (ou mettre n'importe quoi)
4. Cliquer sur "Équilibrer automatiquement"
5. **Résultat attendu** :
   - Les 3 quantités passent à 33.3%
   - Total = 100.0% (vert)

---

## ✅ Test 5 : Ajout/Suppression de fluides

### Ajouter un fluide
1. En mode édition, cliquer sur "Ajouter un fluide"
2. **Résultat attendu** : Une nouvelle ligne apparaît (max 5)

### Supprimer un fluide
1. Cliquer sur l'icône poubelle rouge à droite d'une ligne
2. **Résultat attendu** : La ligne disparaît (min 2)

---

## ✅ Test 6 : Modification d'un fluide

1. Créer et valider un fluide
2. Cliquer sur le bouton "Modifier" (✏️)
3. **Résultat attendu** : Le fluide repasse en mode édition
4. Modifier le nom et les quantités
5. Cliquer sur ✓ pour valider
6. **Résultat attendu** : Les modifications sont appliquées

### Annulation
1. Modifier un fluide
2. Cliquer sur le bouton rouge (✕)
3. **Résultat attendu** : Les modifications sont annulées

---

## ✅ Test 7 : Suppression d'un fluide

1. Créer un fluide et le valider
2. Cliquer sur le bouton "Supprimer" (🗑️)
3. **Résultat attendu** :
   - Une boîte de dialogue de confirmation apparaît
   - "Êtes-vous sûr de vouloir supprimer ce fluide personnalisé ?"
4. Cliquer sur "Supprimer"
5. **Résultat attendu** : Le fluide disparaît de la liste

---

## ✅ Test 8 : Persistance des données

1. Créer 2-3 fluides personnalisés
2. Fermer la modal
3. Fermer complètement l'app
4. Relancer l'app
5. Ouvrir la modal
6. **Résultat attendu** : Les fluides créés sont toujours là

---

## ✅ Test 9 : Interface responsive

### Sur petit écran (mobile)
1. Tester sur un émulateur mobile ou redimensionner la fenêtre
2. **Résultat attendu** :
   - Pas d'overflow
   - Le bouton "Créer un fluide" est en pleine largeur
   - Tout est lisible

### Sur grand écran
1. Tester sur desktop ou tablet
2. **Résultat attendu** :
   - La modal a une largeur max de 800px
   - Centré à l'écran

---

## ✅ Test 10 : Vérification des 59 fluides

1. En mode édition d'un fluide
2. Ouvrir le dropdown "Fluide"
3. **Résultat attendu** :
   - Liste de 59 fluides disponibles
   - R22, R32, R134a, R290, R410A, R470A, R717, etc.
   - Pas de mélanges dans la liste (seulement fluides purs)

---

## ✅ Test 11 : Barre de progression visuelle

1. Créer un fluide avec 3 fluides :
   - R32 : 50% (bleu)
   - R125 : 30% (vert)
   - R134a : 20% (orange)
2. **Résultat attendu** :
   - Barre avec 3 couleurs distinctes
   - Proportions visuelles correctes (50%, 30%, 20%)

---

## 🐛 Problèmes Courants

### La modal ne s'ouvre pas
- Vérifier que `initializeDependencies()` est appelé dans `main.dart`
- Vérifier la console pour les erreurs

### Les fluides ne se sauvegardent pas
- Vérifier les permissions SharedPreferences
- Vérifier les logs pour les erreurs de sérialisation

### Erreurs de compilation
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📊 Scénario Complet

### Créer un mélange R410A personnalisé
1. Ouvrir la modal
2. Créer un fluide
3. Nom : "R410A custom"
4. Fluide 1 : R32 → 69.8%
5. Fluide 2 : R125 → 30.2%
6. Valider ✓
7. **Vérifier** :
   - Barre de progression : 70% bleu + 30% vert
   - Badge "100.0%" en vert
   - Les pourcentages affichés

### Créer un mélange complexe
1. Créer un nouveau fluide
2. Nom : "Mélange 5 fluides"
3. Ajouter 3 fluides supplémentaires (total 5)
4. Sélectionner : R32, R125, R134a, R1234yf, R1234ze
5. Cliquer sur "Équilibrer automatiquement"
6. **Vérifier** : Chaque fluide = 20%
7. Valider ✓

---

## ✅ Checklist Finale

- [ ] Modal s'ouvre depuis Ruler
- [ ] Modal s'ouvre depuis Advanced Ruler
- [ ] Création d'un fluide fonctionne
- [ ] Validation refuse les totaux ≠ 100%
- [ ] Auto-équilibrage fonctionne
- [ ] Ajout/suppression de fluides fonctionne
- [ ] Modification d'un fluide fonctionne
- [ ] Suppression avec confirmation fonctionne
- [ ] Persistance après redémarrage fonctionne
- [ ] 59 fluides disponibles dans les dropdowns
- [ ] Pas d'overflow sur mobile
- [ ] Barre de progression colorée correcte

---

🎉 **Si tous les tests passent, l'implémentation est complète et fonctionnelle !**
