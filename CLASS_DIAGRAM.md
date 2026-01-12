# Diagramme de Classes - Application CampusWork

## 📊 DIAGRAMME DE CLASSES UML

```mermaid
classDiagram
    %% ========== ENUMS ==========
    class UserRole {
        <<enumeration>>
        STUDENT
        LECTURER
        ADMIN
    }

    class ProjectStatus {
        <<enumeration>>
        PRIVATE
        PUBLIC
    }

    class ProjectState {
        <<enumeration>>
        EN_COURS
        TERMINE
        NOTE
    }

    class GroupType {
        <<enumeration>>
        PROJECT
        STUDY
        COLLABORATION
    }

    class NotificationType {
        <<enumeration>>
        LIKE
        COMMENT
        EVALUATION
        APPROVAL
        PROJECT_UPDATE
        MESSAGE
    }

    %% ========== CLASSES PRINCIPALES ==========
    
    %% Classe User (Classe mère)
    class User {
        <<abstract>>
        -String userId
        -String username
        -String firstName
        -String lastName
        -String email
        -String phonenumber
        -String password
        -UserRole userRole
        -bool isApproved
        -DateTime createdAt
        -DateTime updatedAt
        
        +bool isLecturer()
        +bool isAdmin()
        +bool isStudent()
        +String fullName()
    }

    %% Classes héritées de User
    class Student {
        -String matricule
        -DateTime birthday
        -String level
        -String semester
        -String section
        -String filiere
        -String academicYear
        -String? githubLink
        -String? linkedinLink
        -List~String~ otherLinks
    }

    class Lecturer {
        -String uniteDenseignement
        -String section
        -String? evaluationGrid
        -String? validationRequirements
        -String? finalSubmissionRequirements
    }

    class Admin {
        -String? department
        -List~String~ permissions
        
        +fromJson(Map) Admin
        +toJson() Map
        +copyWith() Admin
    }

    %% Classe Project
    class Project {
        -String? projectId
        -String projectName
        -String courseName
        -String description
        -String? category
        -String? imageUrl
        -String userId
        -List~String~ collaborators
        -String? architecturePatterns
        -String? uml
        -String? prototypeLink
        -String? downloadLink
        -ProjectStatus status
        -List~String~ resources
        -List~String~ prerequisites
        -String? powerpointLink
        -String? reportLink
        -String state
        -String? grade
        -String? lecturerComment
        -int likesCount
        -int commentsCount
        -String? createdAt
        -String? updatedAt
        
        +fromDatabase(Map) Project
        +fromJson(Map) Project
        +toDatabase() Map
        +toJson() Map
        +copyWith() Project
    }

    %% Classe Group
    class Group {
        -String? groupId
        -String name
        -String description
        -String createdBy
        -GroupType type
        -String? courseName
        -String? academicYear
        -String? section
        -List~String~ members
        -List~String~ projects
        -List~String~ evaluationCriteria
        -int maxMembers
        -bool isOpen
        -DateTime createdAt
        -DateTime? updatedAt
        
        +bool isFull()
        +bool hasProjects()
        +int memberCount()
        +int projectCount()
        +bool isMember(String userId)
        +bool isCreator(String userId)
        +fromMap(Map) Group
        +toMap() Map
        +copyWith() Group
    }

    %% Classe Comment
    class Comment {
        -String? commentId
        -String projectId
        -String userId
        -String userFullName
        -String content
        -DateTime createdAt
        
        +fromMap(Map) Comment
        +toMap() Map
    }

    %% Classe Notification
    class AppNotification {
        -String notificationId
        -String userId
        -String title
        -String message
        -NotificationType type
        -bool isRead
        -String? relatedId
        -DateTime createdAt
        
        +fromJson(Map) AppNotification
        +toJson() Map
        +copyWith() AppNotification
    }

    %% ========== SERVICES ==========
    
    %% Service d'authentification
    class AuthService {
        <<singleton>>
        -User? currentUser
        -DatabaseHelper dbHelper
        
        +init() Future~void~
        +loginUser(String, String) Future~User?~
        +registerUser(User) Future~bool~
        +logout() Future~void~
        +bool isLoggedIn()
        +getCurrentUser() User?
        +approveUser(String) Future~bool~
        +rejectUser(String) Future~bool~
        +getPendingUsers() Future~List~User~~
    }

    %% Service de synchronisation des données
    class DataSyncService {
        <<singleton>>
        +getGlobalData(String) Future~List~Map~~
        +saveGlobalData(String, List~Map~) Future~bool~
        +addToGlobalData(String, Map) Future~bool~
        +updateInGlobalData(String, String, Map, String) Future~bool~
        +removeFromGlobalData(String, String, String) Future~bool~
        +getLastSyncTime() Future~DateTime?~
        +forceSyncAll() Future~void~
        +getSyncStats() Future~Map~
    }

    %% Service de gestion des projets
    class ProjectService {
        <<singleton>>
        -List~Project~ projects
        -DataSyncService syncService
        
        +init() Future~void~
        +createProject(Project) Future~bool~
        +getAllProjectsAsync() Future~List~Project~~
        +getProjectsByUserAsync(String) Future~List~Project~~
        +updateProject(Project) Future~bool~
        +deleteProject(String) Future~bool~
        +searchProjects(String) List~Project~
        +evaluateProject(String, String, String?) Future~bool~
    }

    %% Service de gestion des groupes
    class GroupService {
        <<singleton>>
        -List~Group~ groups
        -DataSyncService syncService
        
        +init() Future~void~
        +createGroup(Group) Future~bool~
        +getAllGroupsAsync() Future~List~Group~~
        +getGroupsByCreatorAsync(String) Future~List~Group~~
        +addMemberToGroup(String, String) Future~bool~
        +removeMemberFromGroup(String, String) Future~bool~
        +updateGroup(Group) Future~bool~
        +deleteGroup(String) Future~bool~
    }

    %% Service de commentaires
    class CommentService {
        <<singleton>>
        -List~Comment~ comments
        
        +init() Future~void~
        +addComment(Comment) Future~bool~
        +getCommentsByProject(String) Future~List~Comment~~
        +getCommentsByUser(String) Future~List~Comment~~
        +deleteComment(String) Future~bool~
    }

    %% Service de notifications
    class NotificationService {
        <<singleton>>
        -List~AppNotification~ notifications
        
        +init() Future~void~
        +createNotification(AppNotification) Future~bool~
        +getNotificationsByUser(String) Future~List~AppNotification~~
        +markAsRead(String) Future~bool~
        +getUnreadCountByUser(String) int
        +createApprovalNotification(String, bool) Future~void~
    }

    %% Service de tutoriels
    class TutorialService {
        <<static>>
        +isTutorialCompleted(UserRole) Future~bool~
        +markTutorialCompleted(UserRole) Future~void~
        +resetTutorial(UserRole) Future~void~
        +resetAllTutorials() Future~void~
        +shouldShowTutorial(UserRole) Future~bool~
    }

    %% ========== RELATIONS ==========
    
    %% Héritage
    User <|-- Student : extends
    User <|-- Lecturer : extends
    User <|-- Admin : extends

    %% Associations avec les enums
    User --> UserRole : uses
    Project --> ProjectStatus : uses
    Project --> ProjectState : uses
    Group --> GroupType : uses
    AppNotification --> NotificationType : uses

    %% Relations entre les classes principales
    Project --> User : belongsTo
    Project --> Comment : hasMany
    Group --> User : createdBy
    Group --> User : hasMembers
    Group --> Project : contains
    Comment --> Project : belongsTo
    Comment --> User : writtenBy
    AppNotification --> User : sentTo

    %% Relations avec les services
    AuthService --> User : manages
    ProjectService --> Project : manages
    ProjectService --> DataSyncService : uses
    GroupService --> Group : manages
    GroupService --> DataSyncService : uses
    CommentService --> Comment : manages
    NotificationService --> AppNotification : manages
    TutorialService --> UserRole : uses

    %% Dépendances entre services
    ProjectService --> AuthService : uses
    GroupService --> AuthService : uses
    CommentService --> AuthService : uses
    NotificationService --> AuthService : uses
```

## 📋 DESCRIPTION DES CLASSES

### **Classes Modèles (Domain Layer)**

#### **User (Classe Abstraite)**
- **Rôle** : Classe de base pour tous les utilisateurs
- **Attributs** : Informations communes (nom, email, mot de passe, etc.)
- **Méthodes** : Getters pour vérifier le type d'utilisateur

#### **Student, Lecturer, Admin**
- **Rôle** : Spécialisations de User avec attributs spécifiques
- **Student** : Informations académiques (matricule, niveau, filière)
- **Lecturer** : Informations d'enseignement (unité, grille d'évaluation)
- **Admin** : Permissions et département

#### **Project**
- **Rôle** : Représente un projet académique
- **Attributs** : Détails du projet, collaborateurs, ressources, évaluation
- **Méthodes** : Conversion JSON/Database, copie avec modifications

#### **Group**
- **Rôle** : Représente un groupe de travail
- **Attributs** : Membres, projets associés, critères d'évaluation
- **Méthodes** : Gestion des membres, vérifications d'état

#### **Comment**
- **Rôle** : Commentaire sur un projet
- **Attributs** : Contenu, auteur, projet associé

#### **AppNotification**
- **Rôle** : Notification système
- **Attributs** : Type, message, statut de lecture

### **Classes Services (Business Layer)**

#### **AuthService (Singleton)**
- **Rôle** : Gestion de l'authentification et des utilisateurs
- **Fonctionnalités** : Login, register, approbation, gestion des sessions

#### **DataSyncService (Singleton)**
- **Rôle** : Synchronisation globale des données
- **Fonctionnalités** : Stockage partagé, synchronisation temps réel

#### **ProjectService (Singleton)**
- **Rôle** : Gestion des projets
- **Fonctionnalités** : CRUD projets, recherche, évaluation

#### **GroupService (Singleton)**
- **Rôle** : Gestion des groupes
- **Fonctionnalités** : CRUD groupes, gestion des membres

#### **CommentService (Singleton)**
- **Rôle** : Gestion des commentaires
- **Fonctionnalités** : CRUD commentaires, association aux projets

#### **NotificationService (Singleton)**
- **Rôle** : Gestion des notifications
- **Fonctionnalités** : Création, envoi, marquage comme lu

#### **TutorialService (Static)**
- **Rôle** : Gestion des tutoriels par rôle
- **Fonctionnalités** : Suivi de progression, réinitialisation

## 🔗 RELATIONS PRINCIPALES

### **Héritage**
- `User` ← `Student`, `Lecturer`, `Admin`

### **Composition/Agrégation**
- `Project` contient `Comment` (1:N)
- `Group` contient `Project` (N:N)
- `Group` contient `User` comme membres (N:N)

### **Associations**
- `Project` → `User` (créateur)
- `Comment` → `User` (auteur)
- `Comment` → `Project` (projet commenté)
- `AppNotification` → `User` (destinataire)

### **Dépendances de Services**
- Tous les services → `AuthService` (authentification)
- `ProjectService`, `GroupService` → `DataSyncService` (synchronisation)

## 🏗️ PATTERNS ARCHITECTURAUX

### **Singleton Pattern**
- Tous les services principaux (AuthService, ProjectService, etc.)

### **Factory Pattern**
- Méthodes `fromJson()`, `fromMap()`, `fromDatabase()`

### **Repository Pattern**
- Services agissent comme repositories pour leurs modèles

### **Observer Pattern**
- DataSyncService pour la synchronisation globale

Cette architecture respecte les principes SOLID et facilite la maintenance, les tests et l'évolution de l'application.