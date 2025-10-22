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
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-6">Available Rooms</h1>
      
      <form onSubmit={onSubmit} className="bg-white p-6 rounded-lg shadow-md mb-8 grid grid-cols-1 md:grid-cols-4 gap-4">
        <div>
          <label className="block text-gray-700 text-sm font-bold mb-2">Branch</label>
          <select 
            className="w-full p-2 border rounded-md" 
            value={branch_id} 
            onChange={e=>setBranch(e.target.value)}
            required
          >
            <option value="">-- Select branch --</option>
            {branches.map(b=> <option key={b.branchID} value={String(b.branchID)}>{b.location}</option>)}
          </select>
        </div>

        <div>
          <label className="block text-gray-700 text-sm font-bold mb-2">Check in</label>
          <input 
            type="datetime-local" 
            className="w-full p-2 border rounded-md"
            value={check_in} 
            onChange={e=>setIn(e.target.value)}
            required 
          />
        </div>

        <div>
          <label className="block text-gray-700 text-sm font-bold mb-2">Check out</label>
          <input 
            type="datetime-local" 
            className="w-full p-2 border rounded-md"
            value={check_out} 
            onChange={e=>setOut(e.target.value)}
            required 
          />
        </div>

        <div className="flex items-end">
          <button 
            className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded w-full"
            type="submit"
          >
            Search
          </button>
        </div>
      </form>

      {msg && <p className="text-red-500 mb-4">{msg}</p>}

      {rows.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {rows.map((room) => (
            <div key={room.roomID} className="bg-white border rounded-md p-4">
              <div className="flex justify-between items-start mb-3">
                <div>
                  <h3 className="text-lg font-semibold">Room {room.roomNo}</h3>
                  <p className="text-sm text-gray-600">{room.typeName}</p>
                </div>
                <span className={`text-sm px-2 py-1 rounded ${
                  room.roomStatus === 'Available' 
                    ? 'bg-green-100 text-green-700' 
                    : 'bg-yellow-100 text-yellow-700'
                }`}>
                  {room.roomStatus}
                </span>
              </div>

              <table className="w-full text-sm">
                <tbody>
                  <tr className="border-t">
                    <td className="py-2 text-gray-600">Capacity:</td>
                    <td className="py-2 text-right">{room.capacity} persons</td>
                  </tr>
                  <tr className="border-t">
                    <td className="py-2 text-gray-600">Rate:</td>
                    <td className="py-2 text-right font-medium">Rs. {room.currRate.toLocaleString()}</td>
                  </tr>
                  <tr className="border-t">
                    <td className="py-2 text-gray-600">Location:</td>
                    <td className="py-2 text-right">{room.location}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          ))}
        </div>
      ) : (
        <div className="text-center text-gray-500 mt-8">
          {branch_id && check_in && check_out ? 
            "No rooms available for the selected criteria" : 
            "Select branch and dates to see available rooms"}
        </div>
      )}
    </div>
  );
}
