import React, { useState, useRef } from "react";
import { useNavigate } from "react-router";
import {
  ChevronLeft,
  ChevronRight,
  Search,
  Briefcase,
  CheckCircle,
  Upload,
  FileText,
  X,
} from "lucide-react";
import { BottomNav } from "../components/BottomNav";
import { useApp } from "../context/AppContext";

const JOBS_DATA = [
  {
    id: 1,
    titleEn: "Senior UX Researcher",
    titleAr: "باحث تجربة مستخدم أول",
    companyEn: "TechFlow Innovations",
    companyAr: "تك فلو للابتكار",
    tags: ["remote", "fullTime"],
    accessible: true,
    descEn: "Research user experiences for accessibility-focused products. Work fully remote.",
    descAr: "بحث تجارب المستخدمين لمنتجات تركز على إمكانية الوصول. العمل عن بُعد بالكامل.",
  },
  {
    id: 2,
    titleEn: "Accessibility Specialist",
    titleAr: "أخصائي إمكانية الوصول",
    companyEn: "Global Health Corp",
    companyAr: "شركة الصحة العالمية",
    tags: ["hybrid", "contract"],
    accessible: true,
    descEn: "Audit and improve digital accessibility across health platforms.",
    descAr: "مراجعة وتحسين إمكانية الوصول الرقمي عبر منصات الصحة.",
  },
  {
    id: 3,
    titleEn: "Remote Data Analyst",
    titleAr: "محلل بيانات عن بُعد",
    companyEn: "DataMind Labs",
    companyAr: "مختبرات دايتا مايند",
    tags: ["remote", "partTime"],
    accessible: true,
    descEn: "Analyze datasets and create reports. Flexible hours, adaptive tools provided.",
    descAr: "تحليل مجموعات البيانات وإنشاء التقارير. ساعات مرنة، أدوات تكيفية متوفرة.",
  },
  {
    id: 4,
    titleEn: "Customer Support Lead",
    titleAr: "رئيس دعم العملاء",
    companyEn: "AccessFirst Inc",
    companyAr: "شركة الوصول أولاً",
    tags: ["remote", "fullTime"],
    accessible: true,
    descEn: "Lead a remote support team. Screen-reader compatible tools, flexible schedule.",
    descAr: "قيادة فريق دعم عن بُعد. أدوات متوافقة مع قارئات الشاشة، جدول مرن.",
  },
  {
    id: 5,
    titleEn: "Content Creator – ASL",
    titleAr: "منشئ محتوى – لغة الإشارة",
    companyEn: "SignBridge Media",
    companyAr: "سين بريدج ميديا",
    tags: ["contract", "remote"],
    accessible: true,
    descEn: "Create sign-language video content for educational platforms.",
    descAr: "إنشاء محتوى فيديو بلغة الإشارة للمنصات التعليمية.",
  },
];

export function FindJobsPage() {
  const navigate = useNavigate();
  const { t, isRTL, lang } = useApp();
  const [search, setSearch] = useState("");
  const [activeFilter, setActiveFilter] = useState("all");
  const [applied, setApplied] = useState<number[]>([]);
  const [cvUploaded, setCvUploaded] = useState(false);
  const [cvName, setCvName] = useState("");
  const [showSuccess, setShowSuccess] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

  const BackIcon = isRTL ? ChevronRight : ChevronLeft;

  const FILTERS = ["all", "remote", "fullTime", "hybrid", "contract", "partTime"];
  const filterLabels: Record<string, string> = {
    all: t("allJobs"),
    remote: t("remote"),
    fullTime: t("fullTime"),
    hybrid: t("hybrid"),
    contract: t("contract"),
    partTime: t("partTime"),
  };

  const tagLabel: Record<string, string> = {
    remote: t("remote"),
    fullTime: t("fullTime"),
    hybrid: t("hybrid"),
    contract: t("contract"),
    partTime: t("partTime"),
  };

  const filtered = JOBS_DATA.filter((job) => {
    const title = lang === "ar" ? job.titleAr : job.titleEn;
    const company = lang === "ar" ? job.companyAr : job.companyEn;
    const matchSearch =
      !search ||
      title.toLowerCase().includes(search.toLowerCase()) ||
      company.toLowerCase().includes(search.toLowerCase());
    const matchFilter = activeFilter === "all" || job.tags.includes(activeFilter);
    return matchSearch && matchFilter;
  });

  function handleApply(id: number) {
    setApplied((prev) => [...prev, id]);
  }

  function handleUpload() {
    fileRef.current?.click();
  }

  function handleFileChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (file) {
      setCvName(file.name);
      setCvUploaded(true);
      setShowSuccess(true);
      setTimeout(() => setShowSuccess(false), 3000);
    }
  }

  return (
    <div
      className="min-h-screen bg-[#F7F4F0] pb-28"
      dir={isRTL ? "rtl" : "ltr"}
    >
      {/* Header */}
      <div className="bg-white px-5 pt-12 pb-5 shadow-sm">
        <div className="flex items-center gap-3 mb-4">
          <button
            onClick={() => navigate("/dashboard")}
            className="w-9 h-9 flex items-center justify-center rounded-full bg-gray-100"
          >
            <BackIcon size={18} className="text-gray-600" />
          </button>
          <h1 className="text-[#111827] font-extrabold text-xl">{t("findJobs")}</h1>
        </div>

        {/* Search */}
        <div className="flex items-center gap-2 bg-gray-100 rounded-2xl px-4 py-3">
          <Search size={16} className="text-gray-400" />
          <input
            type="text"
            placeholder={t("searchJobs")}
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="flex-1 bg-transparent outline-none text-sm text-gray-700 placeholder:text-gray-400"
          />
          {search && (
            <button onClick={() => setSearch("")}>
              <X size={14} className="text-gray-400" />
            </button>
          )}
        </div>
      </div>

      <div className="px-5 pt-5 flex flex-col gap-5">
        {/* Upload CV Card */}
        <div className="bg-[#1C4532] rounded-2xl p-5">
          <div className="flex items-center gap-3 mb-3">
            <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center">
              <FileText size={18} className="text-white" />
            </div>
            <div>
              <p className="text-white font-bold text-sm">{t("uploadCV")}</p>
              <p className="text-white/70 text-xs">{t("cvDesc")}</p>
            </div>
          </div>
          {cvUploaded ? (
            <div className="flex items-center gap-2 bg-white/20 rounded-xl px-4 py-3">
              <CheckCircle size={16} className="text-white" />
              <span className="text-white text-sm font-medium truncate">{cvName}</span>
            </div>
          ) : (
            <button
              onClick={handleUpload}
              className="w-full bg-white text-[#1C4532] rounded-xl py-3 font-bold text-sm flex items-center justify-center gap-2"
            >
              <Upload size={16} />
              {t("upload")}
            </button>
          )}
          <input
            ref={fileRef}
            type="file"
            accept=".pdf,.doc,.docx"
            className="hidden"
            onChange={handleFileChange}
          />
        </div>

        {/* Success toast */}
        {showSuccess && (
          <div className="bg-[#D1FAE5] border border-[#1C4532]/20 rounded-2xl px-4 py-3 flex items-center gap-2">
            <CheckCircle size={16} className="text-[#1C4532]" />
            <span className="text-[#1C4532] text-sm font-medium">{t("cvUploaded")}</span>
          </div>
        )}

        {/* Filters */}
        <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
          {FILTERS.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFilter(f)}
              className={`px-4 py-2 rounded-full text-xs font-semibold whitespace-nowrap transition-colors ${
                activeFilter === f
                  ? "bg-[#1C4532] text-white"
                  : "bg-white text-gray-600 border border-gray-200"
              }`}
            >
              {filterLabels[f]}
            </button>
          ))}
        </div>

        {/* Jobs list */}
        <div>
          <p className="text-gray-500 text-xs font-medium mb-3">
            {filtered.length} {t("availableJobs")}
          </p>
          <div className="flex flex-col gap-4">
            {filtered.map((job) => {
              const isApplied = applied.includes(job.id);
              return (
                <div
                  key={job.id}
                  className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100"
                >
                  <div className="flex items-start justify-between gap-2 mb-3">
                    <div className="flex items-center gap-3">
                      <div className="w-11 h-11 bg-[#D1FAE5] rounded-xl flex items-center justify-center shrink-0">
                        <Briefcase size={18} className="text-[#1C4532]" />
                      </div>
                      <div>
                        <p className="font-bold text-[#111827] text-sm">
                          {lang === "ar" ? job.titleAr : job.titleEn}
                        </p>
                        <p className="text-gray-500 text-xs">
                          {lang === "ar" ? job.companyAr : job.companyEn}
                        </p>
                      </div>
                    </div>
                    {job.accessible && (
                      <div className="flex items-center gap-1 bg-[#D1FAE5] px-2 py-1 rounded-full shrink-0">
                        <CheckCircle size={10} className="text-[#1C4532]" />
                        <span className="text-[#1C4532] text-[10px] font-semibold">
                          {t("verified")}
                        </span>
                      </div>
                    )}
                  </div>

                  <p className="text-gray-500 text-xs mb-3 leading-relaxed">
                    {lang === "ar" ? job.descAr : job.descEn}
                  </p>

                  <div className="flex gap-2 flex-wrap mb-4">
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
                    onClick={() => handleApply(job.id)}
                    disabled={isApplied}
                    className={`w-full rounded-xl py-3 font-bold text-sm flex items-center justify-center gap-2 transition-all ${
                      isApplied
                        ? "bg-[#D1FAE5] text-[#1C4532]"
                        : "bg-[#1C4532] text-white active:opacity-90"
                    }`}
                  >
                    {isApplied ? t("applied") : t("applyNow")}
                  </button>
                </div>
              );
            })}

            {filtered.length === 0 && (
              <div className="text-center py-12 text-gray-400">
                <Briefcase size={40} className="mx-auto mb-3 opacity-40" />
                <p>{t("noResults")}</p>
              </div>
            )}
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}