import React from "react";
import { useNavigate, useLocation } from "react-router";
import { Home, HandMetal, Globe } from "lucide-react";
import { useApp } from "../context/AppContext";

export function BottomNav() {
  const navigate = useNavigate();
  const location = useLocation();
  const { t, lang, setLang, isRTL } = useApp();

  const path = location.pathname;

  const tabs = [
    { icon: Home, label: t("home"), route: "/dashboard" },
    { icon: HandMetal, label: t("translator"), route: "/sign-language" },
  ];

  function toggleLanguage() {
    setLang(lang === "en" ? "ar" : "en");
  }

  return (
    <div
      className="fixed bottom-0 left-0 right-0 flex justify-center z-50"
      style={{ direction: isRTL ? "rtl" : "ltr" }}
    >
      <div className="w-full max-w-[430px] bg-white border-t border-gray-100 flex items-center shadow-lg">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const active = path === tab.route;
          return (
            <button
              key={tab.route}
              onClick={() => navigate(tab.route)}
              className="flex-1 flex flex-col items-center gap-1 py-3 transition-colors"
            >
              <div
                className={`flex flex-col items-center gap-1 px-4 py-1 rounded-full transition-all ${
                  active ? "bg-[#E8F5EE]" : ""
                }`}
              >
                <Icon
                  size={20}
                  className={active ? "text-[#1C4532]" : "text-gray-400"}
                />
                <span
                  className={`text-[10px] font-semibold ${
                    active ? "text-[#1C4532]" : "text-gray-400"
                  }`}
                >
                  {tab.label}
                </span>
              </div>
            </button>
          );
        })}

        {/* Language toggle */}
        <button
          onClick={toggleLanguage}
          className="flex-1 flex flex-col items-center gap-1 py-3 transition-colors"
        >
          <div className="flex flex-col items-center gap-1 px-4 py-1 rounded-full">
            <Globe size={20} className="text-gray-400" />
            <span className="text-[10px] font-semibold text-gray-400">
              {lang === "en" ? "العربية" : "English"}
            </span>
          </div>
        </button>
      </div>
    </div>
  );
}
