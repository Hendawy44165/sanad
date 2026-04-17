import React, { useState } from "react";
import { useNavigate } from "react-router";
import { Mail, Lock, User, Eye, EyeOff, ChevronLeft, ChevronRight } from "lucide-react";
import { useApp } from "../context/AppContext";

export function SignUpPage() {
  const navigate = useNavigate();
  const { t, isRTL, setIsLoggedIn, setUserName } = useApp();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPwd, setConfirmPwd] = useState("");
  const [showPwd, setShowPwd] = useState(false);

  const BackIcon = isRTL ? ChevronRight : ChevronLeft;

  function handleSignUp(e: React.FormEvent) {
    e.preventDefault();
    setUserName(name || "Alex");
    setIsLoggedIn(true);
    navigate("/select-disabilities");
  }

  return (
    <div
      className="min-h-screen bg-[#F7F4F0] flex flex-col items-center justify-center px-5 py-10"
      dir={isRTL ? "rtl" : "ltr"}
    >
      {/* Back */}
      <div className="absolute top-12 left-5 rtl:left-auto rtl:right-5">
        <button
          onClick={() => navigate("/login")}
          className="w-9 h-9 flex items-center justify-center rounded-full bg-white shadow-sm border border-gray-100"
        >
          <BackIcon size={18} className="text-[#1C4532]" />
        </button>
      </div>

      {/* App name */}
      <div className="mb-8">
        <h1 className="text-[#1C4532] font-extrabold text-3xl tracking-tight">
          {t("appName")}
        </h1>
      </div>

      {/* Card */}
      <div className="w-full max-w-[360px] bg-white rounded-3xl shadow-lg p-8 flex flex-col items-center gap-5">
        {/* Icon */}
        <div className="w-16 h-16 rounded-full bg-[#D1FAE5] flex items-center justify-center">
          <User size={28} className="text-[#1C4532]" />
        </div>

        <div className="text-center">
          <h2 className="text-[#111827] font-extrabold text-2xl mb-1">
            {t("createYourAccount")}
          </h2>
        </div>

        <form onSubmit={handleSignUp} className="w-full flex flex-col gap-3">
          <div className="flex items-center gap-3 bg-gray-100 rounded-xl px-4 py-3">
            <User size={18} className="text-gray-400 shrink-0" />
            <input
              type="text"
              placeholder={t("fullName")}
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="flex-1 bg-transparent outline-none text-sm text-gray-700 placeholder:text-gray-400"
            />
          </div>

          <div className="flex items-center gap-3 bg-gray-100 rounded-xl px-4 py-3">
            <Mail size={18} className="text-gray-400 shrink-0" />
            <input
              type="email"
              placeholder={t("email")}
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="flex-1 bg-transparent outline-none text-sm text-gray-700 placeholder:text-gray-400"
              dir="ltr"
            />
          </div>

          <div className="flex items-center gap-3 bg-gray-100 rounded-xl px-4 py-3">
            <Lock size={18} className="text-gray-400 shrink-0" />
            <input
              type={showPwd ? "text" : "password"}
              placeholder={t("password")}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="flex-1 bg-transparent outline-none text-sm text-gray-700 placeholder:text-gray-400"
              dir="ltr"
            />
            <button type="button" onClick={() => setShowPwd(!showPwd)} className="text-gray-400">
              {showPwd ? <EyeOff size={16} /> : <Eye size={16} />}
            </button>
          </div>

          <div className="flex items-center gap-3 bg-gray-100 rounded-xl px-4 py-3">
            <Lock size={18} className="text-gray-400 shrink-0" />
            <input
              type="password"
              placeholder={t("confirmPassword")}
              value={confirmPwd}
              onChange={(e) => setConfirmPwd(e.target.value)}
              className="flex-1 bg-transparent outline-none text-sm text-gray-700 placeholder:text-gray-400"
              dir="ltr"
            />
          </div>

          <button
            type="submit"
            className="w-full bg-[#1C4532] text-white rounded-xl py-3.5 font-bold tracking-wider mt-2 active:opacity-90 transition-opacity"
          >
            {t("signUp")}
          </button>
        </form>

        <p className="text-sm text-gray-500">
          {t("haveAccount")}{" "}
          <button
            onClick={() => navigate("/login")}
            className="text-[#1C4532] font-bold"
          >
            {t("signInLink")}
          </button>
        </p>
      </div>
    </div>
  );
}
