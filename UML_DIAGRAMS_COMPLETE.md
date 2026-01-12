# Diagrammes UML Complets - Application CampusWork

## 🎯 DIAGRAMME DE CAS D'UTILISATION

```mermaid
graph TB
    %% Acteurs
    Student[👨‍🎓 Étudiant]
    Lecturer[👨‍🏫 Enseignant]
    Admin[👨‍💼 Administrateur]
    System[🖥️ Système]

    %% Cas d'utilisation - Authentification
    subgraph "Authentification"
        UC1[S'inscrire]
        UC2[Se connecter]
        UC3[Se déconnecter]
        UC4[Réinitialiser mot de passe]
    end

    %% Cas d'utilisation - Gestion des projets
    subgraph "Gestion des Projets"
        UC5[Créer un projet]
        UC6[Modifier un projet]
        UC7[Supprimer un projet]
        UC8[Consulter les projets]
        UC9[Rechercher des projets]
        UC10[Évaluer un projet]
        UC11[Commenter un projet]
        UC12[Liker un projet]
    end

    %% Cas d'utilisation - Gestion des groupes
    subgraph "Gestion des Groupes"
        UC13[Créer un groupe]
        UC14[Rejoindre un groupe]
        UC15[Quitter un groupe]
        UC16[Gérer les membres]
        UC17[Assigner des projets]
    end

    %% Cas d'utilisation - Administration
    subgraph "Administration"
        UC18[Approuver les inscriptions]
        UC19[Gérer les utilisateurs]
        UC20[Consulter les statistiques]
        UC21[Modérer le contenu]
        UC22[Créer des annonces]
    end

    %% Cas d'utilisation - Communication
    subgraph "Communication"
        UC23[Envoyer des notifications]
        UC24[Créer des sondages]
        UC25[Répondre aux sondages]
        UC26[Consulter le feed]
    end

    %% Relations Étudiant
    Student --> UC1
    Student --> UC2
    Student --> UC3
    Student --> UC5
    Student --> UC6
    Student --> UC7
    Student --> UC8
    Student --> UC9
    Student --> UC11
    Student --> UC12
    Student --> UC14
    Student --> UC15
    Student --> UC25
    Student --> UC26

    %% Relations Enseignant
    Lecturer --> UC2
    Lecturer --> UC3
    Lecturer --> UC8
    Lecturer --> UC9
    Lecturer --> UC10
    Lecturer --> UC11
    Lecturer --> UC13
    Lecturer --> UC16
    Lecturer --> UC17
    Lecturer --> UC24
    Lecturer --> UC26

    %% Relations Administrateur
    Admin --> UC2
    Admin --> UC3
    Admin --> UC18
    Admin --> UC19
    Admin --> UC20
    Admin --> UC21
    Admin --> UC22
    Admin --> UC8
    Admin --> UC13

    %% Relations Système
    System --> UC4
    System --> UC23

    %% Inclusions et Extensions
    UC2 -.->|<<include>>| UC4
    UC5 -.->|<<extend>>| UC17
    UC13 -.->|<<include>>| UC16
```

## 🔄 DIAGRAMMES D'ACTIVITÉ

### **Activité 1 : Processus de Connexion**

```mermaid
flowchart TD
    Start([Début]) --> Input[Saisir identifiants]
    Input --> Validate{Valider les données}
    Validate -->|Invalide| Error[Afficher erreur]
    Error --> Input
    Validate -->|Valide| Auth[Authentifier utilisateur]
    Auth --> CheckUser{Utilisateur existe?}
    CheckUser -->|Non| Error
    CheckUser -->|Oui| CheckApproval{Compte approuvé?}
    CheckApproval -->|Non| ErrorApproval[Erreur: Compte non approuvé]
    ErrorApproval --> End([Fin])
    CheckApproval -->|Oui| CheckTutorial{Premier login?}
    CheckTutorial -->|Oui| ShowTutorial[Afficher tutoriel]
    ShowTutorial --> NavigateDashboard[Naviguer vers dashboard]
    CheckTutorial -->|Non| NavigateDashboard
    NavigateDashboard --> CheckRole{Quel rôle?}
    CheckRole -->|Étudiant| StudentDashboard[Dashboard Étudiant]
    CheckRole -->|Enseignant| LecturerDashboard[Dashboard Enseignant]
    CheckRole -->|Admin| AdminDashboard[Dashboard Admin]
    StudentDashboard --> End
    LecturerDashboard --> End
    AdminDashboard --> End
```

### **Activité 2 : Création d'un Projet**

```mermaid
flowchart TD
    Start([Début]) --> CheckAuth{Utilisateur connecté?}
    CheckAuth -->|Non| Login[Rediriger vers login]
    Login --> End([Fin])
    CheckAuth -->|Oui| Form[Afficher formulaire projet]
    Form --> FillForm[Remplir les informations]
    FillForm --> Validate{Valider les données}
    Validate -->|Invalide| ShowError[Afficher erreurs]
    ShowError --> Form
    Validate -->|Valide| CreateProject[Créer le projet]
    CreateProject --> SaveLocal[Sauvegarder localement]
    SaveLocal --> SyncGlobal[Synchroniser globalement]
    SyncGlobal --> CheckSync{Sync réussie?}
    CheckSync -->|Non| ShowWarning[Avertissement sync]
    ShowWarning --> Success
    CheckSync -->|Oui| Success[Projet créé avec succès]
    Success --> Notify[Notifier les collaborateurs]
    Notify --> UpdateUI[Mettre à jour l'interface]
    UpdateUI --> End
```

### **Activité 3 : Gestion des Groupes**

```mermaid
flowchart TD
    Start([Début]) --> CheckRole{Quel rôle?}
    CheckRole -->|Étudiant| StudentFlow[Flux Étudiant]
    CheckRole -->|Enseignant/Admin| TeacherFlow[Flux Enseignant/Admin]
    
    StudentFlow --> ViewGroups[Voir groupes disponibles]
    ViewGroups --> SelectGroup[Sélectionner un groupe]
    SelectGroup --> CheckCapacity{Groupe plein?}
    CheckCapacity -->|Oui| ErrorFull[Erreur: Groupe plein]
    ErrorFull --> ViewGroups
    CheckCapacity -->|Non| JoinGroup[Rejoindre le groupe]
    JoinGroup --> UpdateMembers[Mettre à jour les membres]
    UpdateMembers --> NotifyMembers[Notifier les membres]
    NotifyMembers --> End([Fin])
    
    TeacherFlow --> CreateGroup[Créer un groupe]
    CreateGroup --> SetParameters[Définir les paramètres]
    SetParameters --> SaveGroup[Sauvegarder le groupe]
    SaveGroup --> SyncData[Synchroniser les données]
    SyncData --> ManageMembers[Gérer les membres]
    ManageMembers --> AssignProjects[Assigner des projets]
    AssignProjects --> End
```

## 📋 DIAGRAMMES DE SÉQUENCE

### **Séquence 1 : Authentification Utilisateur**

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant LP as LoginPage
    participant AS as AuthService
    participant DB as Database
    participant TS as TutorialService
    participant R as Router

    U->>LP: Saisir identifiants
    LP->>AS: loginUser(username, password)
    AS->>DB: Rechercher utilisateur
    DB-->>AS: Données utilisateur
    AS->>AS: Vérifier mot de passe
    alt Authentification réussie
        AS-->>LP: User object
        LP->>TS: shouldShowTutorial(userRole)
        TS-->>LP: boolean
        alt Premier login
            LP->>R: Naviguer vers tutoriel
        else Login habituel
            LP->>R: Naviguer vers dashboard
        end
    else Authentification échouée
        AS-->>LP: null
        LP->>U: Afficher erreur
    end
```

### **Séquence 2 : Création et Synchronisation de Projet**

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant UI as Interface
    participant PS as ProjectService
    participant DSS as DataSyncService
    participant SP as SharedPreferences
    participant NS as NotificationService

    U->>UI: Créer nouveau projet
    UI->>PS: createProject(project)
    PS->>PS: Valider les données
    PS->>DSS: refreshProjects()
    DSS->>SP: getGlobalData('projects')
    SP-->>DSS: Données globales
    DSS-->>PS: Projets actualisés
    PS->>PS: Ajouter nouveau projet
    PS->>DSS: saveGlobalData('projects', projects)
    DSS->>SP: Sauvegarder globalement
    SP-->>DSS: Confirmation
    DSS-->>PS: Succès
    PS->>SP: Sauvegarder localement
    SP-->>PS: Confirmation
    PS-->>UI: Projet créé
    UI->>NS: Notifier collaborateurs
    NS->>NS: Créer notifications
    UI->>U: Confirmation succès
```

### **Séquence 3 : Gestion des Groupes avec Synchronisation**

```mermaid
sequenceDiagram
    participant E as Étudiant
    participant P as Professeur
    participant GS as GroupService
    participant DSS as DataSyncService
    participant UI1 as Interface Étudiant
    participant UI2 as Interface Professeur

    P->>UI2: Créer groupe
    UI2->>GS: createGroup(group)
    GS->>DSS: refreshGroups()
    GS->>GS: Ajouter groupe
    GS->>DSS: saveGlobalData('groups', groups)
    DSS-->>GS: Synchronisation réussie
    GS-->>UI2: Groupe créé
    
    Note over DSS: Données synchronisées globalement
    
    E->>UI1: Actualiser groupes
    UI1->>GS: getAllGroupsAsync()
    GS->>DSS: getGlobalData('groups')
    DSS-->>GS: Données globales
    GS-->>UI1: Liste des groupes
    UI1->>E: Afficher groupes (incluant nouveau)
    
    E->>UI1: Rejoindre groupe
    UI1->>GS: addMemberToGroup(groupId, userId)
    GS->>DSS: refreshGroups()
    GS->>GS: Ajouter membre
    GS->>DSS: saveGlobalData('groups', groups)
    DSS-->>GS: Synchronisation réussie
    GS-->>UI1: Membre ajouté
```

## 🏗️ DIAGRAMME DE DÉPLOIEMENT

```mermaid
graph TB
    %% Couche Client
    subgraph "Couche Client"
        subgraph "Appareils Mobiles"
            Android[📱 Android Device<br/>- Flutter App<br/>- SQLite Local<br/>- SharedPreferences]
            iOS[📱 iOS Device<br/>- Flutter App<br/>- SQLite Local<br/>- UserDefaults]
        end
        
        subgraph "Navigateurs Web"
            Chrome[🌐 Chrome Browser<br/>- Flutter Web<br/>- IndexedDB<br/>- LocalStorage]
            Safari[🌐 Safari Browser<br/>- Flutter Web<br/>- IndexedDB<br/>- LocalStorage]
        end
    end

    %% Couche Application
    subgraph "Couche Application Flutter"
        subgraph "Presentation Layer"
            Screens[📺 Screens<br/>- Student Dashboard<br/>- Lecturer Dashboard<br/>- Admin Dashboard]
            Widgets[🧩 Widgets<br/>- Custom Components<br/>- Reusable UI Elements]
        end
        
        subgraph "Business Layer"
            Services[⚙️ Services<br/>- AuthService<br/>- ProjectService<br/>- GroupService<br/>- DataSyncService]
            Models[📋 Models<br/>- User, Student, Lecturer<br/>- Project, Group<br/>- Comment, Notification]
        end
        
        subgraph "Data Layer"
            LocalDB[🗄️ Local Database<br/>- SQLite<br/>- DatabaseHelper<br/>- CRUD Operations]
            Storage[💾 Local Storage<br/>- SharedPreferences<br/>- File System<br/>- Cache Management]
        end
    end

    %% Couche Infrastructure
    subgraph "Infrastructure Locale"
        subgraph "Synchronisation"
            SyncEngine[🔄 Sync Engine<br/>- DataSyncService<br/>- Global State Management<br/>- Conflict Resolution]
        end
        
        subgraph "Sécurité"
            Security[🔐 Security Layer<br/>- Password Hashing<br/>- Data Encryption<br/>- Session Management]
        end
        
        subgraph "Utilitaires"
            Utils[🛠️ Utilities<br/>- Page Transitions<br/>- Themes<br/>- Helpers]
        end
    end

    %% Services Externes (Futurs)
    subgraph "Services Externes (Extension Future)"
        subgraph "Cloud Services"
            Firebase[☁️ Firebase<br/>- Authentication<br/>- Firestore Database<br/>- Cloud Storage<br/>- Push Notifications]
            
            API[🌐 REST API Server<br/>- Node.js/Express<br/>- Authentication JWT<br/>- Data Validation]
        end
        
        subgraph "Base de Données Cloud"
            CloudDB[🗄️ Cloud Database<br/>- PostgreSQL/MongoDB<br/>- Data Replication<br/>- Backup & Recovery]
        end
        
        subgraph "Services Tiers"
            OAuth[🔑 OAuth Providers<br/>- Google OAuth<br/>- Microsoft OAuth<br/>- GitHub OAuth]
            
            CDN[📡 CDN<br/>- Static Assets<br/>- Image Storage<br/>- File Downloads]
        end
    end

    %% Connexions
    Android -.-> Services
    iOS -.-> Services
    Chrome -.-> Services
    Safari -.-> Services
    
    Screens --> Services
    Widgets --> Services
    Services --> Models
    Services --> LocalDB
    Services --> Storage
    Services --> SyncEngine
    
    LocalDB --> Security
    Storage --> Security
    SyncEngine --> Security
    
    %% Connexions futures (pointillées)
    SyncEngine -.->|Future| Firebase
    Services -.->|Future| API
    API -.->|Future| CloudDB
    Services -.->|Future| OAuth
    Storage -.->|Future| CDN

    %% Styles
    classDef current fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef future fill:#f3e5f5,stroke:#4a148c,stroke-width:2px,stroke-dasharray: 5 5
    
    class Android,iOS,Chrome,Safari,Screens,Widgets,Services,Models,LocalDB,Storage,SyncEngine,Security,Utils current
    class Firebase,API,CloudDB,OAuth,CDN future
```

## 📊 DIAGRAMME D'ARCHITECTURE SYSTÈME

```mermaid
graph TB
    %% Architecture en couches
    subgraph "Architecture CampusWork"
        subgraph "Couche Présentation"
            UI[🖥️ Interface Utilisateur<br/>- Flutter Widgets<br/>- Responsive Design<br/>- Material Design]
        end
        
        subgraph "Couche Métier"
            BL[⚙️ Logique Métier<br/>- Services Singleton<br/>- Business Rules<br/>- Data Validation]
        end
        
        subgraph "Couche Données"
            DL[🗄️ Couche Données<br/>- Local Database<br/>- Global Sync<br/>- Cache Management]
        end
        
        subgraph "Couche Infrastructure"
            IL[🛠️ Infrastructure<br/>- Navigation<br/>- Security<br/>- Utilities]
        end
    end

    UI --> BL
    BL --> DL
    BL --> IL
    DL --> IL
```

## 🔄 PATTERNS DE DÉPLOIEMENT

### **Pattern 1 : Architecture Locale (Actuelle)**
- **Avantages** : Pas de dépendance réseau, données privées, performance
- **Inconvénients** : Synchronisation limitée, pas de backup cloud

### **Pattern 2 : Architecture Hybride (Future)**
- **Avantages** : Meilleur des deux mondes, synchronisation cloud
- **Inconvénients** : Complexité accrue, gestion des conflits

### **Pattern 3 : Architecture Cloud-First (Extension)**
- **Avantages** : Synchronisation temps réel, backup automatique
- **Inconvénients** : Dépendance réseau, coûts d'infrastructure

## 📱 DÉPLOIEMENT MULTI-PLATEFORME

### **Plateformes Supportées**
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **Web** (Chrome, Safari, Firefox)
- 🔄 **Desktop** (Windows, macOS, Linux) - Future

### **Stratégie de Déploiement**
1. **Phase 1** : Application mobile native (Android/iOS)
2. **Phase 2** : Version web responsive
3. **Phase 3** : Applications desktop
4. **Phase 4** : Intégration cloud et services externes

Cette architecture modulaire et évolutive permet une croissance progressive de l'application tout en maintenant la qualité et la performance.