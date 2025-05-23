// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2022 by Arkadiusz Kozdra.
// SPDX-License-Identifier: CC0-1.0

// See also t_interface_virtual_bad.v

interface PBus;
   logic req, grant;
   logic [7:0] addr, data;
   modport phy(input addr, ref data);
endinterface

typedef virtual PBus vpbus_t;
typedef vpbus_t vpbus2_t;

class Cls;
   vpbus2_t fa, fb;
endclass

class Clsgen#(type T = logic);
   T x[0:3];
endclass

module t (/*AUTOARG*/);

   PBus ia(), ib();
   virtual PBus va, vb;
   virtual PBus.phy pa, pb;
   Cls ca, cb;
   Clsgen#(virtual PBus) gen;

   initial begin
      if (va != null) $stop;
      va = null;
      if (va != null) $stop;
      va = ia;
      if (va == null) $stop;
      va = null;
      if (va != null) $stop;
      va = ia;
      if (va == null) $stop;

      vb = ia;

      $display("va==vb? %b", va==vb);
      $display("va!=vb? %b", va!=vb);
      vb = ib;
      $display("va==vb? %b", va==vb);
      $display("va!=vb? %b", va!=vb);

      ca = new;
      cb = new;
      gen = new;

      va.addr = 8'haa;
      ia.data = 8'h11;

      vb.addr = 8'hbb;
      ib.data = 8'h22;

      $display("va.addr=%x", va.addr, " va.data=%x", va.data, " ia.addr=%x", ia.addr, " ia.data=%x", ia.data);
      $display("vb.addr=%x", vb.addr, " vb.data=%x", vb.data, " ib.addr=%x", ib.addr, " ib.data=%x", ib.data);

      if (ca.fa) $stop;

      ca.fa = ia;
      ca.fb = ib;
      cb.fa = ib;
      cb.fb = ia;
      gen.x[0] = va;
      gen.x[1] = vb;

      if (ca == null) $stop;
      if (ca.fa == null) $stop;
      if (!ca.fa ) $stop;

      pa = va;
      pb = vb;

      pb.addr = 8'hb0;
      pa.addr = 8'ha0;

      $display("ca.fa.addr=%x", ca.fa.addr, " ca.fa.data=%x", ca.fa.data, " ca.fa.addr=%x", ca.fb.addr, " ca.fb.data=%x", ca.fb.data);
      $display("cb.fa.addr=%x", cb.fa.addr, " cb.fa.data=%x", cb.fa.data, " cb.fa.addr=%x", cb.fb.addr, " cb.fb.data=%x", cb.fb.data);
      $display("gen.x[0].addr=%x", gen.x[0].addr, " gen.x[1].addr=%x", gen.x[1].addr);
      $display("gen=%p", gen);

      $write("*-* All Finished *-*\n");
      $finish;
   end
endmodule
