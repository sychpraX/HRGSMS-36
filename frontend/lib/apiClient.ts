import axios from "axios";
// Prefer environment variable when available (works with Docker Compose)
const BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || "http://127.0.0.1:8000";
const apiClient = axios.create({ baseURL: BASE_URL, headers: { "Content-Type": "application/json" } });
apiClient.interceptors.request.use((config) => { if (typeof window !== "undefined") { const t = localStorage.getItem("token"); if (t) config.headers.Authorization = `Bearer ${t}`; } return config; });
export default apiClient;
