import React, { useState } from "react";
import { useNavigate } from "react-router";
import {
  ChevronLeft,
  ChevronRight,
  Search,
  BookOpen,
  Headphones,
  Type,
  Monitor,
  X,
  CheckCircle,
} from "lucide-react";
import { BottomNav } from "../components/BottomNav";
import { useApp } from "../context/AppContext";

const BOOKS_DATA = [
  {
    id: 1,
    titleEn: "The Art of Possibility",
    titleAr: "فن الإمكانية",
    authorEn: "Rosamund Stone Zander",
    authorAr: "روزاموند ستون زاندر",
    formats: ["audioBook", "brailleBook", "largeText"],
    categoryEn: "Personal Growth",
    categoryAr: "النمو الشخصي",
  },
  {
    id: 2,
    titleEn: "Disability Visibility",
    titleAr: "رؤية الإعاقة",
    authorEn: "Alice Wong",
    authorAr: "أليس وونج",
    formats: ["audioBook", "ebook"],
    categoryEn: "Society",
    categoryAr: "المجتمع",
  },
  {
    id: 3,
    titleEn: "A Still Small Voice",
    titleAr: "صوت هادئ صغير",
    authorEn: "Echo Bodine",
    authorAr: "إيكو بودين",
    formats: ["audioBook", "largeText", "ebook"],
    categoryEn: "Spirituality",
    categoryAr: "الروحانيات",
  },
  {
    id: 4,
    titleEn: "The Brain That Changes Itself",
    titleAr: "الدماغ الذي يغير نفسه",
    authorEn: "Norman Doidge",
    authorAr: "نورمان دويدج",
    formats: ["audioBook", "brailleBook"],
    categoryEn: "Neuroscience",
    categoryAr: "علم الأعصاب",
  },
  {
    id: 5,
    titleEn: "Educated",
    titleAr: "متعلّمة",
    authorEn: "Tara Westover",
    authorAr: "تارا ويستوفر",
    formats: ["audioBook", "ebook", "largeText"],
    categoryEn: "Memoir",
    categoryAr: "مذكرات",
  },
  {
    id: 6,
    titleEn: "Wonder",
    titleAr: "معجزة",
    authorEn: "R. J. Palacio",
    authorAr: "آر. جي. بالاسيو",
    formats: ["brailleBook", "audioBook", "largeText", "ebook"],
    categoryEn: "Fiction",
    categoryAr: "رواية",
  },
];

const FORMAT_ICONS: Record<string, React.ReactNode> = {
  audioBook: <Headphones size={12} />,
  brailleBook: <Type size={12} />,
  largeText: <Type size={12} />,
  ebook: <Monitor size={12} />,
};

export function RequestBookPage() {
  const navigate = useNavigate();
  const { t, isRTL, lang } = useApp();
  const [search, setSearch] = useState("");
  const [activeFormat, setActiveFormat] = useState("all");
  const [requested, setRequested] = useState<number[]>([]);

  const BackIcon = isRTL ? ChevronRight : ChevronLeft;

  const FORMATS = ["all", "audioBook", "brailleBook", "largeText", "ebook"];
  const formatLabels: Record<string, string> = {
    all: t("allFormats"),
    audioBook: t("audioBook"),
    brailleBook: t("brailleBook"),
    largeText: t("largeText"),
    ebook: t("ebook"),
  };

  const filtered = BOOKS_DATA.filter((book) => {
    const title = lang === "ar" ? book.titleAr : book.titleEn;
    const author = lang === "ar" ? book.authorAr : book.authorEn;
    const matchSearch =
      !search ||
      title.toLowerCase().includes(search.toLowerCase()) ||
      author.toLowerCase().includes(search.toLowerCase());
    const matchFormat =
      activeFormat === "all" || book.formats.includes(activeFormat);
    return matchSearch && matchFormat;
  });

  function handleRequest(id: number) {
    setRequested((prev) => [...prev, id]);
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
          <h1 className="text-[#111827] font-extrabold text-xl">{t("requestBook")}</h1>
        </div>

        {/* Search */}
        <div className="flex items-center gap-2 bg-gray-100 rounded-2xl px-4 py-3">
          <Search size={16} className="text-gray-400" />
          <input
            type="text"
            placeholder={t("searchBooks")}
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
        {/* Info banner */}
        <div className="bg-[#D1FAE5] rounded-2xl p-4 flex items-start gap-3">
          <div className="w-9 h-9 bg-[#1C4532] rounded-xl flex items-center justify-center shrink-0 mt-0.5">
            <BookOpen size={16} className="text-white" />
          </div>
          <div>
            <p className="text-[#1C4532] font-bold text-sm mb-0.5">
              {lang === "ar" ? "متاح بتنسيقات متعددة" : "Available in Multiple Formats"}
            </p>
            <p className="text-[#1C4532]/70 text-xs leading-relaxed">
              {lang === "ar"
                ? "اطلب أي كتاب بتنسيق صوتي أو برايل أو طباعة كبيرة أو إلكتروني."
                : "Request any book in audio, Braille, large print, or e-book format."}
            </p>
          </div>
        </div>

        {/* Format filters */}
        <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
          {FORMATS.map((f) => (
            <button
              key={f}
              onClick={() => setActiveFormat(f)}
              className={`px-4 py-2 rounded-full text-xs font-semibold whitespace-nowrap flex items-center gap-1.5 transition-colors ${
                activeFormat === f
                  ? "bg-[#1C4532] text-white"
                  : "bg-white text-gray-600 border border-gray-200"
              }`}
            >
              {f !== "all" && FORMAT_ICONS[f]}
              {formatLabels[f]}
            </button>
          ))}
        </div>

        {/* Books */}
        <div className="flex flex-col gap-4">
          {filtered.map((book) => {
            const isRequested = requested.includes(book.id);
            return (
              <div
                key={book.id}
                className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100"
              >
                <div className="flex gap-4 mb-3">
                  <div className="w-14 h-20 bg-[#D1FAE5] rounded-xl flex items-center justify-center shrink-0">
                    <BookOpen size={24} className="text-[#1C4532]" />
                  </div>
                  <div className="flex-1">
                    <p className="font-bold text-[#111827] text-sm leading-snug">
                      {lang === "ar" ? book.titleAr : book.titleEn}
                    </p>
                    <p className="text-gray-500 text-xs mt-1">
                      {lang === "ar" ? book.authorAr : book.authorEn}
                    </p>
                    <span className="inline-block mt-1.5 bg-gray-100 text-gray-500 text-[10px] font-medium px-2 py-0.5 rounded-full">
                      {lang === "ar" ? book.categoryAr : book.categoryEn}
                    </span>
                  </div>
                </div>

                {/* Available formats */}
                <div className="flex gap-2 flex-wrap mb-4">
                  {book.formats.map((f) => (
                    <span
                      key={f}
                      className="bg-[#D1FAE5] text-[#1C4532] text-[10px] font-semibold px-2.5 py-1 rounded-full flex items-center gap-1"
                    >
                      {FORMAT_ICONS[f]}
                      {formatLabels[f]}
                    </span>
                  ))}
                </div>

                <button
                  onClick={() => handleRequest(book.id)}
                  disabled={isRequested}
                  className={`w-full rounded-xl py-3 font-bold text-sm transition-all ${
                    isRequested
                      ? "bg-[#D1FAE5] text-[#1C4532] flex items-center justify-center gap-2"
                      : "bg-[#1C4532] text-white active:opacity-90"
                  }`}
                >
                  {isRequested ? (
                    <>
                      <CheckCircle size={16} />
                      {t("requested")}
                    </>
                  ) : (
                    t("requestBtn")
                  )}
                </button>
              </div>
            );
          })}

          {filtered.length === 0 && (
            <div className="text-center py-12 text-gray-400">
              <BookOpen size={40} className="mx-auto mb-3 opacity-40" />
              <p>{t("noResults")}</p>
            </div>
          )}
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
