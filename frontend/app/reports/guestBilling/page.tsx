"use client";
import Protected from "@/components/Protected";
import apiClient from "@/lib/apiClient";
import { useState } from "react";
import ChartBox from "@/components/Chart";

export default function GuestBilling() {
  const [rows, setRows] = useState<any[]>([]);
  const [error, setError] = useState<string | null>(null);

  const fetchReport = async () => {
    setError(null);
    try { const res = await apiClient.get("/reports/guestBilling"); setRows(res.data || []); }
    catch (err: any) { setError(err?.response?.data?.detail || "Failed to load report"); }
  };

  const labels = rows.map((r:any)=> r.guestName);
  const data = rows.map((r:any)=> Number(r.unpaid_amount)||0);

  return (
    <Protected>
      <h1>Guest Billing (Unpaid)</h1>
      <button onClick={fetchReport}>Load</button>

      {rows.length>0 && (
        <ChartBox type="bar" labels={labels} datasets={[{label:"Unpaid Amount", data}]} />
      )}

      <table>
        <thead><tr><th>invoiceID</th><th>guestName</th><th>unpaid_amount</th></tr></thead>
        <tbody>{rows.map((r, idx)=> (<tr key={idx}><td>{r.invoiceID}</td><td>{r.guestName}</td><td>{r.unpaid_amount}</td></tr>))}</tbody>
      </table>
      {error && <p className="error">{error}</p>}
    </Protected>
  );
}
