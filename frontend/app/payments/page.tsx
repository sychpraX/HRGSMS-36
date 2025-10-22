"use client";
import { useState } from "react";
import Protected from "@/components/Protected";
import apiClient from "@/lib/apiClient";

export default function PaymentsPage() {
  const [invoiceForm, setInvoiceForm] = useState({ booking_id:"", policy_id:"", discount_code:"", late_policy_id:"" });
  const [paymentForm, setPaymentForm] = useState({ invoice_id:"", amount:"", payment_method:"Cash" });
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const createInvoice = async (e: React.FormEvent) => {
    e.preventDefault(); setError(null); setMessage(null);
    try {
      const body:any = { booking_id:Number(invoiceForm.booking_id) };
      if (invoiceForm.policy_id) body.policy_id = Number(invoiceForm.policy_id);
      if (invoiceForm.discount_code) body.discount_code = Number(invoiceForm.discount_code);
      if (invoiceForm.late_policy_id) body.late_policy_id = Number(invoiceForm.late_policy_id);
      const res = await apiClient.post("/payments/invoices", body);
      setMessage(`Invoice created. ID: ${res.data.invoice_id}`);
    } catch (err: any) { setError(err?.response?.data?.detail || "Failed to create invoice"); }
  };

  const addPayment = async (e: React.FormEvent) => {
    e.preventDefault(); setError(null); setMessage(null);
    try {
      const body = { invoice_id:Number(paymentForm.invoice_id), amount:Number(paymentForm.amount), payment_method:paymentForm.payment_method };
      const res = await apiClient.post("/payments/", body);
      setMessage(`Payment added. Tx ID: ${res.data.transaction_id}`);
    } catch (err: any) { setError(err?.response?.data?.detail || "Failed to add payment"); }
  };

  return (
    <Protected>
      <h1>Payments</h1>
      <div className="grid cols-2">
        <form onSubmit={createInvoice}>
          <h3>Create Invoice</h3>
          <label>Booking ID</label><input value={invoiceForm.booking_id} onChange={(e)=>setInvoiceForm({...invoiceForm, booking_id:e.target.value})} required />
          <label>Policy ID (optional)</label><input value={invoiceForm.policy_id} onChange={(e)=>setInvoiceForm({...invoiceForm, policy_id:e.target.value})} />
          <label>Discount Code (optional)</label><input value={invoiceForm.discount_code} onChange={(e)=>setInvoiceForm({...invoiceForm, discount_code:e.target.value})} />
          <label>Late Policy ID (optional)</label><input value={invoiceForm.late_policy_id} onChange={(e)=>setInvoiceForm({...invoiceForm, late_policy_id:e.target.value})} />
          <button type="submit">Create Invoice</button>
        </form>

        <form onSubmit={addPayment}>
          <h3>Add Payment</h3>
          <label>Invoice ID</label><input value={paymentForm.invoice_id} onChange={(e)=>setPaymentForm({...paymentForm, invoice_id:e.target.value})} required />
          <label>Amount</label><input type="number" step="0.01" value={paymentForm.amount} onChange={(e)=>setPaymentForm({...paymentForm, amount:e.target.value})} required />
          <label>Method</label>
          <select value={paymentForm.payment_method} onChange={(e)=>setPaymentForm({...paymentForm, payment_method:e.target.value})}>
            <option>Cash</option><option>Card</option><option>Online</option><option>Other</option>
          </select>
          <button type="submit">Add Payment</button>
        </form>
      </div>
      {message && <p className="success">{message}</p>}
      {error && <p className="error">{error}</p>}
    </Protected>
  );
}
