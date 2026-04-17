import React, { useState } from "react";
import { useNavigate } from "react-router";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { useApp } from "../context/AppContext";

const DISABILITY_OPTIONS = [
  {
    id: "visual",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6" stroke="currentColor" strokeWidth="2">
        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
        <circle cx="12" cy="12" r="3" />
      </svg>
    ),
  },
  {
    id: "hearing",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6" stroke="currentColor" strokeWidth="2">
        <path d="M3 18v-6a9 9 0 0 1 18 0v6" />
        <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z" />
      </svg>
    ),
  },
  {
    id: "motor",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6" stroke="currentColor" strokeWidth="2">
        <circle cx="12" cy="5" r="1" />
        <path d="M9 20l3-3 3 3M12 17V9" />
        <path d="M6.3 15.9A5 5 0 0 0 12 17a5 5 0 0 0 5.7-1.1" />
      </svg>
    ),
  },
  {
    id: "cognitive",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6" stroke="currentColor" strokeWidth="2">
        <path d="M9.5 2A2.5 2.5 0 0 1 12 4.5v15a2.5 2.5 0 0 1-4.96-.44 2.5 2.5 0 0 1-2.96-3.08 3 3 0 0 1-.34-5.58 2.5 2.5 0 0 1 1.32-4.24 2.5 2.5 0 0 1 1.44-4.24z" />
        <path d="M14.5 2A2.5 2.5 0 0 0 12 4.5v15a2.5 2.5 0 0 0 4.96-.44 2.5 2.5 0 0 0 2.96-3.08 3 3 0 0 0 .34-5.58 2.5 2.5 0 0 0-1.32-4.24 2.5 2.5 0 0 0-1.44-4.24z" />
      </svg>
    ),
  },
  {
    id: "speech",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6" stroke="currentColor" strokeWidth="2">
        <path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z" />
        <path d="M19 10v2a7 7 0 0 1-14 0v-2M12 19v4M8 23h8" />
      </svg>
    ),
  },
];

export function SelectDisabilitiesPage() {
  const navigate = useNavigate();
  const { t, isRTL, setDisabilities } = useApp();
  const [selected, setSelected] = useState<string[]>([]);

  const BackIcon = isRTL ? ChevronRight : ChevronLeft;

  function toggle(id: string) {
    setSelected((prev) =>
      prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]
    );
  }

  function handleContinue() {
    setDisabilities(selected);
    navigate("/dashboard");
  }

  const labels: Record<string, { title: string; desc: string }> = {
    visual: { title: t("visual"), desc: t("visualDesc") },
    hearing: { title: t("hearing"), desc: t("hearingDesc") },
    motor: { title: t("motor"), desc: t("motorDesc") },
    cognitive: { title: t("cognitive"), desc: t("cognitiveDesc") },
    speech: { title: t("speech"), desc: t("speechDesc") },
  };

  return (
    <div
      className="min-h-screen bg-[#F7F4F0] flex flex-col"
      dir={isRTL ? "rtl" : "ltr"}
    >
      {/* Header */}
      <div className="flex items-center gap-3 px-5 pt-12 pb-2">
        <button
          onClick={() => navigate("/login")}
          className="w-9 h-9 flex items-center justify-center rounded-full bg-white shadow-sm border border-gray-100"
        >
          <BackIcon size={18} className="text-[#1C4532]" />
        </button>
        <span className="font-bold text-base text-[#1C4532]">{t("appName")}</span>
      </div>

      {/* Content */}
      <div className="flex-1 px-5 pt-6 pb-32 overflow-y-auto">
        <h1 className="text-[#111827] font-extrabold text-3xl leading-tight mb-3">
          {t("personalizeExperience")}
        </h1>
        <p className="text-gray-500 text-sm leading-relaxed mb-8">
          {t("selectCategories")}
        </p>

        <div className="flex flex-col gap-4">
          {DISABILITY_OPTIONS.map((opt) => {
            const isSelected = selected.includes(opt.id);
            const info = labels[opt.id];
            return (
              <button
                key={opt.id}
                onClick={() => toggle(opt.id)}
                className={`w-full bg-white rounded-2xl p-5 flex items-center gap-4 shadow-sm border-2 transition-all text-start ${
                  isSelected ? "border-[#1C4532]" : "border-transparent"
                }`}
              >
                {/* Icon */}
                <div
                  className={`w-12 h-12 rounded-full flex items-center justify-center shrink-0 ${
                    isSelected ? "bg-[#D1FAE5] text-[#1C4532]" : "bg-gray-100 text-gray-400"
                  }`}
                >
                  {opt.icon}
                </div>

                {/* Text */}
                <div className="flex-1 text-start">
                  <p className="font-bold text-[#111827] text-base">{info.title}</p>
                  <p className="text-gray-500 text-xs mt-0.5 leading-snug">{info.desc}</p>
                </div>

                {/* Toggle */}
                <div
                  className={`w-12 h-7 rounded-full relative transition-colors shrink-0 ${
                    isSelected ? "bg-[#1C4532]" : "bg-gray-200"
                  }`}
                >
                  <div
                    className={`absolute top-1 w-5 h-5 rounded-full bg-white shadow transition-all ${
                      isSelected
                        ? isRTL ? "left-1" : "left-6"
                        : isRTL ? "left-6" : "left-1"
                    }`}
                  />
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* Continue button */}
      <div className="fixed bottom-0 left-0 right-0 flex justify-center">
        <div className="w-full max-w-[430px] px-5 pb-8 pt-4 bg-gradient-to-t from-[#F7F4F0] to-transparent">
          <button
            onClick={handleContinue}
            className="w-full bg-[#1C4532] text-white rounded-2xl py-4 font-bold text-base tracking-wide flex items-center justify-center gap-2 active:opacity-90"
          >
            {t("continueBtn")}
            {isRTL ? (
              <ChevronLeft size={18} />
            ) : (
              <ChevronRight size={18} />
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
