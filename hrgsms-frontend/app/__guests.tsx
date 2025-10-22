"use client";
import { useState, useRef } from "react";
import apiClient from "@/lib/apiClient";

export default function Guests(){
  const [id,setId]=useState(""); const [data,setData]=useState<any>(null); const [msg,setMsg]=useState<string|null>(null);
  const [form,setForm]=useState({first_name:"",last_name:"",phone:"",email:"",id_number:""});
  const [errors, setErrors] = useState<string|null>(null);
  const errorTimer = useRef<number | null>(null);

  const showTemporaryError = (msg: string, ms = 3000) => {
    setErrors(msg);
    if (errorTimer.current) window.clearTimeout(errorTimer.current);
    
    let startTime: number;
    const animate = (timestamp: number) => {
      if (!startTime) startTime = timestamp;
      const elapsed = timestamp - startTime;
      
      if (elapsed < ms) {
        errorTimer.current = requestAnimationFrame(animate) as unknown as number;
      } else {
        setErrors(null);
        errorTimer.current = null;
      }
    };
    
    errorTimer.current = requestAnimationFrame(animate) as unknown as number;
  }
  
  // Format a 10-digit phone number as (XXX) XXX-XXXX for display
  const formatPhone = (digits: string) => {
    const d = (digits || "").replace(/\D/g, '').slice(0,10);
    if (d.length <= 3) return d;
    if (d.length <= 6) return `(${d.slice(0,3)}) ${d.slice(3)}`;
    return `(${d.slice(0,3)}) ${d.slice(3,6)}-${d.slice(6)}`;
  };
  return (
    <div>
      <h1>Guests</h1>
      {/* Popover / toast for temporary errors */}
      {errors && (
        <div className="fixed top-4 right-4 z-50">
          <div role="alert" className="bg-red-600 text-white px-4 py-2 rounded shadow-lg">
            {errors}
          </div>
        </div>
      )}
      <form onSubmit={async(e)=>{
        e.preventDefault(); setMsg(null); setErrors(null);
        // Client-side validation
  const phoneRe = /^\d+$/;
        const idRe = /^\d+$/;
        const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!phoneRe.test(form.phone)) { setErrors('Phone must contain digits only'); return; }
  if (form.phone.length !== 10) { setErrors('Phone must be exactly 10 digits'); return; }
        if (!idRe.test(form.id_number)) { setErrors('ID Number must contain digits only'); return; }
        if (!emailRe.test(form.email)) { setErrors('Email is not valid'); return; }
        try{const r=await apiClient.post("/guests/",form); setMsg("Created ID: "+r.data.guest_id);}catch(err:any){setMsg(err?.response?.data?.detail||"Failed");}
      }}>
        <label>First Name</label><input value={form.first_name} onChange={e=>setForm({...form,first_name:e.target.value})} required />
        <label>Last Name</label><input value={form.last_name} onChange={e=>setForm({...form,last_name:e.target.value})} required />
        <label>Phone</label>
        <input
          value={formatPhone(form.phone)}
          onChange={e=>{
            const raw = e.target.value.replace(/\D/g,'');
            if (raw.length > 10) {
              // keep the stored value to 10 digits but notify the user
              setForm({...form, phone: raw.slice(0,10)});
              showTemporaryError('Phone must be exactly 10 digits');
            } else {
              setForm({...form, phone: raw});
            }
          }}
          inputMode="numeric" required
        />
        <label>Email</label><input value={form.email} onChange={e=>setForm({...form,email:e.target.value})} type="email" required />
        <label>ID Number</label>
        <input
          value={form.id_number}
          onChange={e=>setForm({...form,id_number:e.target.value.replace(/[^0-9]/g,'')})}
          inputMode="numeric"
          required
        />
        <button type="submit">Create</button>
      </form>
      
      <form onSubmit={async(e)=>{e.preventDefault(); setMsg(null); try{const r=await apiClient.get(`/guests/${id}`); setData(r.data);}catch(err:any){setMsg(err?.response?.data?.detail||"Not found");}}}>
        <label>Guest ID</label><input value={id} onChange={e=>setId(e.target.value)} />
        <button type="submit">Fetch</button>
      </form>
      {msg && <p>{msg}</p>}
      {data && <pre>{JSON.stringify(data,null,2)}</pre>}
    </div>
  );
}
