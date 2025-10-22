"use client";
import { useState, useEffect } from "react";
import apiClient from "@/lib/apiClient";

interface Guest {
  guestID: number;
  name: string;
  phone: string;
  email: string;
}

interface Branch {
  branchID: number;
  location: string;
}

interface Room {
  roomID: number;
  roomNo: string;
  typeName: string;
  capacity: number;
}

export default function Reservations(){
  const [f,setF]=useState({guest_id:"",branch_id:"",room_id:"",check_in_date:"",check_out_date:"",num_guests:""});
  const [msg,setMsg]=useState<string|null>(null);
  const [id,setId]=useState("");
  
  // Data for dropdowns
  const [guests, setGuests] = useState<Guest[]>([]);
  const [branches, setBranches] = useState<Branch[]>([]);
  const [rooms, setRooms] = useState<Room[]>([]);
  const [loading, setLoading] = useState(false);

  // Fetch dropdown data
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const [guestsRes, branchesRes] = await Promise.all([
          apiClient.get("/guests/"),
          apiClient.get("/branches/")
        ]);
        setGuests(guestsRes.data || []);
        setBranches(branchesRes.data || []);
      } catch (error) {
        setMsg("Error loading data. Please refresh.");
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  // Fetch available rooms when branch and dates change
  useEffect(() => {
    const fetchRooms = async () => {
      if (f.branch_id && f.check_in_date && f.check_out_date) {
        try {
          const res = await apiClient.get("/rooms/available", {
            params: {
              branch_id: f.branch_id,
              check_in: f.check_in_date,
              check_out: f.check_out_date
            }
          });
          setRooms(res.data || []);
        } catch (error) {
          setMsg("Error loading rooms");
        }
      }
    };
    fetchRooms();
  }, [f.branch_id, f.check_in_date, f.check_out_date]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMsg(null);

    // Validate dates
    if (f.check_in_date && f.check_out_date) {
      const checkIn = new Date(f.check_in_date);
      const checkOut = new Date(f.check_out_date);
      if (checkOut <= checkIn) {
        setMsg("Check-out date must be after check-in date");
        return;
      }
    }

    try {
      const r = await apiClient.post("/reservations/", {
        ...f,
        guest_id: +f.guest_id,
        branch_id: +f.branch_id,
        room_id: +f.room_id,
        num_guests: +f.num_guests
      });
      setMsg("Created booking: " + r.data.booking_id);
    } catch (err: any) {
      setMsg(err?.response?.data?.detail || "Failed");
    }
  };

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-6">Reservations</h1>
      
      <form onSubmit={handleSubmit} className="bg-white p-6 rounded-lg shadow-md mb-8 grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label className="block text-gray-700 text-sm font-bold mb-2">Guest</label>
          <select 
            className="w-full p-2 border rounded-md" 
            value={f.guest_id}
            onChange={e => setF({...f, guest_id: e.target.value})}
            required
          >
            <option value="">-- Select guest --</option>
            {guests.map(g => (
              <option key={g.guestID} value={g.guestID}>
                {g.name} ({g.phone})
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-gray-700 text-sm font-bold mb-2">Branch</label>
          <select 
            className="w-full p-2 border rounded-md"
            value={f.branch_id}
            onChange={e => setF({...f, branch_id: e.target.value})}
            required
          >
            <option value="">-- Select branch --</option>
            {branches.map(b => (
              <option key={b.branchID} value={b.branchID}>{b.location}</option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-gray-700 text-sm font-bold mb-2">Check in</label>
          <input 
            type="date"
            className="w-full p-2 border rounded-md"
            value={f.check_in_date}
            onChange={e => setF({...f, check_in_date: e.target.value})}
            required
          />
        </div>

        <div>
          <label className="block text-gray-700 text-sm font-bold mb-2">Check out</label>
          <input 
            type="date"
            className="w-full p-2 border rounded-md"
            value={f.check_out_date}
            onChange={e => setF({...f, check_out_date: e.target.value})}
            required
          />
        </div>

        <div>
          <label className="block text-gray-700 text-sm font-bold mb-2">Room</label>
          <select 
            className="w-full p-2 border rounded-md"
            value={f.room_id}
            onChange={e => setF({...f, room_id: e.target.value})}
            required
          >
            <option value="">-- Select room --</option>
            {rooms.map(r => (
              <option key={r.roomID} value={r.roomID}>
                Room {r.roomNo} ({r.typeName}, Capacity: {r.capacity})
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-gray-700 text-sm font-bold mb-2">Number of Guests</label>
          <input 
            type="number"
            className="w-full p-2 border rounded-md"
            value={f.num_guests}
            onChange={e => setF({...f, num_guests: e.target.value})}
            min="1"
            required
          />
        </div>

        <div className="md:col-span-2">
          <button 
            className="w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            type="submit"
            disabled={loading}
          >
            {loading ? "Loading..." : "Create Reservation"}
          </button>
        </div>
      </form>

      <div className="bg-white p-6 rounded-lg shadow-md">
        <h2 className="text-xl font-semibold mb-4">Check-in / Check-out</h2>
        <div className="flex gap-4 items-end">
          <div className="flex-1">
            <label className="block text-gray-700 text-sm font-bold mb-2">Booking ID</label>
            <input 
              className="w-full p-2 border rounded-md"
              value={id} 
              onChange={e=>setId(e.target.value)}
              placeholder="Enter booking ID"
            />
          </div>
          <button 
            className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
            onClick={async()=>{ 
              setMsg(null); 
              try{
                await apiClient.post(`/reservations/${id}/checkin`); 
                setMsg("Check-in successful");
              }catch(err:any){
                setMsg(err?.response?.data?.detail||"Failed");
              }
            }}
          >
            Check-in
          </button>
          <button 
            className="bg-orange-500 hover:bg-orange-700 text-white font-bold py-2 px-4 rounded"
            onClick={async()=>{ 
              setMsg(null); 
              try{
                await apiClient.post(`/reservations/${id}/checkout`); 
                setMsg("Check-out successful");
              }catch(err:any){
                setMsg(err?.response?.data?.detail||"Failed");
              }
            }}
          >
            Check-out
          </button>
        </div>
      </div>

      {msg && (
        <div className={`mt-4 p-3 rounded ${
          msg.includes("successful") ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"
        }`}>
          {msg}
        </div>
      )}
    </div>
  );
}
