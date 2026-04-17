import React, { useState, useRef } from "react";
import { useNavigate } from "react-router";
import {
  ChevronLeft,
  ChevronRight,
  Volume2,
  RotateCcw,
  Mic,
  MicOff,
} from "lucide-react";
import { BottomNav } from "../components/BottomNav";
import { useApp } from "../context/AppContext";

const MOCK_TRANSLATIONS_EN = [
  "Hello, how are you today?",
  "I need help, please.",
  "Thank you very much.",
  "Can you please repeat that?",
  "I am happy to meet you.",
  "Where is the nearest hospital?",
  "My name is Alex.",
  "I understand, thank you.",
  "Please speak slowly.",
  "I would like some water.",
];

const MOCK_TRANSLATIONS_AR = [
  "مرحباً، كيف حالك اليوم؟",
  "أحتاج إلى مساعدة، من فضلك.",
  "شكراً جزيلاً.",
  "هل يمكنك تكرار ذلك من فضلك؟",
  "يسعدني مقابلتك.",
  "أين أقرب مستشفى؟",
  "اسمي أليكس.",
  "أفهم، شكراً لك.",
  "تكلم ببطء من فضلك.",
  "أريد بعض الماء.",
];

type State = "idle" | "recording" | "translating" | "result";

export function SignLanguagePage() {
  const navigate = useNavigate();
  const { t, isRTL, lang } = useApp();
  const [state, setState] = useState<State>("idle");
  const [translation, setTranslation] = useState("");
  const [isSpeaking, setIsSpeaking] = useState(false);
  const progressRef = useRef(0);
  const [progress, setProgress] = useState(0);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const stateRef = useRef<State>("idle");

  function updateState(s: State) {
    stateRef.current = s;
    setState(s);
  }

  const BackIcon = isRTL ? ChevronRight : ChevronLeft;

  function startRecording() {
    if (stateRef.current !== "idle") return;
    updateState("recording");
    progressRef.current = 0;
    setProgress(0);

    intervalRef.current = setInterval(() => {
      progressRef.current += 2;
      setProgress(progressRef.current);
      if (progressRef.current >= 100) {
        doStopRecording();
      }
    }, 60);
  }

  function stopRecording() {
    if (stateRef.current !== "recording") return;
    doStopRecording();
  }

  function doStopRecording() {
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
      intervalRef.current = null;
    }
    if (stateRef.current === "idle") return;

    updateState("translating");
    setProgress(0);

    setTimeout(() => {
      const list = lang === "ar" ? MOCK_TRANSLATIONS_AR : MOCK_TRANSLATIONS_EN;
      const result = list[Math.floor(Math.random() * list.length)];
      setTranslation(result);
      updateState("result");
      speakText(result);
    }, 1800);
  }

  function speakText(text: string) {
    if (!window.speechSynthesis) return;
    window.speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = lang === "ar" ? "ar-SA" : "en-US";
    utterance.rate = 0.9;
    utterance.pitch = 1;
    setIsSpeaking(true);
    utterance.onend = () => setIsSpeaking(false);
    utterance.onerror = () => setIsSpeaking(false);
    window.speechSynthesis.speak(utterance);
  }

  function handleSpeakAgain() {
    speakText(translation);
  }

  function handleReset() {
    window.speechSynthesis?.cancel();
    setIsSpeaking(false);
    setTranslation("");
    updateState("idle");
    setProgress(0);
  }

  const radius = 70;
  const circumference = 2 * Math.PI * radius;
  const strokeDashoffset = circumference - (progress / 100) * circumference;

  return (
    <div
      className="min-h-screen bg-[#F7F4F0] flex flex-col pb-28"
      dir={isRTL ? "rtl" : "ltr"}
    >
      {/* Header */}
      <div className="bg-white px-5 pt-12 pb-5 shadow-sm">
        <div className="flex items-center gap-3">
          <button
            onClick={() => navigate("/dashboard")}
            className="w-9 h-9 flex items-center justify-center rounded-full bg-gray-100"
          >
            <BackIcon size={18} className="text-gray-600" />
          </button>
          <h1 className="text-[#111827] font-extrabold text-xl">
            {t("signLanguageTranslator")}
          </h1>
        </div>
      </div>

      <div className="flex-1 flex flex-col items-center px-5 pt-8 gap-6">
        {/* Instruction */}
        <p className="text-gray-500 text-sm text-center leading-relaxed max-w-xs">
          {state === "idle" && t("tapAndSign")}
          {state === "recording" && t("recording")}
          {state === "translating" && t("translating")}
          {state === "result" && t("translationResult")}
        </p>

        {/* Visual area */}
        <div className="w-full max-w-[300px] aspect-square bg-white rounded-3xl shadow-sm border border-gray-100 flex items-center justify-center relative overflow-hidden">
          {/* Animated bg for recording */}
          {state === "recording" && (
            <div className="absolute inset-0 bg-[#D1FAE5] animate-pulse" />
          )}
          {state === "translating" && (
            <div className="absolute inset-0 bg-[#F0FDF4]" />
          )}

          <div className="relative z-10 flex flex-col items-center gap-4">
            {state === "idle" && (
              <>
                <div className="w-24 h-24 rounded-full bg-[#F7F4F0] flex items-center justify-center">
                  <svg
                    viewBox="0 0 80 80"
                    className="w-16 h-16"
                    fill="none"
                    stroke="#1C4532"
                    strokeWidth="3"
                  >
                    {/* Stylized hand icon */}
                    <rect x="30" y="10" width="8" height="30" rx="4" fill="#1C4532" stroke="none" opacity="0.8" />
                    <rect x="40" y="14" width="8" height="26" rx="4" fill="#1C4532" stroke="none" opacity="0.8" />
                    <rect x="50" y="18" width="8" height="22" rx="4" fill="#1C4532" stroke="none" opacity="0.8" />
                    <rect x="20" y="22" width="8" height="18" rx="4" fill="#1C4532" stroke="none" opacity="0.8" />
                    <rect x="18" y="38" width="44" height="18" rx="9" fill="#1C4532" stroke="none" opacity="0.8" />
                    <rect x="10" y="36" width="10" height="12" rx="5" fill="#1C4532" stroke="none" opacity="0.6" />
                  </svg>
                </div>
                <p className="text-[#1C4532] font-semibold text-sm opacity-60">
                  {lang === "ar" ? "جاهز" : "Ready"}
                </p>
              </>
            )}

            {state === "recording" && (
              <>
                <div className="relative">
                  <svg width="160" height="160">
                    <circle
                      cx="80"
                      cy="80"
                      r={radius}
                      fill="none"
                      stroke="#D1FAE5"
                      strokeWidth="8"
                    />
                    <circle
                      cx="80"
                      cy="80"
                      r={radius}
                      fill="none"
                      stroke="#1C4532"
                      strokeWidth="8"
                      strokeLinecap="round"
                      strokeDasharray={circumference}
                      strokeDashoffset={strokeDashoffset}
                      transform="rotate(-90 80 80)"
                      className="transition-all"
                    />
                  </svg>
                  <div className="absolute inset-0 flex items-center justify-center">
                    <Mic size={36} className="text-[#1C4532]" />
                  </div>
                </div>
                <div className="flex gap-1">
                  {[...Array(5)].map((_, i) => (
                    <div
                      key={i}
                      className="w-1.5 rounded-full bg-[#1C4532]"
                      style={{
                        height: `${12 + Math.sin(Date.now() / 200 + i) * 8}px`,
                        animation: `pulse ${0.4 + i * 0.1}s ease-in-out infinite alternate`,
                      }}
                    />
                  ))}
                </div>
              </>
            )}

            {state === "translating" && (
              <div className="flex flex-col items-center gap-3">
                <div className="w-16 h-16 rounded-full border-4 border-[#1C4532] border-t-transparent animate-spin" />
                <p className="text-[#1C4532] font-semibold text-sm">{t("translating")}</p>
              </div>
            )}

            {state === "result" && (
              <div className="flex flex-col items-center gap-3 px-6">
                <div className="w-14 h-14 bg-[#1C4532] rounded-full flex items-center justify-center">
                  <Volume2 size={24} className="text-white" />
                </div>
                <p className="text-[#111827] font-bold text-center text-sm leading-relaxed">
                  "{translation}"
                </p>
                {isSpeaking && (
                  <div className="flex gap-1 items-center">
                    {[...Array(4)].map((_, i) => (
                      <div
                        key={i}
                        className="w-1 rounded-full bg-[#1C4532] animate-bounce"
                        style={{ height: "14px", animationDelay: `${i * 0.1}s` }}
                      />
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>

        {/* Record Button */}
        {(state === "idle" || state === "recording") && (
          <div className="flex flex-col items-center gap-3">
            <button
              onMouseDown={startRecording}
              onMouseUp={stopRecording}
              onMouseLeave={() => {
                if (state === "recording") stopRecording();
              }}
              onTouchStart={(e) => { e.preventDefault(); startRecording(); }}
              onTouchEnd={(e) => { e.preventDefault(); stopRecording(); }}
              className={`w-20 h-20 rounded-full flex items-center justify-center shadow-lg transition-all select-none ${
                state === "recording"
                  ? "bg-red-500 scale-110"
                  : "bg-[#1C4532] active:scale-95"
              }`}
            >
              {state === "recording" ? (
                <MicOff size={28} className="text-white" />
              ) : (
                <Mic size={28} className="text-white" />
              )}
            </button>
            <p className="text-gray-400 text-xs font-medium">
              {state === "recording" ? t("recording") : t("pressToRecord")}
            </p>
          </div>
        )}

        {/* Result actions */}
        {state === "result" && (
          <div className="w-full flex flex-col gap-3">
            <button
              onClick={handleSpeakAgain}
              disabled={isSpeaking}
              className={`w-full rounded-2xl py-4 font-bold text-sm flex items-center justify-center gap-2 ${
                isSpeaking ? "bg-gray-200 text-gray-400" : "bg-[#1C4532] text-white"
              }`}
            >
              <Volume2 size={16} />
              {t("speakAgain")}
            </button>
            <button
              onClick={handleReset}
              className="w-full border-2 border-[#1C4532] text-[#1C4532] rounded-2xl py-4 font-bold text-sm flex items-center justify-center gap-2"
            >
              <RotateCcw size={16} />
              {t("newTranslation")}
            </button>
          </div>
        )}

        {/* Tips */}
        {state === "idle" && (
          <div className="w-full bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <p className="text-[#1C4532] font-bold text-xs mb-2">
              {lang === "ar" ? "نصائح للاستخدام" : "Tips for best results"}
            </p>
            <ul className="flex flex-col gap-1.5">
              {(lang === "ar"
                ? [
                    "تأكد من إضاءة جيدة",
                    "ابقَ في وسط الإطار",
                    "تحرك بإشاراتك بوضوح",
                  ]
                : [
                    "Ensure good lighting",
                    "Keep your hands in frame",
                    "Sign clearly and steadily",
                  ]
              ).map((tip) => (
                <li key={tip} className="text-gray-500 text-xs flex items-start gap-2">
                  <span className="text-[#1C4532] font-bold mt-0.5">•</span>
                  {tip}
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>

      <BottomNav />
    </div>
  );
}