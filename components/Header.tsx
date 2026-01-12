/*import React from 'react';
import { ICONS } from '../constants';
import { User, UserRole } from '../types';

interface HeaderProps {
  user: User | null;
  onLogout: () => void;
}

const Header: React.FC<HeaderProps> = ({ user, onLogout }) => {
  const [darkMode, setDarkMode] = useState(false);

  // Charger la préférence au montage
  useEffect(() => {
    const savedMode = localStorage.getItem('darkMode');
    if (savedMode === 'true') {
      setDarkMode(true);
      document.documentElement.classList.add('dark');
    }
  }, []);

  const toggleDarkMode = () => {
    const newMode = !darkMode;
    setDarkMode(newMode);
    
    if (newMode) {
      document.documentElement.classList.add('dark');
      localStorage.setItem('darkMode', 'true');
    } else {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('darkMode', 'false');
    }
  };

  if (!user) return null;

  const getRoleLabel = (role: UserRole) => {
    switch (role) {
      case UserRole.ADMIN: return 'Administrateur';
      case UserRole.LECTURER: return 'Enseignant';
      case UserRole.STUDENT: return 'Étudiant';
      default: return 'Utilisateur';
    }
  };

  const getRoleColor = (role: UserRole) => {
    switch (role) {
      case UserRole.ADMIN: return 'bg-orange-100 text-orange-700 border-orange-200';
      case UserRole.LECTURER: return 'bg-purple-100 text-purple-700 border-purple-200';
      case UserRole.STUDENT: return 'bg-emerald-100 text-emerald-700 border-emerald-200';
      default: return 'bg-gray-100 text-gray-700 border-gray-200';
    }
  };

  return (
    <header className="h-20 bg-white/80 backdrop-blur-md border-b border-gray-200 flex items-center justify-between px-8 sticky top-0 z-10">
      <div className="flex items-center gap-4">
        {user.avatar ? (
          <img src={user.avatar} alt={user.name} className="w-10 h-10 rounded-full border-2 border-white shadow-sm" />
        ) : (
          <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 font-bold">
            {user.name.charAt(0)}
          </div>
        )}
        <div className="flex flex-col">
          <h2 className="text-lg font-bold text-gray-800 leading-tight">{user.name}</h2>
          <p className="text-xs text-gray-500 font-medium">{getRoleLabel(user.role)}</p>
        </div>
      </div>
      <div className="flex items-center gap-4">*/
        {/*<button
          onClick={toggleDarkMode}
          className="relative p-2.5 text-gray-400 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-all bg-gray-50 dark:bg-slate-800 rounded-xl group overflow-hidden"
          title={darkMode ? 'Mode Clair' : 'Mode Nuit'}
        >
          <div className="relative z-10">
            {darkMode ? (
              <svg className="w-5 h-5 animate-[spin_20s_linear_infinite]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
            ) : (
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
              </svg>
            )}
          </div>
          <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-purple-500 opacity-0 group-hover:opacity-20 transition-opacity"></div>
        </button>*/}

        {/* Notifications */}
       {/* <div className="relative group">
          <button className="p-2.5 text-gray-400 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors bg-gray-50 dark:bg-slate-800 rounded-xl">
            <ICONS.Bell />
            <span className="absolute top-2.5 right-2.5 w-2.5 h-2.5 bg-red-500 border-2 border-white dark:border-slate-900 rounded-full animate-pulse"></span>
          </button>
        </div>
      <div className="flex items-center gap-6">
        <div className="relative group">
          <button className="p-2.5 text-gray-400 hover:text-blue-600 transition-colors bg-gray-50 rounded-xl">
            <ICONS.Bell />
            <span className="absolute top-2.5 right-2.5 w-2.5 h-2.5 bg-red-500 border-2 border-white rounded-full"></span>
          </button>
        </div>
        
        <button 
          onClick={onLogout}
          className="flex items-center gap-2 px-4 py-2 text-sm font-semibold text-gray-600 hover:text-red-600 hover:bg-red-50 transition-all rounded-xl border border-transparent hover:border-red-100"
        >
          <ICONS.Logout />
          <span>Déconnexion</span>
        </button>*/}
    /*  </div>
    </header>
  );
};

export default Header;
*/

/*
import React, { useState, useEffect } from 'react';
import { ICONS } from '../constants';
import { User, UserRole } from '../types';

interface HeaderProps {
  user: User | null;
  onLogout: () => void;
}

const Header: React.FC<HeaderProps> = ({ user, onLogout }) => {
  const [darkMode, setDarkMode] = useState(false);

  // Charger la préférence au montage
  useEffect(() => {
    const savedMode = localStorage.getItem('darkMode');
    if (savedMode === 'true') {
      setDarkMode(true);
      document.documentElement.classList.add('dark');
    }
  }, []);

  const toggleDarkMode = () => {
    const newMode = !darkMode;
    setDarkMode(newMode);
    
    if (newMode) {
      document.documentElement.classList.add('dark');
      localStorage.setItem('darkMode', 'true');
    } else {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('darkMode', 'false');
    }
  };

  if (!user) return null;

  const getRoleLabel = (role: UserRole) => {
    switch (role) {
      case UserRole.ADMIN: return 'Administrateur';
      case UserRole.LECTURER: return 'Enseignant';
      case UserRole.STUDENT: return 'Étudiant';
      default: return 'Utilisateur';
    }
  };

  const getRoleColor = (role: UserRole) => {
    switch (role) {
      case UserRole.ADMIN: return 'bg-orange-100 text-orange-700 border-orange-200 dark:bg-orange-900/30 dark:text-orange-300 dark:border-orange-700';
      case UserRole.LECTURER: return 'bg-purple-100 text-purple-700 border-purple-200 dark:bg-purple-900/30 dark:text-purple-300 dark:border-purple-700';
      case UserRole.STUDENT: return 'bg-emerald-100 text-emerald-700 border-emerald-200 dark:bg-emerald-900/30 dark:text-emerald-300 dark:border-emerald-700';
      default: return 'bg-gray-100 text-gray-700 border-gray-200 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700';
    }
  };

  return (
    <header className="h-20 bg-white/80 dark:bg-slate-900/80 backdrop-blur-md border-b border-gray-200 dark:border-slate-700 flex items-center justify-between px-8 sticky top-0 z-10 transition-colors duration-300">
      <div className="flex items-center gap-4">
        {user.avatar ? (
          <img src={user.avatar} alt={user.name} className="w-10 h-10 rounded-full border-2 border-white dark:border-slate-700 shadow-sm" />
        ) : (
          <div className="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900 flex items-center justify-center text-blue-600 dark:text-blue-300 font-bold transition-colors">
            {user.name.charAt(0)}
          </div>
        )}
        <div className="flex flex-col">
          <h2 className="text-lg font-bold text-gray-800 dark:text-gray-100 leading-tight transition-colors">{user.name}</h2>
          <p className="text-xs text-gray-500 dark:text-gray-400 font-medium transition-colors">{getRoleLabel(user.role)}</p>
        </div>
      </div>
      
      <div className="flex items-center gap-4">*/
        {/* Toggle Dark Mode */}
        {/*<button
          onClick={toggleDarkMode}
          className="relative p-2.5 text-gray-400 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-all bg-gray-50 dark:bg-slate-800 rounded-xl group overflow-hidden"
          title={darkMode ? 'Mode Clair' : 'Mode Nuit'}
        >
          <div className="relative z-10">
            {darkMode ? (
              <svg className="w-5 h-5 animate-[spin_20s_linear_infinite]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
            ) : (
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
              </svg>
            )}
          </div>
          <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-purple-500 opacity-0 group-hover:opacity-20 transition-opacity"></div>
        </button>*/}

        {/* Notifications */}
        {/*<div className="relative group">
          <button className="p-2.5 text-gray-400 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors bg-gray-50 dark:bg-slate-800 rounded-xl">
            <ICONS.Bell />
            <span className="absolute top-2.5 right-2.5 w-2.5 h-2.5 bg-red-500 border-2 border-white dark:border-slate-900 rounded-full animate-pulse"></span>
          </button>
        </div>*/}
        
        {/* Déconnexion */}
        /*<button 
          onClick={onLogout}
          className="flex items-center gap-2 px-4 py-2 text-sm font-semibold text-gray-600 dark:text-gray-300 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 transition-all rounded-xl border border-transparent hover:border-red-100 dark:hover:border-red-800"
        >
          <ICONS.Logout />
          <span>Déconnexion</span>
        </button>
      </div>

      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(-10px); }
          to { opacity: 1; transform: translateY(0); }
        }
        .animate-fadeIn {
          animation: fadeIn 0.3s ease-out forwards;
        }
      `}</style>*/
    /*</header>
  );
};

export default Header;
*/

import React, { useState, useEffect } from 'react';
import { ICONS } from '../constants';
import { User, UserRole, Language } from '../types';
import NotificationsPanel from './NotificationsPanel';

interface HeaderProps {
  user: User | null;
  onLogout: () => void;
  language: Language;
  onLanguageChange: (lang: Language) => void;
}

const Header: React.FC<HeaderProps> = ({ user, onLogout, language, onLanguageChange }) => {
  const [darkMode, setDarkMode] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const [showLanguageMenu, setShowLanguageMenu] = useState(false);

  // Charger la préférence au montage
  useEffect(() => {
    const savedMode = localStorage.getItem('darkMode');
    if (savedMode === 'true') {
      setDarkMode(true);
      document.documentElement.classList.add('dark');
    }
  }, []);

  const toggleDarkMode = () => {
    const newMode = !darkMode;
    setDarkMode(newMode);
    
    if (newMode) {
      document.documentElement.classList.add('dark');
      localStorage.setItem('darkMode', 'true');
    } else {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('darkMode', 'false');
    }
  };

  if (!user) return null;

  const getRoleLabel = (role: UserRole) => {
    switch (role) {
      case UserRole.ADMIN: return language === 'FR' ? 'Administrateur' : 'Administrator';
      case UserRole.LECTURER: return language === 'FR' ? 'Enseignant' : 'Lecturer';
      case UserRole.STUDENT: return language === 'FR' ? 'Étudiant' : 'Student';
      default: return language === 'FR' ? 'Utilisateur' : 'User';
    }
  };

  const languages = [
    { code: 'FR' as Language, label: 'Français', flag: '🇫🇷' },
    { code: 'EN' as Language, label: 'English', flag: '🇬🇧' }
  ];

  const currentLanguage = languages.find(l => l.code === language);

  return (
    <>
      <header className="h-20 bg-white/80 dark:bg-slate-900/80 backdrop-blur-md border-b border-gray-200 dark:border-slate-700 flex items-center justify-between px-8 sticky top-0 z-10 transition-colors duration-300">
        <div className="flex items-center gap-4">
          {user.avatar ? (
            <img src={user.avatar} alt={user.name} className="w-10 h-10 rounded-full border-2 border-white dark:border-slate-700 shadow-sm" />
          ) : (
            <div className="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900 flex items-center justify-center text-blue-600 dark:text-blue-300 font-bold transition-colors">
              {user.name.charAt(0)}
            </div>
          )}
          <div className="flex flex-col">
            <h2 className="text-lg font-bold text-gray-800 dark:text-gray-100 leading-tight transition-colors">{user.name}</h2>
            <p className="text-xs text-gray-500 dark:text-gray-400 font-medium transition-colors">{getRoleLabel(user.role)}</p>
          </div>
        </div>
        
        <div className="flex items-center gap-4">
          {/* Language Selector */}
          <div className="relative">
            <button
              onClick={() => setShowLanguageMenu(!showLanguageMenu)}
              className="relative p-2.5 text-gray-400 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-all bg-gray-50 dark:bg-slate-800 rounded-xl group flex items-center gap-2"
              title={language === 'FR' ? 'Changer de langue' : 'Change language'}
            >
              <span className="text-lg">{currentLanguage?.flag}</span>
              <span className="text-xs font-bold text-gray-700 dark:text-gray-300">{currentLanguage?.code}</span>
              <svg className={`w-4 h-4 transition-transform ${showLanguageMenu ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
              </svg>
            </button>

            {/* Language Dropdown */}
            {showLanguageMenu && (
              <div className="absolute top-full right-0 mt-2 w-48 bg-white dark:bg-slate-800 rounded-2xl shadow-2xl border border-slate-200 dark:border-slate-700 overflow-hidden animate-slideDown z-50">
                {languages.map(lang => (
                  <button
                    key={lang.code}
                    onClick={() => {
                      onLanguageChange(lang.code);
                      setShowLanguageMenu(false);
                    }}
                    className={`w-full px-4 py-3 flex items-center gap-3 transition-colors ${
                      language === lang.code
                        ? 'bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400'
                        : 'hover:bg-slate-50 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300'
                    }`}
                  >
                    <span className="text-xl">{lang.flag}</span>
                    <span className="font-bold text-sm">{lang.label}</span>
                    {language === lang.code && (
                      <svg className="w-5 h-5 ml-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                      </svg>
                    )}
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Toggle Dark Mode */}
          <button
            onClick={toggleDarkMode}
            className="relative p-2.5 text-gray-400 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-all bg-gray-50 dark:bg-slate-800 rounded-xl group overflow-hidden"
            title={darkMode ? (language === 'FR' ? 'Mode Clair' : 'Light Mode') : (language === 'FR' ? 'Mode Nuit' : 'Dark Mode')}
          >
            <div className="relative z-10">
              {darkMode ? (
                <svg className="w-5 h-5 animate-[spin_20s_linear_infinite]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              ) : (
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                </svg>
              )}
            </div>
            <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-purple-500 opacity-0 group-hover:opacity-20 transition-opacity"></div>
          </button>

          {/* Notifications */}
          <div className="relative">
            <button 
              onClick={() => setShowNotifications(!showNotifications)}
              className="relative p-2.5 text-gray-400 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors bg-gray-50 dark:bg-slate-800 rounded-xl"
            >
              <ICONS.Bell />
              <span className="absolute top-2.5 right-2.5 w-2.5 h-2.5 bg-red-500 border-2 border-white dark:border-slate-900 rounded-full animate-pulse"></span>
            </button>
          </div>
          
          {/* Déconnexion */}
          <button 
            onClick={onLogout}
            className="flex items-center gap-2 px-4 py-2 text-sm font-semibold text-gray-600 dark:text-gray-300 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 transition-all rounded-xl border border-transparent hover:border-red-100 dark:hover:border-red-800"
          >
            <ICONS.Logout />
            <span>{language === 'FR' ? 'Déconnexion' : 'Logout'}</span>
          </button>
        </div>
      </header>

      {/* Notifications Panel */}
      <NotificationsPanel 
        isOpen={showNotifications} 
        onClose={() => setShowNotifications(false)} 
      />

      <style>{`
        @keyframes slideDown {
          from {
            opacity: 0;
            transform: translateY(-10px) scale(0.95);
          }
          to {
            opacity: 1;
            transform: translateY(0) scale(1);
          }
        }
        .animate-slideDown {
          animation: slideDown 0.2s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
        }
      `}</style>
    </>
  );
};

export default Header;