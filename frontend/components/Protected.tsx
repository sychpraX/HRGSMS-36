"use client";
import { isLoggedIn } from "@/lib/auth";
import { useRouter } from "next/navigation";
import { useEffect, ReactNode } from "react";
export default function Protected({ children }: { children: ReactNode }) {
  const router = useRouter();
  useEffect(() => { if (!isLoggedIn()) router.replace("/login"); }, [router]);
  return <>{children}</>;
}
