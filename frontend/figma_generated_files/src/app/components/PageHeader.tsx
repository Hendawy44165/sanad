import React from "react";
import { useNavigate } from "react-router";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { useApp } from "../context/AppContext";

interface PageHeaderProps {
  title?: string;
  showBack?: boolean;
  backRoute?: string;
}

export function PageHeader({ title, showBack = true, backRoute }: PageHeaderProps) {
  const navigate = useNavigate();
  const { t, isRTL } = useApp();

  function handleBack() {
    if (backRoute) {
      navigate(backRoute);
    } else {
      navigate(-1);
    }
  }

  const BackIcon = isRTL ? ChevronRight : ChevronLeft;

  return (
    <div
      className="flex items-center gap-3 px-5 pt-12 pb-4"
      style={{ direction: isRTL ? "rtl" : "ltr" }}
    >
      {showBack && (
        <button
          onClick={handleBack}
          className="w-9 h-9 flex items-center justify-center rounded-full bg-white shadow-sm border border-gray-100 shrink-0"
        >
          <BackIcon size={18} className="text-[#1C4532]" />
        </button>
      )}
      {title && (
        <span className="text-[#1C4532] font-bold text-base">{title}</span>
      )}
      <div className="flex-1" />
      {/* App name on the right/left */}
      <span className="text-[#1C4532] font-bold text-base opacity-60">
        {/* Figma reference: shows app name in header */}
      </span>
    </div>
  );
}
