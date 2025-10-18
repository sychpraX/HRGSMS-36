export const saveToken=(t:string)=>localStorage.setItem("token",t);
export const getToken=()=>localStorage.getItem("token");
export const clearToken=()=>{localStorage.removeItem("token"); localStorage.removeItem("role");};
export const isLoggedIn=()=>!!localStorage.getItem("token");
export const getRole=()=>localStorage.getItem("role");
export const saveRole=(r:string)=>localStorage.setItem("role",r);
