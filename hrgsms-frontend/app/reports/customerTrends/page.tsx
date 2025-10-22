"use client";
import Protected from "@/components/Protected";
import apiClient from "@/lib/apiClient";
import { useState } from "react";

type TrendsRow = {
  branch_name: string;
  most_used_room_type: string;
  room_bookings: number;
  most_used_service_type: string;
  service_usage_count: number;
  avg_spend_per_customer: number;
};

export default function CustomerTrends() {
  const [branchId, setBranchId] = useState<string>("");
  const [startDate, setStartDate] = useState<string>("");
  const [endDate, setEndDate] = useState<string>("");
  const [rows, setRows] = useState<TrendsRow[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const fetchReport = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    try {
      const res = await apiClient.get("/reports/customerTrends", {
        params: { branch_id: branchId, start_date: startDate, end_date: endDate },
      });
      const data: TrendsRow[] = Array.isArray(res.data) ? res.data : (res.data ? [res.data] : []);
      setRows(data);
    } catch (err: any) {
      setError(err?.response?.data?.detail || "Failed to load customer trends");
    } finally {
      setLoading(false);
    }
  };

  const row = rows[0];

  return (
    <Protected>
      <h1>Customer Trends</h1>

      <form onSubmit={fetchReport} style={{ maxWidth: 720, margin: "0 auto 16px" }}>
        <label>Branch ID</label>
        <input value={branchId} onChange={(e)=>setBranchId(e.target.value)} required />
        <label>Start Date</label>
        <input type="date" value={startDate} onChange={(e)=>setStartDate(e.target.value)} required />
        <label>End Date</label>
        <input type="date" value={endDate} onChange={(e)=>setEndDate(e.target.value)} required />
        <button type="submit" disabled={loading}>{loading ? "Loading..." : "Load"}</button>
      </form>

      {row && (
        <div className="card" style={{ maxWidth: 720, margin: "0 auto" }}>
          <h3 style={{ textAlign: "center", marginTop: 0 }}>Summary</h3>
          <table>
            <tbody>
              <tr><th>Branch</th><td>{row.branch_name}</td></tr>
              <tr><th>Most Used Room Type</th><td>{row.most_used_room_type}</td></tr>
              <tr><th>Room Bookings</th><td>{row.room_bookings}</td></tr>
              <tr><th>Most Used Service Type</th><td>{row.most_used_service_type}</td></tr>
              <tr><th>Service Usage Count</th><td>{row.service_usage_count}</td></tr>
              <tr><th>Avg Spend per Customer (LKR)</th><td>{row.avg_spend_per_customer}</td></tr>
            </tbody>
          </table>
        </div>
      )}

      {!row && !loading && (
        <p className="note" style={{ textAlign: "center" }}>
          Load a date range to view customer trends.
        </p>
      )}

      {error && <p className="error" style={{ textAlign: "center" }}>{error}</p>}
    </Protected>
  );
}
