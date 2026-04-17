import React, { createContext, useContext, useState, ReactNode } from "react";
import { Lang, translations, TranslationKey } from "../translations";

interface AppContextType {
  lang: Lang;
  setLang: (lang: Lang) => void;
  isRTL: boolean;
  t: (key: TranslationKey) => string;
  isLoggedIn: boolean;
  setIsLoggedIn: (v: boolean) => void;
  disabilities: string[];
  setDisabilities: (d: string[]) => void;
  userName: string;
  setUserName: (n: string) => void;
}

const AppContext = createContext<AppContextType | null>(null);

export function AppProvider({ children }: { children: ReactNode }) {
  const [lang, setLang] = useState<Lang>("en");
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [disabilities, setDisabilities] = useState<string[]>([]);
  const [userName, setUserName] = useState("Alex");

  const isRTL = lang === "ar";

  function t(key: TranslationKey): string {
    return translations[lang][key] as string;
  }

  return (
    <AppContext.Provider
      value={{
        lang,
        setLang,
        isRTL,
        t,
        isLoggedIn,
        setIsLoggedIn,
        disabilities,
        setDisabilities,
        userName,
        setUserName,
      }}
    >
      {children}
    </AppContext.Provider>
  );
}

export function useApp() {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error("useApp must be used within AppProvider");
  return ctx;
}
