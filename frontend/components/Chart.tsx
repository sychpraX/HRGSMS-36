"use client";
import { Bar, Line, Pie } from "react-chartjs-2";
import { Chart, CategoryScale, LinearScale, BarElement, PointElement, LineElement, ArcElement, Tooltip, Legend } from "chart.js";
Chart.register(CategoryScale, LinearScale, BarElement, PointElement, LineElement, ArcElement, Tooltip, Legend);

type Props = { type: "bar"|"line"|"pie"; labels: string[]; datasets: {label:string; data:number[]}[]; };

export default function ChartBox({ type, labels, datasets }: Props){
  // Green/teal palette (high contrast on dark bg)
  const border = ["#22c55e", "#10b981", "#2dd4bf", "#84cc16", "#06b6d4"];
  const fill   = ["rgba(34,197,94,0.35)", "rgba(16,185,129,0.35)", "rgba(45,212,191,0.35)", "rgba(132,204,22,0.35)", "rgba(6,182,212,0.35)"];

  // Style datasets
  const styled = datasets.map((ds, i) => ({
    ...ds,
    borderColor: border[i % border.length],
    backgroundColor: type === "line" ? fill[i % fill.length] : fill[i % fill.length],
    borderWidth: 2,
    pointBackgroundColor: border[i % border.length],
    pointBorderColor: "#0b1220",
  }));

  const data = { labels, datasets: styled as any };

  const options: any = {
    responsive: true,
    plugins: { legend: { labels: { color: "#e5e7eb" } } },
    scales: type === "pie" ? undefined : {
      x: { ticks: { color: "#e5e7eb" }, grid: { color: "rgba(148,163,184,0.15)" } },
      y: { ticks: { color: "#e5e7eb" }, grid: { color: "rgba(148,163,184,0.15)" } }
    }
  };

  // For pie charts, give each slice its own green/teal color
  const pieData = {
    labels,
    datasets: datasets.map((ds) => ({
      label: ds.label,
      data: ds.data,
      backgroundColor: labels.map((_, i) => fill[i % fill.length]),
      borderColor: labels.map((_, i) => border[i % border.length]),
      borderWidth: 2
    }))
  };

  return (
    <div className="card">
      {type==="bar"  && <Bar  data={data}    options={options} />}
      {type==="line" && <Line data={data}    options={options} />}
      {type==="pie"  && <Pie  data={pieData} options={options} />}
    </div>
  );
}
