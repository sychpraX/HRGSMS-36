"use client";
import { useEffect } from "react";
import { useRouter } from "next/navigation";
export default function Home(){ const r=useRouter(); useEffect(()=>{r.replace("/dashboard");},[r]); return null; }
