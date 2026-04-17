import React from "react";
import { createBrowserRouter, Navigate } from "react-router";
import { LoginPage } from "./pages/LoginPage";
import { SignUpPage } from "./pages/SignUpPage";
import { SelectDisabilitiesPage } from "./pages/SelectDisabilitiesPage";
import { DashboardPage } from "./pages/DashboardPage";
import { FindJobsPage } from "./pages/FindJobsPage";
import { RequestBookPage } from "./pages/RequestBookPage";
import { FindDoctorPage } from "./pages/FindDoctorPage";
import { SignLanguagePage } from "./pages/SignLanguagePage";

export const router = createBrowserRouter([
  { path: "/", element: <Navigate to="/login" replace /> },
  { path: "/login", Component: LoginPage },
  { path: "/signup", Component: SignUpPage },
  { path: "/select-disabilities", Component: SelectDisabilitiesPage },
  { path: "/dashboard", Component: DashboardPage },
  { path: "/jobs", Component: FindJobsPage },
  { path: "/books", Component: RequestBookPage },
  { path: "/doctor", Component: FindDoctorPage },
  { path: "/sign-language", Component: SignLanguagePage },
  { path: "*", element: <Navigate to="/login" replace /> },
]);
