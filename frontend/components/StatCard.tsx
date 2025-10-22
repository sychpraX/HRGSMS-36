export default function StatCard({ title, value, delta }:{title:string; value:string|number; delta?:string;}){
  return (<div className="stat"><h3>{title}</h3><div className="value">{value}</div>{delta && <div className="delta">{delta}</div>}</div>);
}
