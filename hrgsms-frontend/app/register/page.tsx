"use client";
import { useState } from "react";
import apiClient from "@/lib/apiClient";
import Link from "next/link";

export default function RegisterPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState("Reception");
  const [branchId, setBranchId] = useState<string>("");   // ← NEW
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMessage(null); setError(null); setLoading(true);

    try {
      // basic guard so we always send a number
      const branch = Number(branchId);
      if (!branch || branch < 1) {
        setError("Please enter a valid Branch ID (positive number).");
        setLoading(false);
        return;
      }

      const body = {
        username,
        password,
        role,
        branch
      };

      const res = await apiClient.post("/auth/register", body);
      setMessage(res.data?.message || "Registered successfully.");
      setUsername(""); setPassword(""); setRole("Reception"); setBranchId(""); // reset
    } catch (err: any) {
      const detail = err?.response?.data?.detail || err?.message || "Registration failed";
      setError(typeof detail === "string" ? detail : JSON.stringify(detail));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="grid cols-2">
      <div className="card">
        <h1>Create your account</h1>
        <p className="note">Register to access HRGSMS.</p>

        <form onSubmit={onSubmit}>
          <label>Username</label>
          <input value={username} onChange={(e) => setUsername(e.target.value)} required />

          <label>Password</label>
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} required />

          <label>Role</label>
          <select value={role} onChange={(e) => setRole(e.target.value)} required>
            <option value="Admin">Admin</option>
            <option value="Manager">Manager</option>
            <option value="Reception">Reception</option>
            <option value="Staff">Staff</option>
          </select>

          {/* NEW: Branch ID */}
          <label>Branch ID</label>
          <input
            type="number"
            min={1}
            inputMode="numeric"
            value={branchId}
            onChange={(e) => setBranchId(e.target.value)}
            placeholder="e.g. 1"
            required
          />

          <button type="submit" disabled={loading}>
            {loading ? "Registering..." : "Register"}
          </button>

          {message && <p className="success">{message}</p>}
          {error && <p className="error">{error}</p>}
        </form>

        <div style={{ marginTop: 8 }}>
          <span className="note">Already have an account? </span>
          <Link href="/login" className="link">Sign in</Link>
        </div>
      </div>

      <div className="card">
        <h2>Allowed roles</h2>
        <ul>
          <li>Admin</li>
          <li>Manager</li>
          <li>Reception</li>
          <li>Staff</li>
        </ul>
      </div>
    </div>
  );
}
