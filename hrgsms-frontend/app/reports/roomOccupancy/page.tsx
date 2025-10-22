"use client";
import { useState, useEffect } from "react";
import Protected from "@/components/Protected";
import apiClient from "@/lib/apiClient";

export default function RoomOccupancy() {
  const [startDate, setStartDate] = useState<string>("");
  const [endDate, setEndDate] = useState<string>("");
  const [branchId, setBranchId] = useState<string>("");
  const [rows, setRows] = useState<any[]>([]);
  const [branches, setBranches] = useState<any[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    apiClient.get('/branches/')
      .then(res => setBranches(res.data || []))
      .catch(() => {});
  }, []);

  const fetchReport = async (e: React.FormEvent) => {
    e.preventDefault(); setError(null);
    if (!branchId) { setError('Please select a branch'); return; }
    if (!startDate || !endDate) { setError('Please select start and end dates'); return; }
    if (new Date(endDate) <= new Date(startDate)) { setError('End date must be after start date'); return; }
    try {
      const res = await apiClient.get("/reports/roomOccupancy", { params: { branch_id: branchId, start_date: startDate, end_date: endDate } });
      setRows(res.data || []);
    } catch (err: any) { setError(err?.response?.data?.detail || "Failed to load report"); }
  };

  const available = rows.filter(r=> r.availability==="Available").length;
  const unavailable = rows.filter(r=> r.availability==="Unavailable").length;

  return (
    <Protected>
      <h1>Room Occupancy</h1>
      <form onSubmit={fetchReport} className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div>
          <label className="block text-sm font-medium text-gray-700">Branch</label>
          <select className="w-full p-2 border rounded" value={branchId} onChange={e=>setBranchId(e.target.value)} required>
            <option value="">-- Select branch --</option>
            {branches.map(b => <option key={b.branchID} value={String(b.branchID)}>{b.location}</option>)}
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Start Date</label>
          <input className="w-full p-2 border rounded" type="date" value={startDate} onChange={(e)=>setStartDate(e.target.value)} required />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">End Date</label>
          <input className="w-full p-2 border rounded" type="date" value={endDate} onChange={(e)=>setEndDate(e.target.value)} required />
        </div>
        <div className="flex items-end">
          <button className="bg-blue-500 text-white px-4 py-2 rounded" type="submit">Load</button>
        </div>
      </form>

      {rows.length>0 && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
          <div className="p-4 bg-white rounded shadow">
            <h3 className="text-sm text-gray-500">Available</h3>
            <p className="text-2xl font-bold">{available}</p>
          </div>
          <div className="p-4 bg-white rounded shadow">
            <h3 className="text-sm text-gray-500">Unavailable</h3>
            <p className="text-2xl font-bold">{unavailable}</p>
          </div>
        </div>
      )}

      <table className="w-full bg-white rounded shadow">
        <thead><tr><th className="p-2 border">location</th><th className="p-2 border">roomNo</th><th className="p-2 border">availability</th></tr></thead>
        <tbody>{rows.map((r, idx)=> (<tr key={idx}><td className="p-2 border">{r.location}</td><td className="p-2 border">{r.roomNo}</td><td className="p-2 border">{r.availability}</td></tr>))}</tbody>
      </table>
      {error && <p className="error">{error}</p>}
    </Protected>
  );
}
