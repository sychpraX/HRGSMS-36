"use client";
import { useState } from "react";
import Protected from "@/components/Protected";
import apiClient from "@/lib/apiClient";
import ChartBox from "@/components/Chart";

export default function RevenueReport() {
  const [branchId, setBranchId] = useState<string>("");
  const [startDate, setStartDate] = useState<string>("");
  const [endDate, setEndDate] = useState<string>("");
  const [rows, setRows] = useState<any[]>([]);
  const [error, setError] = useState<string | null>(null);

  const fetchReport = async (e: React.FormEvent) => {
    e.preventDefault(); setError(null);
    try {
      const res = await apiClient.get("/reports/revenue", { params: { branch_id: branchId, start_date: startDate, end_date: endDate } });
      setRows(res.data || []);
    } catch (err: any) { setError(err?.response?.data?.detail || "Failed to load report"); }
  };

  return (
    <Protected>
      <h1>Revenue Report</h1>
      <form onSubmit={fetchReport}>
        <label>Branch ID</label><input value={branchId} onChange={(e)=>setBranchId(e.target.value)} required />
        <label>Start Date</label><input type="date" value={startDate} onChange={(e)=>setStartDate(e.target.value)} required />
        <label>End Date</label><input type="date" value={endDate} onChange={(e)=>setEndDate(e.target.value)} required />
        <button type="submit">Load</button>
      </form>

      {rows.length>0 && (
        <ChartBox type="line" labels={rows.map(r=> r.date)} datasets={[
          { label:"Total Revenue", data: rows.map(r=> Number(r.total_revenue)||0) },
          { label:"Collected Amount", data: rows.map(r=> Number(r.collected_amount)||0) }
        ]} />
      )}

      <table>
        <thead><tr><th>date</th><th>bookings</th><th>total_revenue</th><th>collected_amount</th></tr></thead>
        <tbody>{rows.map((r, idx)=> (<tr key={idx}><td>{r.date}</td><td>{r.bookings}</td><td>{r.total_revenue}</td><td>{r.collected_amount}</td></tr>))}</tbody>
      </table>
      {error && <p className="error">{error}</p>}
    </Protected>
  );
}
