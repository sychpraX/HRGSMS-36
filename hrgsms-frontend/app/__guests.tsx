"use client";
import { useState } from "react";
import apiClient from "@/lib/apiClient";

export default function Guests(){
  const [id,setId]=useState(""); const [data,setData]=useState<any>(null); const [msg,setMsg]=useState<string|null>(null);
  const [form,setForm]=useState({first_name:"",last_name:"",phone:"",email:"",id_number:""});
  return (
    <div>
      <h1>Guests</h1>
      <form onSubmit={async(e)=>{e.preventDefault(); setMsg(null); try{const r=await apiClient.post("/guests/",form); setMsg("Created ID: "+r.data.guest_id);}catch(err:any){setMsg(err?.response?.data?.detail||"Failed");}}}>
        <label>First Name</label><input value={form.first_name} onChange={e=>setForm({...form,first_name:e.target.value})}/>
        <label>Last Name</label><input value={form.last_name} onChange={e=>setForm({...form,last_name:e.target.value})}/>
        <label>Phone</label><input value={form.phone} onChange={e=>setForm({...form,phone:e.target.value})}/>
        <label>Email</label><input value={form.email} onChange={e=>setForm({...form,email:e.target.value})}/>
        <label>ID Number</label><input value={form.id_number} onChange={e=>setForm({...form,id_number:e.target.value})}/>
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
