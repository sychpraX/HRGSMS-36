"use client";
import { useState } from "react";
import apiClient from "@/lib/apiClient";
import { saveRole, saveToken } from "@/lib/auth";
import { useRouter } from "next/navigation";
import Link from "next/link";

export default function LoginPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    try {
      const res = await apiClient.post("/auth/login", { username, password });
      saveToken(res.data.access_token);
      if (res.data.role) saveRole(res.data.role);
      router.push("/dashboard");
    } catch (err: any) {
      setError(err?.response?.data?.detail || "Login failed");
    }
  };

  return (
    <div className="grid cols-2">
      <div className="card">
        <h1>Welcome back</h1>
        <p className="note">Sign in to continue to HRGSMS.</p>
        <form onSubmit={onSubmit}>
          <label>Username</label>
          <input
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
          <label>Password</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
          <button type="submit">Sign in</button>
          <div style={{ marginTop: 8 }}>
            <span className="note">New here? </span>
            <Link href="/register" className="link">
              Register
            </Link>
          </div>
          {error && <p className="error">{error}</p>}
        </form>
      </div>
      <div className="card">
        <h2>Why HRGSMS?</h2>
        <ul>
          <li>Quick reservations, accurate billing</li>
          <li>Role-based workflows</li>
          <li>Insightful reports</li>
        </ul>
      </div>
    </div>
  );
}
