"use client";
import Protected from "@/components/Protected";
import apiClient from "@/lib/apiClient";
import { useState } from "react";
import ChartBox from "@/components/Chart";

export default function ServiceUsage() {
  const [rows, setRows] = useState<any[]>([]);
  const [error, setError] = useState<string | null>(null);

  const fetchReport = async () => {
    setError(null);
    try { const res = await apiClient.get("/reports/serviceUsage"); setRows(res.data || []); }
    catch (err: any) { setError(err?.response?.data?.detail || "Failed to load report"); }
  };

  const agg: Record<string, {qty:number, amt:number}> = {};
  for (const r of rows){
    const key = String(r.serviceType);
    if (!agg[key]) agg[key] = {qty:0, amt:0};
    agg[key].qty += Number(r.total_quantity)||0;
    agg[key].amt += Number(r.total_amount)||0;
  }
  const labels = Object.keys(agg);
  const qty = labels.map(k=> agg[k].qty);
  const amt = labels.map(k=> agg[k].amt);

  return (
    <Protected>
      <h1>Service Usage</h1>
      <button onClick={fetchReport}>Load</button>

      {rows.length>0 && (
        <ChartBox type="bar" labels={labels} datasets={[{label:"Quantity", data: qty}, {label:"Amount", data: amt}]} />
      )}

      <table>
        <thead><tr><th>location</th><th>roomNo</th><th>serviceType</th><th>total_quantity</th><th>total_amount</th></tr></thead>
        <tbody>{rows.map((r, idx)=> (<tr key={idx}><td>{r.location}</td><td>{r.roomNo}</td><td>{r.serviceType}</td><td>{r.total_quantity}</td><td>{r.total_amount}</td></tr>))}</tbody>
      </table>
      {error && <p className="error">{error}</p>}
    </Protected>
  );
}
