class E2E_scb;
   rand logic [4:0] addr;
  rand logic [31:0] data;
  E2E_scb qu[$];

  task pkt_gen(int configg,int n);
    int seed=1234;
    case(configg)
      1: begin
        repeat(n) begin
          E2E_scb pkt = new();
          pkt.addr = $random(seed);
          seed=seed+5;

          pkt.data = $random;
          qu.push_back(pkt);

          //$display("class addr = %h, data=%d ", pkt.addr, pkt.data);
        end
      end
      2: begin
        repeat(configg) begin
          E2E_scb pkt = new();
          pkt.randomize();
          qu.push_back(pkt);
         // $display("class addrrrrrrrrr = %h, data=%d ", pkt.addr, pkt.data);
        end
        repeat(n-configg) begin
          E2E_scb pkt = new();
          pkt.addr = $random(seed);
          seed=seed+7;
          pkt.data = $random;
          qu.push_back(pkt);
         // $display("class addr = %h, data=%d ", pkt.addr, pkt.data);
        end
      end
      3: begin
        repeat(n) begin
          E2E_scb pkt = new();
          pkt.randomize();
          qu.push_back(pkt);
          //$display("class addr = %h, data=%d ", pkt.addr, pkt.data);
        end
      end
    endcase
  endtask
endclass

typedef enum int{
	  ALL_SAME = 1,
	  TWO_DIFF_REST_SAME = 2,
	  ALL_DIFF =3
}gen_case;

module test;
  logic [31:0] bfm1 [logic [4:0]];
  logic [31:0] bfm2 [logic [4:0]];
  logic [31:0] memtable [logic [4:0]] [2]; // 5-bit index and 2 elements of 32 bits each per index
  gen_case mode;
  int n;
    initial begin
      E2E_scb pkt1 = new();
      E2E_scb pkt2 = new();
      mode = ALL_SAME;
      if(!$value$plusargs("n=%d",n))begin
	     $display("no value passed default n value");
	     n=1;
     end
      pkt1.pkt_gen(mode, n);
      pkt2.pkt_gen(mode,n);

      foreach(pkt1.qu[i])begin
     // $display("qu1 addr = %h, qu data=%d ", pkt1.qu[i].addr, pkt1.qu[i].data);
      bfm1[pkt1.qu[i].addr] = pkt1.qu[i].data;
    end
    foreach(pkt2.qu[i])begin
     // $display("qu2 addr = %h, qu data=%d ", pkt2.qu[i].addr, pkt2.qu[i].data);
      bfm2[pkt2.qu[i].addr] = pkt2.qu[i].data;
    end


    /*foreach (bfm1[addr_key]) begin
      $display("BFM 1------  addr = %h, data = %d", addr_key, bfm1[addr_key]);
    end

    foreach (bfm2[addr_key]) begin
      $display("BFM 2 -----addr = %h, data = %d", addr_key, bfm2[addr_key]);
    end*/
      
      foreach(bfm1[addr1_key])begin
        if(bfm2.exists(addr1_key)) begin
          memtable[addr1_key] [0]= bfm1[addr1_key];
          memtable[addr1_key] [1]=bfm2[addr1_key];
          end
        else begin
         memtable[addr1_key] [0]= bfm1[addr1_key];
        memtable[addr1_key] [1]=32'b0;
      end
      end
      foreach(bfm2[addr2_key]) begin
        if(!bfm1.exists(addr2_key)) begin
          memtable[addr2_key] [0]= 32'b0;
          memtable[addr2_key] [1]=bfm2[addr2_key];
        end
      end
      $display("------------MEMORY TABLE-------------");
      $display("ADDRESS  |    BFM1 DATA    |   BFM2 DATA   ");  
      $display("___________________________________________\n");
      foreach (memtable[addr_key]) begin
        $display("%h       | %d      | %d", addr_key, memtable[addr_key][0], memtable[addr_key][1]);
    end
  end
endmodule
