import React, { useState } from "react";
import { useNavigate } from "react-router";
import { Mail, Lock, Eye, EyeOff } from "lucide-react";
import { useApp } from "../context/AppContext";

export function LoginPage() {
  const navigate = useNavigate();
  const { t, isRTL, lang, setLang, setIsLoggedIn, setUserName } = useApp();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);

  function handleSignIn(e: React.FormEvent) {
    e.preventDefault();
    setUserName(email.split("@")[0] || "Alex");
    setIsLoggedIn(true);
    navigate("/select-disabilities");
  }

  return (
    <div
      className="min-h-screen bg-[#F7F4F0] flex flex-col items-center justify-center px-5 py-10"
      dir={isRTL ? "rtl" : "ltr"}
    >
      {/* Language toggle top */}
      <div className="absolute top-6 right-5 rtl:right-auto rtl:left-5">
        <button
          onClick={() => setLang(lang === "en" ? "ar" : "en")}
          className="text-xs font-semibold text-[#1C4532] bg-white border border-[#1C4532]/20 rounded-full px-3 py-1.5 shadow-sm"
        >
          {lang === "en" ? "العربية" : "English"}
        </button>
      </div>

      {/* App name top */}
      <div className="mb-8">
        <h1 className="text-[#1C4532] font-extrabold text-3xl tracking-tight">
          {t("appName")}
        </h1>
      </div>

      {/* Card */}
      <div className="w-full max-w-[360px] bg-white rounded-3xl shadow-lg p-8 flex flex-col items-center gap-6">
        {/* Icon */}
        <div className="w-16 h-16 rounded-full bg-[#D1FAE5] flex items-center justify-center">
          <div className="w-8 h-8 text-[#1C4532]">
            <svg viewBox="0 0 24 24" fill="currentColor">
              <path d="M12.65 10A5.99 5.99 0 0 0 7 6c-3.31 0-6 2.69-6 6s2.69 6 6 6a5.99 5.99 0 0 0 5.65-4H17v4h4v-4h2v-4H12.65zM7 14c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z" />
            </svg>
          </div>
        </div>

        {/* Title */}
        <div className="text-center">
          <h2 className="text-[#111827] font-extrabold text-2xl mb-1">
            {t("welcomeBack")}
          </h2>
          <p className="text-gray-500 text-sm leading-relaxed">
            {t("signInToContinue")}
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleSignIn} className="w-full flex flex-col gap-3">
          <div className="flex items-center gap-3 bg-gray-100 rounded-xl px-4 py-3">
            <Mail size={18} className="text-gray-400 shrink-0" />
            <input
              type="email"
              placeholder={t("email")}
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="flex-1 bg-transparent outline-none text-sm text-gray-700 placeholder:text-gray-400"
              dir={isRTL ? "rtl" : "ltr"}
            />
          </div>

          <div className="flex items-center gap-3 bg-gray-100 rounded-xl px-4 py-3">
            <Lock size={18} className="text-gray-400 shrink-0" />
            <input
              type={showPassword ? "text" : "password"}
              placeholder={t("password")}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="flex-1 bg-transparent outline-none text-sm text-gray-700 placeholder:text-gray-400"
              dir="ltr"
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="text-gray-400"
            >
              {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
            </button>
          </div>

          <button
            type="submit"
            className="w-full bg-[#1C4532] text-white rounded-xl py-3.5 font-bold tracking-wider mt-2 active:opacity-90 transition-opacity"
          >
            {t("signIn")}
          </button>
        </form>

        <button
          className="text-[#1C4532] text-sm font-semibold"
          onClick={() => {}}
        >
          {t("forgotPassword")}
        </button>

        <p className="text-sm text-gray-500">
          {t("noAccount")}{" "}
          <button
            onClick={() => navigate("/signup")}
            className="text-[#1C4532] font-bold"
          >
            {t("createAccount")}
          </button>
        </p>
      </div>
    </div>
  );
}
