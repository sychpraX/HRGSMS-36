import axios from "axios";
const apiClient = axios.create({ baseURL: "http://127.0.0.1:8000", headers: { "Content-Type": "application/json" } });
apiClient.interceptors.request.use((config) => { if (typeof window !== "undefined") { const t = localStorage.getItem("token"); if (t) config.headers.Authorization = `Bearer ${t}`; } return config; });
export default apiClient;
