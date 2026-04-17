import React, { useState } from "react";
import { useNavigate } from "react-router";
import {
  ChevronLeft,
  ChevronRight,
  Search,
  Stethoscope,
  Star,
  CalendarCheck,
  X,
  CheckCircle,
} from "lucide-react";
import { BottomNav } from "../components/BottomNav";
import { useApp } from "../context/AppContext";

const DOCTORS_DATA = [
  {
    id: 1,
    nameEn: "Dr. Layla Khaled",
    nameAr: "د. ليلى خالد",
    specialtyEn: "Neurology Specialist",
    specialtyAr: "أخصائية أعصاب",
    rating: 4.9,
    reviews: 120,
    categoryEn: "Neurology",
    categoryAr: "الأعصاب",
    accessibilitiesEn: ["Wheelchair Access", "Sign Language", "Audio Aids"],
    accessibilitiesAr: ["وصول لكراسي الإعاقة", "لغة الإشارة", "مساعدات صوتية"],
  },
  {
    id: 2,
    nameEn: "Dr. Omar Nasser",
    nameAr: "د. عمر ناصر",
    specialtyEn: "Physical Therapy",
    specialtyAr: "علاج طبيعي",
    rating: 4.8,
    reviews: 85,
    categoryEn: "Physical",
    categoryAr: "الحركي",
    accessibilitiesEn: ["Braille Materials", "Wheelchair Access"],
    accessibilitiesAr: ["مواد برايل", "وصول لكراسي الإعاقة"],
  },
  {
    id: 3,
    nameEn: "Dr. Sara Mahmoud",
    nameAr: "د. سارة محمود",
    specialtyEn: "Occupational Therapist",
    specialtyAr: "معالج مهني",
    rating: 4.7,
    reviews: 64,
    categoryEn: "Occupational",
    categoryAr: "المهني",
    accessibilitiesEn: ["Sign Language", "Sensory-Friendly", "Audio Aids"],
    accessibilitiesAr: ["لغة الإشارة", "صديق للحساسية الحسية", "مساعدات صوتية"],
  },
  {
    id: 4,
    nameEn: "Dr. Khalid Essa",
    nameAr: "د. خالد عيسى",
    specialtyEn: "Speech-Language Pathologist",
    specialtyAr: "أخصائي النطق واللغة",
    rating: 4.9,
    reviews: 97,
    categoryEn: "Speech",
    categoryAr: "النطق",
    accessibilitiesEn: ["AAC Devices", "Sign Language", "Visual Aids"],
    accessibilitiesAr: ["أجهزة التواصل المعزز", "لغة الإشارة", "مساعدات بصرية"],
  },
  {
    id: 5,
    nameEn: "Dr. Nour Hamdan",
    nameAr: "د. نور حمدان",
    specialtyEn: "Child Psychologist",
    specialtyAr: "أخصائية نفسية للأطفال",
    rating: 4.8,
    reviews: 112,
    categoryEn: "Psychology",
    categoryAr: "النفسي",
    accessibilitiesEn: ["Sensory-Friendly", "Braille Materials", "Wheelchair Access"],
    accessibilitiesAr: ["صديق للحساسية الحسية", "مواد برايل", "وصول لكراسي الإعاقة"],
  },
];

const SPECIALTIES = ["all", "Neurology", "Physical", "Occupational", "Speech", "Psychology"];

export function FindDoctorPage() {
  const navigate = useNavigate();
  const { t, isRTL, lang } = useApp();
  const [search, setSearch] = useState("");
  const [activeSpec, setActiveSpec] = useState("all");
  const [booked, setBooked] = useState<number[]>([]);

  const BackIcon = isRTL ? ChevronRight : ChevronLeft;

  const specLabels: Record<string, { en: string; ar: string }> = {
    all: { en: "All", ar: "الكل" },
    Neurology: { en: "Neurology", ar: "الأعصاب" },
    Physical: { en: "Physical", ar: "الحركي" },
    Occupational: { en: "Occupational", ar: "المهني" },
    Speech: { en: "Speech", ar: "النطق" },
    Psychology: { en: "Psychology", ar: "النفسي" },
  };

  const filtered = DOCTORS_DATA.filter((doc) => {
    const name = lang === "ar" ? doc.nameAr : doc.nameEn;
    const spec = lang === "ar" ? doc.specialtyAr : doc.specialtyEn;
    const matchSearch =
      !search ||
      name.toLowerCase().includes(search.toLowerCase()) ||
      spec.toLowerCase().includes(search.toLowerCase());
    const matchSpec = activeSpec === "all" || doc.categoryEn === activeSpec;
    return matchSearch && matchSpec;
  });

  function handleBook(id: number) {
    setBooked((prev) => [...prev, id]);
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
          <h1 className="text-[#111827] font-extrabold text-xl">{t("findDoctor")}</h1>
        </div>

        {/* Search */}
        <div className="flex items-center gap-2 bg-gray-100 rounded-2xl px-4 py-3">
          <Search size={16} className="text-gray-400" />
          <input
            type="text"
            placeholder={t("searchDoctor")}
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
        {/* Specialty filters */}
        <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
          {SPECIALTIES.map((s) => (
            <button
              key={s}
              onClick={() => setActiveSpec(s)}
              className={`px-4 py-2 rounded-full text-xs font-semibold whitespace-nowrap transition-colors ${
                activeSpec === s
                  ? "bg-[#1C4532] text-white"
                  : "bg-white text-gray-600 border border-gray-200"
              }`}
            >
              {lang === "ar" ? specLabels[s].ar : specLabels[s].en}
            </button>
          ))}
        </div>

        {/* Doctors list */}
        <div className="flex flex-col gap-4">
          {filtered.map((doc) => {
            const isBooked = booked.includes(doc.id);
            const accList = lang === "ar" ? doc.accessibilitiesAr : doc.accessibilitiesEn;
            return (
              <div
                key={doc.id}
                className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100"
              >
                <div className="flex items-start gap-4 mb-4">
                  <div className="w-14 h-14 rounded-2xl bg-[#D1FAE5] flex items-center justify-center shrink-0">
                    <Stethoscope size={24} className="text-[#1C4532]" />
                  </div>
                  <div className="flex-1">
                    <p className="font-bold text-[#111827] text-base">
                      {lang === "ar" ? doc.nameAr : doc.nameEn}
                    </p>
                    <p className="text-gray-500 text-sm">
                      {lang === "ar" ? doc.specialtyAr : doc.specialtyEn}
                    </p>
                    <div className="flex items-center gap-1 mt-1">
                      {[...Array(5)].map((_, i) => (
                        <Star
                          key={i}
                          size={12}
                          className={
                            i < Math.floor(doc.rating)
                              ? "text-amber-400 fill-amber-400"
                              : "text-gray-200 fill-gray-200"
                          }
                        />
                      ))}
                      <span className="text-xs text-gray-500 ms-1">
                        {doc.rating} ({doc.reviews} {t("reviews")})
                      </span>
                    </div>
                  </div>
                </div>

                {/* Accessibility features */}
                <div className="flex gap-2 flex-wrap mb-4">
                  {accList.map((acc) => (
                    <span
                      key={acc}
                      className="bg-[#D1FAE5] text-[#1C4532] text-[10px] font-semibold px-2.5 py-1 rounded-full flex items-center gap-1"
                    >
                      <CheckCircle size={9} />
                      {acc}
                    </span>
                  ))}
                </div>

                <button
                  onClick={() => handleBook(doc.id)}
                  disabled={isBooked}
                  className={`w-full rounded-xl py-3 font-bold text-sm flex items-center justify-center gap-2 transition-all ${
                    isBooked
                      ? "bg-[#D1FAE5] text-[#1C4532]"
                      : "bg-[#1C4532] text-white active:opacity-90"
                  }`}
                >
                  <CalendarCheck size={16} />
                  {isBooked ? t("booked") : t("bookAppointment")}
                </button>
              </div>
            );
          })}

          {filtered.length === 0 && (
            <div className="text-center py-12 text-gray-400">
              <Stethoscope size={40} className="mx-auto mb-3 opacity-40" />
              <p>{t("noResults")}</p>
            </div>
          )}
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
