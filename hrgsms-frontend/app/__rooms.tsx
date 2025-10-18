"use client";
import { useState } from "react";
import apiClient from "@/lib/apiClient";

export default function Rooms(){
  const [branch_id,setBranch]=useState(""); const [check_in,setIn]=useState(""); const [check_out,setOut]=useState("");
  const [rows,setRows]=useState<any[]>([]); const [msg,setMsg]=useState<string|null>(null);
  return (
    <div>
      <h1>Rooms</h1>
      <form onSubmit={async(e)=>{e.preventDefault(); setMsg(null); try{const r=await apiClient.get("/rooms/available",{params:{branch_id,check_in,check_out}}); setRows(r.data||[]);}catch(err:any){setMsg(err?.response?.data?.detail||"Failed");}}}>
        <label>Branch</label><input value={branch_id} onChange={e=>setBranch(e.target.value)} />
        <label>Check in</label><input type="datetime-local" value={check_in} onChange={e=>setIn(e.target.value)} />
        <label>Check out</label><input type="datetime-local" value={check_out} onChange={e=>setOut(e.target.value)} />
        <button>Search</button>
      </form>
      {msg && <p>{msg}</p>}
      <pre>{JSON.stringify(rows,null,2)}</pre>
    </div>
  );
}
