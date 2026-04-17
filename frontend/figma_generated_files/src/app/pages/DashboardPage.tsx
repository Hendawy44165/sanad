import React from "react";
import { useNavigate } from "react-router";
import {
  Briefcase,
  Stethoscope,
  BookOpen,
  HandMetal,
  ChevronRight,
  ChevronLeft,
  CheckCircle,
  Star,
  Menu,
} from "lucide-react";
import { BottomNav } from "../components/BottomNav";
import { useApp } from "../context/AppContext";

const JOBS = [
  {
    id: 1,
    title: "Senior UX Researcher",
    company: "TechFlow Innovations",
    tags: ["remote", "fullTime"],
    accessible: true,
  },
  {
    id: 2,
    title: "Accessibility Specialist",
    company: "Global Health Corp",
    tags: ["hybrid", "contract"],
    accessible: true,
  },
];

const DOCTORS = [
  {
    id: 1,
    nameEn: "Dr. Layla Khaled",
    nameAr: "د. ليلى خالد",
    specialty: { en: "Neurology Specialist", ar: "أخصائية أعصاب" },
    rating: 4.9,
    reviews: 120,
  },
  {
    id: 2,
    nameEn: "Dr. Omar Nasser",
    nameAr: "د. عمر ناصر",
    specialty: { en: "Physical Therapy", ar: "علاج طبيعي" },
    rating: 4.8,
    reviews: 85,
  },
];

const BOOKS = [
  {
    id: 1,
    titleEn: "The Art of Possibility",
    titleAr: "فن الإمكانية",
    author: "Rosamund Stone Zander",
    formats: ["audioBook", "brailleBook"],
  },
  {
    id: 2,
    titleEn: "Disability Visibility",
    titleAr: "رؤية الإعاقة",
    author: "Alice Wong",
    formats: ["audioBook", "ebook"],
  },
];

export function DashboardPage() {
  const navigate = useNavigate();
  const { t, isRTL, lang, userName } = useApp();
  const ArrowIcon = isRTL ? ChevronLeft : ChevronRight;

  const tagLabel: Record<string, string> = {
    remote: t("remote"),
    fullTime: t("fullTime"),
    hybrid: t("hybrid"),
    contract: t("contract"),
  };

  return (
    <div
      className="min-h-screen bg-[#F7F4F0] pb-28"
      dir={isRTL ? "rtl" : "ltr"}
    >
      {/* Header */}
      <div className="bg-white px-5 pt-12 pb-6 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <button className="w-9 h-9 flex items-center justify-center rounded-full bg-gray-100">
            <Menu size={18} className="text-gray-600" />
          </button>
          <span className="font-extrabold text-[#1C4532] text-lg">{t("appName")}</span>
          <div className="w-9 h-9 rounded-full bg-[#D1FAE5] flex items-center justify-center">
            <span className="text-[#1C4532] font-bold text-sm">
              {(userName || "A")[0].toUpperCase()}
            </span>
          </div>
        </div>
        <h1 className="text-[#111827] font-extrabold text-2xl">{t("dashboard")}</h1>
        <p className="text-gray-500 text-sm mt-1">{t("yourAccessible")}</p>
      </div>

      <div className="px-5 pt-6 flex flex-col gap-6">
        {/* Quick Actions */}
        <div>
          <p className="text-[#111827] font-bold text-base mb-3">{t("quickActions")}</p>
          <div className="grid grid-cols-2 gap-3">
            {[
              {
                label: t("findJobs"),
                icon: <Briefcase size={22} className="text-[#1C4532]" />,
                route: "/jobs",
                bg: "bg-[#D1FAE5]",
              },
              {
                label: t("findDoctor"),
                icon: <Stethoscope size={22} className="text-[#1C4532]" />,
                route: "/doctor",
                bg: "bg-[#D1FAE5]",
              },
              {
                label: t("requestBook"),
                icon: <BookOpen size={22} className="text-[#1C4532]" />,
                route: "/books",
                bg: "bg-[#D1FAE5]",
              },
              {
                label: t("signLanguageTranslator"),
                icon: <HandMetal size={22} className="text-[#1C4532]" />,
                route: "/sign-language",
                bg: "bg-[#D1FAE5]",
              },
            ].map((action) => (
              <button
                key={action.route}
                onClick={() => navigate(action.route)}
                className="bg-white rounded-2xl p-4 flex flex-col items-start gap-3 shadow-sm border border-gray-100 active:opacity-80 transition-opacity"
              >
                <div className={`w-10 h-10 rounded-xl ${action.bg} flex items-center justify-center`}>
                  {action.icon}
                </div>
                <span className="text-[#111827] font-semibold text-sm text-start">{action.label}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Opportunities */}
        <div>
          <div className="flex items-center justify-between mb-3">
            <p className="text-[#111827] font-bold text-base">{t("opportunities")}</p>
            <button
              onClick={() => navigate("/jobs")}
              className="text-[#1C4532] font-semibold text-xs flex items-center gap-1"
            >
              {t("viewAllJobs")}
              <ArrowIcon size={14} />
            </button>
          </div>
          <div className="flex flex-col gap-3">
            {JOBS.map((job) => (
              <div
                key={job.id}
                className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100"
              >
                <div className="flex items-start justify-between gap-2 mb-2">
                  <div>
                    <p className="font-bold text-[#111827] text-sm">{job.title}</p>
                    <p className="text-gray-500 text-xs">{job.company}</p>
                  </div>
                  {job.accessible && (
                    <div className="flex items-center gap-1 bg-[#D1FAE5] px-2 py-1 rounded-full shrink-0">
                      <CheckCircle size={10} className="text-[#1C4532]" />
                      <span className="text-[#1C4532] text-[10px] font-semibold">
                        {t("verifiedAccessible")}
                      </span>
                    </div>
                  )}
                </div>
                <div className="flex gap-2 flex-wrap mb-3">
                  {job.tags.map((tag) => (
                    <span
                      key={tag}
                      className="bg-gray-100 text-gray-600 text-[11px] font-medium px-2.5 py-1 rounded-full"
                    >
                      {tagLabel[tag]}
                    </span>
                  ))}
                </div>
                <button
                  onClick={() => navigate("/jobs")}
                  className="w-full border border-[#1C4532] text-[#1C4532] rounded-xl py-2.5 text-sm font-semibold"
                >
                  {t("viewDetails")}
                </button>
              </div>
            ))}
          </div>
        </div>

        {/* Medical Network */}
        <div>
          <div className="flex items-center justify-between mb-3">
            <p className="text-[#111827] font-bold text-base">{t("medicalNetwork")}</p>
            <button
              onClick={() => navigate("/doctor")}
              className="text-[#1C4532] font-semibold text-xs flex items-center gap-1"
            >
              {t("findCare")}
              <ArrowIcon size={14} />
            </button>
          </div>
          <div className="flex flex-col gap-3">
            {DOCTORS.map((doc) => (
              <div
                key={doc.id}
                className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100"
              >
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-12 h-12 rounded-full bg-[#D1FAE5] flex items-center justify-center shrink-0">
                    <Stethoscope size={20} className="text-[#1C4532]" />
                  </div>
                  <div>
                    <p className="font-bold text-[#111827] text-sm">
                      {lang === "ar" ? doc.nameAr : doc.nameEn}
                    </p>
                    <p className="text-gray-500 text-xs">
                      {lang === "ar" ? doc.specialty.ar : doc.specialty.en}
                    </p>
                    <div className="flex items-center gap-1 mt-0.5">
                      <Star size={11} className="text-amber-400 fill-amber-400" />
                      <span className="text-xs text-gray-600 font-medium">
                        {doc.rating} ({doc.reviews} {t("reviews")})
                      </span>
                    </div>
                  </div>
                </div>
                <button
                  onClick={() => navigate("/doctor")}
                  className="w-full bg-[#1C4532] text-white rounded-xl py-2.5 text-sm font-semibold flex items-center justify-center gap-2"
                >
                  {t("bookBtn")}
                </button>
              </div>
            ))}
          </div>
        </div>

        {/* Learn & Grow */}
        <div>
          <div className="flex items-center justify-between mb-3">
            <p className="text-[#111827] font-bold text-base">{t("learnAndGrow")}</p>
            <button
              onClick={() => navigate("/books")}
              className="text-[#1C4532] font-semibold text-xs flex items-center gap-1"
            >
              {t("browseBooks")}
              <ArrowIcon size={14} />
            </button>
          </div>
          <div className="flex flex-col gap-3">
            {BOOKS.map((book) => (
              <div
                key={book.id}
                className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 flex items-center gap-3"
              >
                <div className="w-12 h-12 rounded-xl bg-[#D1FAE5] flex items-center justify-center shrink-0">
                  <BookOpen size={20} className="text-[#1C4532]" />
                </div>
                <div className="flex-1">
                  <p className="font-bold text-[#111827] text-sm">
                    {lang === "ar" ? book.titleAr : book.titleEn}
                  </p>
                  <p className="text-gray-500 text-xs">{book.author}</p>
                  <div className="flex gap-1 mt-1 flex-wrap">
                    {book.formats.map((f) => (
                      <span
                        key={f}
                        className="bg-[#D1FAE5] text-[#1C4532] text-[10px] font-semibold px-2 py-0.5 rounded-full"
                      >
                        {t(f as any)}
                      </span>
                    ))}
                  </div>
                </div>
                <button
                  onClick={() => navigate("/books")}
                  className="border border-[#1C4532] text-[#1C4532] rounded-xl px-3 py-2 text-xs font-semibold shrink-0"
                >
                  {t("requestBtn")}
                </button>
              </div>
            ))}
          </div>
        </div>

        {/* Sign Language Banner */}
        <div>
          <div className="bg-[#1C4532] rounded-2xl p-5 flex items-center gap-4">
            <div className="w-14 h-14 rounded-2xl bg-white/20 flex items-center justify-center shrink-0">
              <HandMetal size={28} className="text-white" />
            </div>
            <div className="flex-1">
              <p className="text-white font-bold text-base">{t("signLanguageSection")}</p>
              <p className="text-white/70 text-xs mt-0.5">{t("tapAndSign")}</p>
            </div>
            <button
              onClick={() => navigate("/sign-language")}
              className="bg-white text-[#1C4532] rounded-xl px-3 py-2 text-xs font-bold shrink-0"
            >
              {t("translateNow")}
            </button>
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
