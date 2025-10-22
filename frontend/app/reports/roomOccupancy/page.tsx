"use client";
import { useState } from "react";
import Protected from "@/components/Protected";
import apiClient from "@/lib/apiClient";
import ChartBox from "@/components/Chart";

export default function RoomOccupancy() {
  const [startDate, setStartDate] = useState<string>("");
  const [endDate, setEndDate] = useState<string>("");
  const [rows, setRows] = useState<any[]>([]);
  const [error, setError] = useState<string | null>(null);

  const fetchReport = async (e: React.FormEvent) => {
    e.preventDefault(); setError(null);
    try {
      const res = await apiClient.get("/reports/roomOccupancy", { params: { start_date: startDate, end_date: endDate } });
      setRows(res.data || []);
    } catch (err: any) { setError(err?.response?.data?.detail || "Failed to load report"); }
  };

  const available = rows.filter(r=> r.availability==="Available").length;
  const unavailable = rows.filter(r=> r.availability==="Unavailable").length;

  return (
    <Protected>
      <h1>Room Occupancy</h1>
      <form onSubmit={fetchReport}>
        <label>Start Date</label><input type="date" value={startDate} onChange={(e)=>setStartDate(e.target.value)} required />
        <label>End Date</label><input type="date" value={endDate} onChange={(e)=>setEndDate(e.target.value)} required />
        <button type="submit">Load</button>
      </form>

      {rows.length>0 && (
        <ChartBox type="pie" labels={["Available","Unavailable"]} datasets={[{ label:"Rooms", data:[available, unavailable]}]} />
      )}

      <table>
        <thead><tr><th>location</th><th>roomNo</th><th>availability</th></tr></thead>
        <tbody>{rows.map((r, idx)=> (<tr key={idx}><td>{r.location}</td><td>{r.roomNo}</td><td>{r.availability}</td></tr>))}</tbody>
      </table>
      {error && <p className="error">{error}</p>}
    </Protected>
  );
}
