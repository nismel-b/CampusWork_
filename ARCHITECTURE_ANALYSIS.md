# Architecture et Patterns - Application CampusWork

## 🏗️ ARCHITECTURE GÉNÉRALE

### Architecture Layered (En Couches)
L'application suit une **architecture en couches** bien structurée :

```
┌─────────────────────────────────────┐
│           PRESENTATION              │
│    (Screens, Widgets, Components)   │
├─────────────────────────────────────┤
│            BUSINESS                 │
│         (Services, Logic)           │
├─────────────────────────────────────┤
│             DATA                    │
│    (Models, Database, Storage)      │
├─────────────────────────────────────┤
│         INFRASTRUCTURE              │
│   (Navigation, Utils, Themes)       │
└─────────────────────────────────────┘
```

### Structure des Dossiers
```
lib/
├── auth/                 # Authentification
├── components/           # Composants réutilisables
├── database/            # Couche de données
├── model/               # Modèles de données
├── navigation/          # Routage et navigation
├── providers/           # Gestion d'état
├── screen/              # Écrans de l'application
├── services/            # Services métier
├── theme/               # Thèmes et styles
├── utils/               # Utilitaires
└── widgets/             # Widgets personnalisés
```

## 🎯 DESIGN PATTERNS UTILISÉS

### 1. **Singleton Pattern**
**Utilisation** : Services principaux
```dart
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
}
```
**Avantages** :
- Instance unique garantie
- Accès global aux services
- Gestion centralisée de l'état

### 2. **Factory Pattern**
**Utilisation** : Création d'objets complexes
```dart
factory User.fromMap(Map<String, dynamic> map) {
  return User(
    userId: map['userId'],
    username: map['username'],
    // ...
  );
}
```

### 3. **Repository Pattern**
**Utilisation** : Couche d'accès aux données
```dart
class ProjectService {
  final DataSyncService _syncService = DataSyncService();
  
  Future<List<Project>> getAllProjectsAsync() async {
    await refreshProjects();
    return List.unmodifiable(_projects);
  }
}
```

### 4. **Observer Pattern**
**Utilisation** : Gestion d'état avec StatefulWidget
```dart
class _StudentDashboardState extends State<StudentDashboard> 
    with TickerProviderStateMixin {
  // Observateurs d'animations et d'état
}
```

### 5. **Strategy Pattern**
**Utilisation** : Navigation basée sur les rôles
```dart
void _navigateBasedOnRole(UserRole role) async {
  switch (role) {
    case UserRole.student:
      context.go('/student-dashboard');
    case UserRole.lecturer:
      context.go('/lecturer-dashboard');
    case UserRole.admin:
      context.go('/admin-dashboard');
  }
}
```

### 6. **Builder Pattern**
**Utilisation** : Construction d'interfaces complexes
```dart
Widget _buildTutorialPage(TutorialPage page) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        _buildHeader(),
        _buildContent(),
        _buildActions(),
      ],
    ),
  );
}
```

### 7. **Facade Pattern**
**Utilisation** : Services simplifiés
```dart
class DataSyncService {
  Future<bool> saveGlobalData(String dataType, List<Map<String, dynamic>> data) async {
    // Simplifie l'accès aux données globales
  }
}
```

## 🔧 PRINCIPES SOLID APPLIQUÉS

### **S - Single Responsibility Principle**
✅ **Respecté** : Chaque classe a une responsabilité unique
- `AuthService` : Gestion de l'authentification uniquement
- `ProjectService` : Gestion des projets uniquement
- `TutorialService` : Gestion des tutoriels uniquement

### **O - Open/Closed Principle**
✅ **Respecté** : Extension sans modification
```dart
// Extensible via héritage
abstract class User {
  // Base commune
}

class Student extends User {
  // Spécialisation étudiant
}

class Lecturer extends User {
  // Spécialisation enseignant
}
```

### **L - Liskov Substitution Principle**
✅ **Respecté** : Substitution des sous-classes
```dart
User user = Student(...); // Substitution possible
User user = Lecturer(...); // Substitution possible
```

### **I - Interface Segregation Principle**
✅ **Respecté** : Interfaces spécialisées
```dart
// Interfaces spécifiques plutôt qu'une interface monolithique
abstract class Authenticatable {
  Future<bool> authenticate();
}

abstract class Authorizable {
  bool hasPermission(String permission);
}
```

### **D - Dependency Inversion Principle**
✅ **Respecté** : Dépendance vers les abstractions
```dart
class ProjectService {
  final DataSyncService _syncService; // Dépendance injectée
  
  ProjectService() : _syncService = DataSyncService();
}
```

## 🏛️ PATTERNS ARCHITECTURAUX

### **MVC (Model-View-Controller)**
- **Model** : Classes dans `lib/model/`
- **View** : Widgets dans `lib/screen/` et `lib/widgets/`
- **Controller** : Services dans `lib/services/`

### **Service Layer Pattern**
Services métier centralisés :
- `AuthService` : Authentification
- `ProjectService` : Gestion des projets
- `GroupService` : Gestion des groupes
- `DataSyncService` : Synchronisation des données

### **Data Access Object (DAO)**
```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  
  Future<Database> get database async {
    // Accès centralisé à la base de données
  }
}
```

## 🔄 PATTERNS DE SYNCHRONISATION

### **Global State Management**
```dart
class DataSyncService {
  // Gestion centralisée des données globales
  Future<List<Map<String, dynamic>>> getGlobalData(String dataType);
  Future<bool> saveGlobalData(String dataType, List<Map<String, dynamic>> data);
}
```

### **Cache-Aside Pattern**
```dart
Future<void> _loadProjects() async {
  // 1. Essayer le cache global
  final globalData = await _syncService.getGlobalData('projects');
  if (globalData.isNotEmpty) {
    _projects = globalData.map((json) => Project.fromJson(json)).toList();
    return;
  }
  
  // 2. Fallback vers le stockage local
  final prefs = await SharedPreferences.getInstance();
  // ...
}
```

## 🎨 PATTERNS UI/UX

### **Page Transitions Pattern**
```dart
class PageTransitions {
  static Page<T> fadeTransition<T extends Object?>(Widget child, GoRouterState state);
  static Page<T> slideTransition<T extends Object?>(Widget child, GoRouterState state);
  static Page<T> scaleTransition<T extends Object?>(Widget child, GoRouterState state);
}
```

### **Theme Pattern**
```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    // Configuration du thème clair
  );
  
  static ThemeData get darkTheme => ThemeData(
    // Configuration du thème sombre
  );
}
```

### **Component Pattern**
Composants réutilisables dans `lib/components/` et `lib/widgets/`

## 🔐 PATTERNS DE SÉCURITÉ

### **Authentication Pattern**
```dart
class AuthService {
  User? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  
  Future<User?> loginUser({required String username, required String password});
}
```

### **Authorization Pattern**
```dart
// Vérification des rôles
bool get isLecturer => userRole == UserRole.lecturer;
bool get isAdmin => userRole == UserRole.admin;
bool get isStudent => userRole == UserRole.student;
```

## 📱 PATTERNS FLUTTER SPÉCIFIQUES

### **StatefulWidget Pattern**
Gestion d'état local avec cycle de vie

### **Provider Pattern** (Préparé)
Structure prête pour la gestion d'état avec Provider dans `lib/providers/`

### **Hero Animation Pattern**
```dart
HeroAppLogo(
  heroTag: 'login_logo',
  size: 120,
  showText: false,
)
```

## 🎯 AVANTAGES DE CETTE ARCHITECTURE

### **Maintenabilité**
- Code organisé et modulaire
- Séparation claire des responsabilités
- Facilité de modification et d'extension

### **Testabilité**
- Services isolés et testables
- Dépendances injectables
- Logique métier séparée de l'UI

### **Scalabilité**
- Architecture extensible
- Ajout facile de nouvelles fonctionnalités
- Gestion centralisée des données

### **Réutilisabilité**
- Composants réutilisables
- Services partagés
- Patterns cohérents

## 🔮 ÉVOLUTIONS POSSIBLES

### **State Management**
- Migration vers Provider/Riverpod/Bloc
- Gestion d'état plus sophistiquée

### **Clean Architecture**
- Séparation plus stricte des couches
- Use Cases et Repositories

### **Microservices**
- API backend
- Services distribués

Cette architecture solide et bien structurée facilite la maintenance, les tests et l'évolution de l'application CampusWork.