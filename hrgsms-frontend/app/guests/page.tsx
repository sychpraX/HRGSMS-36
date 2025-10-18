"use client";
import Protected from "@/components/Protected";
import Guests from "../__guests";

export default function Page(){
  return <Protected><Guests/></Protected>;
}
