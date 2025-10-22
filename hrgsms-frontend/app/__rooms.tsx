"use client";
import { useState, useEffect } from "react";
import apiClient from "@/lib/apiClient";

export default function Rooms(){
  const [branch_id,setBranch]=useState("");
  const [check_in,setIn]=useState("");
  const [check_out,setOut]=useState("");
  const [rows,setRows]=useState<any[]>([]);
  const [msg,setMsg]=useState<string|null>(null);
  const [branches,setBranches]=useState<Array<{branchID:number,location:string}>>([]);

  useEffect(()=>{
    let mounted = true;
    apiClient.get("/branches/")
      .then(res=>{ if(mounted) setBranches(res.data || []); })
      .catch(()=>{ /* ignore branch load error for now */ });
    return ()=>{ mounted = false; };
  },[]);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMsg(null);
    // client-side validation: check-out must be after check-in
    if (check_in && check_out) {
      const inTs = new Date(check_in).getTime();
      const outTs = new Date(check_out).getTime();
      if (isNaN(inTs) || isNaN(outTs) || outTs <= inTs) {
        setMsg("Check-out must be after check-in");
        return;
      }
    }
    try{
      const r = await apiClient.get("/rooms/available",{params:{branch_id,check_in,check_out}});
      setRows(r.data||[]);
    }catch(err:any){ setMsg(err?.response?.data?.detail||"Failed"); }
  };

  return (
    <div>
      <h1>Rooms</h1>
      <form onSubmit={onSubmit}>
        <label>Branch</label>
        <select value={branch_id} onChange={e=>setBranch(e.target.value)}>
          <option value="">-- Select branch --</option>
          {branches.map(b=> <option key={b.branchID} value={String(b.branchID)}>{b.location}</option>)}
        </select>

        <label>Check in</label>
        <input type="datetime-local" value={check_in} onChange={e=>setIn(e.target.value)} />

        <label>Check out</label>
        <input type="datetime-local" value={check_out} onChange={e=>setOut(e.target.value)} />

        <button>Search</button>
      </form>
      {msg && <p style={{color:'red'}}>{msg}</p>}
      <pre>{JSON.stringify(rows,null,2)}</pre>
    </div>
  );
}
