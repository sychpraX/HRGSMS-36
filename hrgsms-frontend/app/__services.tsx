"use client";
import { useState } from "react";
import apiClient from "@/lib/apiClient";
export default function Services(){
  const [f,setF]=useState({booking_id:"", service_id:"", quantity:"1"}); const [msg,setMsg]=useState<string|null>(null);
  return (
    <div>
      <h1>Service Usage</h1>
      <form onSubmit={async(e)=>{e.preventDefault(); setMsg(null);
        try{const r=await apiClient.post("/services/usage",{booking_id:+f.booking_id, service_id:+f.service_id, quantity:+f.quantity}); setMsg("Usage ID: "+r.data.usage_id);}catch(err:any){setMsg(err?.response?.data?.detail||"Failed");}}}>
        <label>Booking</label><input value={f.booking_id} onChange={e=>setF({...f,booking_id:e.target.value})}/>
        <label>Service</label><input value={f.service_id} onChange={e=>setF({...f,service_id:e.target.value})}/>
        <label>Qty</label><input type="number" value={f.quantity} onChange={e=>setF({...f,quantity:e.target.value})}/>
        <button>Add</button>
      </form>
      {msg && <p>{msg}</p>}
    </div>
  );
}
