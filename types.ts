/*
export enum UserRole {
  STUDENT = 'STUDENT',
  LECTURER = 'LECTURER',
  ADMIN = 'ADMIN'
}

export enum ProjectStatus {
  IN_PROGRESS = 'En cours',
  COMPLETED = 'Terminé'
}

export type LetterGrade = 'A' | 'B+' | 'B' | 'C+' | 'C' | 'D+' | 'D' | 'F';

export type PostCategory = 'Aide' | 'Discussion' | 'Annonce' | 'Exercices';

export interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  avatar?: string;
  matricule?: string;
  level?: string;
  pending?: boolean;
  banned?: boolean;
  bio?: string;
  status?: string;
  cycle?: string;
}

export interface Collaborator {
  name: string;
  email: string;
  level?: string;
}

export interface Review {
  id: string;
  authorId: string;
  authorName: string;
  rating: number;
  comment: string;
  createdAt: string;
}

export interface Project {
  id: string;
  title: string;
  description: string;
  category: string; 
  subject: string;
  status: ProjectStatus;
  isEvaluated?: boolean;
  authorId: string;
  authorName: string;
  members: number;
  collaborators: Collaborator[];
  githubLink?: string;
  linkedinLink?: string;
  otherLink?: string;
  lecturerName?: string;
  lecturerEmail?: string;
  studentLevel?: string;
  grade?: LetterGrade;
  tags: string[];
  createdAt: string;
  likes?: number;
  likedBy?: string[];
  reviews?: Review[];
  
  // 🆕 NOUVEAUX CHAMPS MÉDIA
  coverImage?: string;      // URL de l'image de couverture (Cloudinary)
  demoVideo?: string;       // URL de la vidéo de démo (Cloudinary ou YouTube/Vimeo)
  videoType?: 'upload' | 'youtube' | 'vimeo'; // Type de vidéo
  
  // 🆕 FICHIERS JOINTS
  attachedFile?: {
    url: string;
    name: string;
    type: 'pdf' | 'docx' | 'pptx';
    size: number; // en bytes
    uploadedAt: string;
  };
  
  // 🆕 TECHNOLOGIES
  technologies?: string[]; // Ex: ['React', 'Node.js', 'MongoDB']
}

export interface Post {
  id: string;
  authorId: string;
  authorName: string;
  title: string;
  content: string;
  category: PostCategory;
  likes: number;
  likedBy?: string[];
  comments: number;
  createdAt: string;
  replies?: Comment[];
  deadline?: string;
  blocked?: boolean;
}

export interface Comment {
  id: string;
  authorId: string;
  authorName: string;
  content: string;
  createdAt: string;
  likes?: number;
  likedBy?: string[];
  replies?: Comment[];
}

export type View = 'dashboard' | 'projects' | 'users' | 'posts' | 'settings' | 'discussion_detail' | 'project_detail' | 'project_edit';
export type Language = 'FR' | 'EN';
*/

/*export enum UserRole {
  STUDENT = 'STUDENT',
  LECTURER = 'LECTURER',
  ADMIN = 'ADMIN'
}

export enum ProjectStatus {
  IN_PROGRESS = 'En cours',
  COMPLETED = 'Terminé'
}

export type LetterGrade = 'A' | 'B+' | 'B' | 'C+' | 'C' | 'D+' | 'D' | 'F';

export type PostCategory = 'Aide' | 'Discussion' | 'Annonce' | 'Exercices';

export interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  avatar?: string;
  matricule?: string;
  level?: string;
  pending?: boolean;
  banned?: boolean;
  bio?: string;
  status?: string;
  cycle?: string;
  department?: string; // 🆕 Département académique
}

export interface Collaborator {
  name: string;
  email: string;
  level?: string;
}

export interface Review {
  id: string;
  authorId: string;
  authorName: string;
  rating: number;
  comment: string;
  createdAt: string;
}

export interface Project {
  id: string;
  title: string;
  description: string;
  category: string; 
  subject: string;
  status: ProjectStatus;
  isEvaluated?: boolean;
  authorId: string;
  authorName: string;
  members: number;
  collaborators: Collaborator[];
  githubLink?: string;
  linkedinLink?: string;
  otherLink?: string;
  lecturerName?: string;
  lecturerEmail?: string;
  studentLevel?: string;
  grade?: LetterGrade;
  tags: string[];
  createdAt: string;
  likes?: number;
  likedBy?: string[];
  reviews?: Review[];
  
  // 🆕 NOUVEAUX CHAMPS MÉDIA
  coverImage?: string;      // URL de l'image de couverture (Cloudinary)
  demoVideo?: string;       // URL de la vidéo de démo (Cloudinary ou YouTube/Vimeo)
  videoType?: 'upload' | 'youtube' | 'vimeo'; // Type de vidéo
  
  // 🆕 FICHIERS JOINTS
  attachedFile?: {
    url: string;
    name: string;
    type: 'pdf' | 'docx' | 'pptx';
    size: number; // en bytes
    uploadedAt: string;
  };
  
  // 🆕 TECHNOLOGIES
  technologies?: string[]; // Ex: ['React', 'Node.js', 'MongoDB']
}

export interface Post {
  id: string;
  authorId: string;
  authorName: string;
  title: string;
  content: string;
  category: PostCategory;
  likes: number;
  likedBy?: string[];
  comments: number;
  createdAt: string;
  replies?: Comment[];
  deadline?: string;
  blocked?: boolean;
}

export interface Comment {
  id: string;
  authorId: string;
  authorName: string;
  content: string;
  createdAt: string;
  likes?: number;
  likedBy?: string[];
  replies?: Comment[];
  isPinned?: boolean; // 🆕 Commentaire épinglé
  parentId?: string;  // 🆕 ID du commentaire parent (pour les réponses)
}

export type View = 'dashboard' | 'projects' | 'users' | 'posts' | 'settings' | 'discussion_detail' | 'project_detail' | 'project_edit';
export type Language = 'FR' | 'EN';*/

// src/types.ts - CORRECTIONS DES INTERFACES

export enum UserRole {
  STUDENT = 'student',
  LECTURER = 'lecturer',
  ADMIN = 'admin',
}

export enum ProjectStatus {
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed',
}

export type Language = 'EN' | 'FR';
export type View = 'dashboard' | 'projects' | 'project_edit' | 'project_detail' | 
  'posts' | 'discussion_detail' | 'users' | 'settings';
export type PostCategory = 'Discussion' | 'Aide' | 'Annonce' | 'Exercices';
export type LetterGrade = 'A' | 'B+' | 'B' | 'C+' | 'C' | 'D+' | 'D' | 'F';

// ✅ Interface User corrigée
export interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  role: UserRole;
  matricule?: string;
  level?: string;
  department?: string; // ✅ Ajouté
  status?: string;
  cycle?: string;
  bio?: string;
  pending?: boolean;
  banned?: boolean;
  created_at?: string; // ✅ snake_case pour Supabase
  updated_at?: string;
}

// ✅ Interface AttachedFile corrigée
export interface AttachedFile {
  url: string;
  name: string;
  size: number;
  type: string;
}

// ✅ Interface Collaborator
export interface Collaborator {
  name: string;
  email: string;
  level?: string;
}

// ✅ Interface Review
export interface Review {
  id: string;
  authorId: string;
  authorName: string;
  rating: number;
  comment: string;
  createdAt: string;
}

// ✅ Interface Project corrigée avec snake_case pour Supabase
export interface Project {
  id: string;
  authorId: string; // Utilisé en frontend
  author_id?: string; // Version Supabase
  authorName: string;
  author_name?: string; // Version Supabase
  title: string;
  description: string;
  category: string;
  subject?: string;
  status: ProjectStatus;
  grade?: LetterGrade;
  coverImage?: string;
  cover_image?: string; // Version Supabase
  demoVideo?: string;
  demo_video?: string; // Version Supabase
  videoType?: 'youtube' | 'vimeo' | 'upload';
  video_type?: string; // Version Supabase
  githubLink?: string;
  github_link?: string;
  linkedinLink?: string;
  linkedin_link?: string;
  otherLink?: string;
  other_link?: string;
  lecturerName?: string;
  lecturer_name?: string;
  lecturerEmail?: string;
  lecturer_email?: string;
  studentLevel?: string;
  student_level?: string;
  collaborators?: Collaborator[];
  technologies?: string[];
  tags?: string[];
  attachedFile?: AttachedFile;
  attached_file?: AttachedFile; // Version Supabase
  reviews?: Review[];
  likes?: number;
  likedBy?: string[];
  liked_by?: string[]; // Version Supabase
  isEvaluated?: boolean;
  is_evaluated?: boolean; // Version Supabase
  createdAt: string;
  created_at?: string; // Version Supabase
  updated_at?: string;
}

// ✅ Interface Comment
export interface Comment {
  id: string;
  authorId: string;
  authorName: string;
  content: string;
  createdAt: string;
  likes?: number;
  likedBy?: string[];
  replies?: Comment[];
}

// ✅ Interface Post corrigée
export interface Post {
  id: string;
  authorId: string;
  author_id?: string; // Version Supabase
  authorName: string;
  author_name?: string;
  title: string;
  content: string;
  category: PostCategory;
  likes: number;
  likedBy?: string[];
  liked_by?: string[]; // Version Supabase
  comments: number;
  replies?: Comment[];
  blocked?: boolean;
  createdAt: string;
  created_at?: string; // Version Supabase
}

// ✅ Helper pour convertir Supabase → Frontend
export const normalizeProject = (proj: any): Project => {
  return {
    id: proj.id,
    authorId: proj.author_id || proj.authorId,
    authorName: proj.author_name || proj.authorName,
    title: proj.title,
    description: proj.description,
    category: proj.category,
    subject: proj.subject,
    status: proj.status,
    grade: proj.grade,
    coverImage: proj.cover_image || proj.coverImage,
    demoVideo: proj.demo_video || proj.demoVideo,
    videoType: proj.video_type || proj.videoType,
    githubLink: proj.github_link || proj.githubLink,
    linkedinLink: proj.linkedin_link || proj.linkedinLink,
    otherLink: proj.other_link || proj.otherLink,
    lecturerName: proj.lecturer_name || proj.lecturerName,
    lecturerEmail: proj.lecturer_email || proj.lecturerEmail,
    studentLevel: proj.student_level || proj.studentLevel,
    collaborators: proj.collaborators || [],
    technologies: proj.technologies || [],
    tags: proj.tags || [],
    attachedFile: proj.attached_file || proj.attachedFile,
    reviews: proj.reviews || [],
    likes: proj.likes || 0,
    likedBy: proj.liked_by || proj.likedBy || [],
    isEvaluated: proj.is_evaluated || proj.isEvaluated || false,
    createdAt: proj.created_at || proj.createdAt,
  };
};

// ✅ Helper pour convertir Frontend → Supabase
export const denormalizeProject = (proj: Partial<Project>): any => {
  return {
    author_id: proj.authorId,
    author_name: proj.authorName,
    title: proj.title,
    description: proj.description,
    category: proj.category,
    subject: proj.subject,
    status: proj.status,
    grade: proj.grade,
    cover_image: proj.coverImage,
    demo_video: proj.demoVideo,
    video_type: proj.videoType,
    github_link: proj.githubLink,
    linkedin_link: proj.linkedinLink,
    other_link: proj.otherLink,
    lecturer_name: proj.lecturerName,
    lecturer_email: proj.lecturerEmail,
    student_level: proj.studentLevel,
    collaborators: proj.collaborators || [],
    technologies: proj.technologies || [],
    tags: proj.tags || [],
    attached_file: proj.attachedFile,
    reviews: proj.reviews || [],
    likes: proj.likes || 0,
    liked_by: proj.likedBy || [],
    is_evaluated: proj.isEvaluated || false,
  };
};