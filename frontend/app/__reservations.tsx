"use client";
import { useState } from "react";
import apiClient from "@/lib/apiClient";
export default function Reservations(){
  const [f,setF]=useState({guest_id:"",branch_id:"",room_id:"",check_in_date:"",check_out_date:"",num_guests:""});
  const [msg,setMsg]=useState<string|null>(null); const [id,setId]=useState("");
  return (
    <div>
      <h1>Reservations</h1>
      <form onSubmit={async(e)=>{e.preventDefault(); setMsg(null);
        try{const r=await apiClient.post("/reservations/",{...f, guest_id:+f.guest_id, branch_id:+f.branch_id, room_id:+f.room_id, num_guests:+f.num_guests});
        setMsg("Created booking: "+r.data.booking_id);}catch(err:any){setMsg(err?.response?.data?.detail||"Failed");}}}>
        <label>Guest</label><input value={f.guest_id} onChange={e=>setF({...f,guest_id:e.target.value})}/>
        <label>Branch</label><input value={f.branch_id} onChange={e=>setF({...f,branch_id:e.target.value})}/>
        <label>Room</label><input value={f.room_id} onChange={e=>setF({...f,room_id:e.target.value})}/>
        <label>Check in</label><input type="date" value={f.check_in_date} onChange={e=>setF({...f,check_in_date:e.target.value})}/>
        <label>Check out</label><input type="date" value={f.check_out_date} onChange={e=>setF({...f,check_out_date:e.target.value})}/>
        <label>Guests</label><input type="number" value={f.num_guests} onChange={e=>setF({...f,num_guests:e.target.value})}/>
        <button>Create</button>
      </form>
      <div>
        <label>Booking ID</label><input value={id} onChange={e=>setId(e.target.value)}/>
        <button onClick={async()=>{ setMsg(null); try{await apiClient.post(`/reservations/${id}/checkin`); setMsg("Check-in OK");}catch(err:any){setMsg(err?.response?.data?.detail||"Failed");}}}>Check-in</button>
        <button onClick={async()=>{ setMsg(null); try{await apiClient.post(`/reservations/${id}/checkout`); setMsg("Check-out OK");}catch(err:any){setMsg(err?.response?.data?.detail||"Failed");}}}>Check-out</button>
      </div>
      {msg && <p>{msg}</p>}
    </div>
  );
}
