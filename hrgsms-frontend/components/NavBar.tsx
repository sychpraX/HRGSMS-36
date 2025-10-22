"use client";
import Link from "next/link";
import { useEffect, useState } from "react";
import { clearToken, getRole, isLoggedIn } from "@/lib/auth";
import { useRouter, usePathname } from "next/navigation";

export default function NavBar() {
  const router = useRouter();
  const pathname = usePathname();
  const [role, setRole] = useState<string | null>(null);
  const [logged, setLogged] = useState(false);

  useEffect(() => { setRole(getRole()); setLogged(isLoggedIn()); }, [pathname]);
  const logout = () => { clearToken(); router.push("/login"); };

  return (
    <nav>
      <div className="brand"><span style={{fontSize:18}}>🏨 HRGSMS</span></div>
      <div className="links">
        <Link href="/dashboard">Dashboard</Link>
        <Link href="/guests">Guests</Link>
        <Link href="/rooms">Rooms</Link>
        <Link href="/reservations">Reservations</Link>
        <Link href="/services">Services</Link>
        <Link href="/payments">Payments</Link>
        <Link href="/reports/revenue">Revenue</Link>
        <Link href="/reports/roomOccupancy">Occupancy</Link>
        <Link href="/reports/guestBilling">Guest Billing</Link>
        <Link href="/reports/serviceUsage">Service Usage</Link>
        <Link href="/reports/customerTrends">Trends</Link>
      </div>
      <div className="right">
        {logged ? <span className="note">Role: <b>{role ?? "Unknown"}</b></span> : <Link href="/login">Login</Link>}
        {logged && <button onClick={logout}>Logout</button>}
      </div>
    </nav>
  );
}
