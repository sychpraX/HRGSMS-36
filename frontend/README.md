# HRGSMS Frontend (Styled + Charts)
Upgraded, well‑styled Next.js (TypeScript) frontend with an eye‑catching dashboard and charts for reports.

## Install & Run
```bash
npm install
npm run dev
```
Open http://localhost:3000

## Notes
- Backend URL: `http://127.0.0.1:8000` (change in `lib/apiClient.ts` if needed)
- Charts: `chart.js` + `react-chartjs-2`
- Dashboard pulls:
  - Revenue (last 7 days, branch 1)
  - Occupancy pie (available vs unavailable)
  - Top Service rows
