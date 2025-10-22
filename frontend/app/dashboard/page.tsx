"use client";
import Image from "next/image";
import Protected from "@/components/Protected";

export default function Dashboard() {
  return (
    <Protected>
      <main
        style={{
          minHeight: "calc(100vh - 4rem)",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          gap: 8,                 // was 32 → tighter space
          padding: "0 16px",
        }}
      >
        <h1
          style={{
            textAlign: "center",
            fontSize: "clamp(2.5rem, 6vw, 4.5rem)",
            fontWeight: 900,
            letterSpacing: ".02em",
            lineHeight: 1.1,
            marginBottom: 4,       // add a tiny bottom margin
          }}
        >
          <span
            style={{
              background: "linear-gradient(135deg, #0ea5e9 0%, #7c3aed 100%)",
              WebkitBackgroundClip: "text",
              backgroundClip: "text",
              color: "transparent",
              display: "inline-block",
            }}
          >
            Welcome to SkyNest Hotels
          </span>
        </h1>

        {/* Hero image */}
        <div
          style={{
            width: "min(90vw, 1000px)",
            margin: "0 auto",
            paddingInline: 24,
            height: "52vh",
            position: "relative",
          }}
        >
          <Image
            src="/skynest.png"
            alt="SkyNest Hotels logo"
            fill
            priority
            sizes="(max-width: 1000px) 90vw, 1000px"
            style={{
              objectFit: "contain",
              borderRadius: 16,
              boxShadow: "0 12px 40px rgba(9, 3, 84, 0.35)",
            }}
          />
        </div>
      </main>
    </Protected>
  );
}
