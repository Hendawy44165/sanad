import React from "react";
import { RouterProvider } from "react-router";
import { router } from "./routes";
import { AppProvider, useApp } from "./context/AppContext";
import "../styles/fonts.css";

function AppShell() {
  const { isRTL } = useApp();
  return (
    <div
      dir={isRTL ? "rtl" : "ltr"}
      className="w-full max-w-[430px] min-h-screen bg-[#F7F4F0] relative overflow-x-hidden shadow-2xl"
      style={{ fontFamily: "'Cairo', sans-serif" }}
    >
      <RouterProvider router={router} />
    </div>
  );
}

export default function App() {
  return (
    <AppProvider>
      <div
        className="min-h-screen bg-gray-300 flex items-center justify-center"
        style={{ fontFamily: "'Cairo', sans-serif" }}
      >
        <AppShell />
      </div>
    </AppProvider>
  );
}
