module regFile32x32(input write1, write2, input[31:0] writeData1, writeData2, 
		input [4:0] writeIndex1, writeIndex2, readIndex, input clear, clock, output[31:0] readValue);
	reg[31:0] data[31:0];
	reg[31:0] i;
	
	always @(negedge clock, posedge clear) begin
		if(clear)
			for(i = 0; i < 32; i = i + 1)
				data[i] = 0;
		else begin 
			if(writeIndex1 == writeIndex2 && write1 && write2)
				data[writeIndex1] = writeData1;
			else begin
				data[writeIndex1] = write1 ? writeData1 : data[writeIndex1];
				data[writeIndex2] = write2 ? writeData2 : data[writeIndex2];
			end
		end
	end
	
	assign readValue = data[readIndex];
endmodule

module testRegFile();
	reg write1, write2;
	reg[31:0] writeData1, writeData2;
	reg[4:0] writeIndex1, writeIndex2, readIndex;
	reg clear, clock;
	wire[31:0] readValue;
	
	regFile32x32 regFile(write1, write2, writeData1, writeData2, 
		writeIndex1, writeIndex2, readIndex, clear, clock, readValue);

	initial begin
		$monitor("%d    write1 = %b, writeIndex1 = %d, writeData1 = %d,\n",
			$time, write1, writeIndex1, writeData1,
			"\t\t\twrite2 = %d, writeIndex2 = %d, writeData2 = %d,\n",
			write2, writeIndex2, writeData2,
			"\t\t\tclock = %b, clear = %b,\n",
			clock, clear,
			"\t\t\treadIndex = %d, readValue = %d",
			readIndex, readValue, "\n");
		
		#10 write1 = 1; writeIndex1 = 0; writeData1 = 243;
			write2 = 1; writeIndex2 = 1; writeData2 = 71;
			clock = 1; clear = 0; readIndex = 0;
			
		#10 write1 = 1; writeIndex1 = 0; writeData1 = 243;
			write2 = 1; writeIndex2 = 1; writeData2 = 71;
			clock = 0; clear = 0; readIndex = 0;
			
		#10 write1 = 1; writeIndex1 = 2; writeData1 = 741;
			write2 = 1; writeIndex2 = 2; writeData2 = 12;
			clock = 1; clear = 0; readIndex = 1;
			
		#10 write1 = 1; writeIndex1 = 2; writeData1 = 741;
			write2 = 1; writeIndex2 = 2; writeData2 = 12;
			clock = 0; clear = 0; readIndex = 2;
			
		#10 write1 = 0; writeIndex1 = 0; writeData1 = 0;
			write2 = 0; writeIndex2 = 0; writeData2 = 0;
			clock = 1; clear = 1; readIndex = 1;
			
		#10 write1 = 0; writeIndex1 = 0; writeData1 = 0;
			write2 = 0; writeIndex2 = 0; writeData2 = 0;
			clock = 0; clear = 0; readIndex = 2;
		$finish;
	end
endmodule