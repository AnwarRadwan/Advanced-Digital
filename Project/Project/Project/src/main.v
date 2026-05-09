module unsignedm(A, B, GT, EQ, LW);
    
	input [5:0] A;
    input [5:0] B;
    output GT, EQ, LW;

    wire [5:0] G, L, E;
    wire [5:0] GG, LL;
	wire [5:0] notB;
	wire [5:0] notA;

    // Greater Than Logic
	genvar i;
	generate
	for(i=0;i<6;i=i+1)
		begin
			not #(4ns)(notB[i],B[i]);
			and #(7ns)(G[i], A[i], notB[i]);
		end
		endgenerate
		
    
    // Less Than Logic
	generate
	for(i=0;i<6;i=i+1)
		begin
			not #(4ns)(notA[i],A[i]);
			and #(7ns)(L[i], notA[i], B[i]);
		end
		endgenerate
   					 
    // Equal Logic
	generate
	for(i=0;i<6;i=i+1)
		begin
			xnor #(9ns)(E[i], A[i], B[i]);
		end
		endgenerate
  

    // EQ Output
    and #(7ns)(EQ, E[5], E[4], E[3], E[2], E[1], E[0]);

    // Cascading Greater Than Logic
    and #(7ns)(GG[0], E[5], E[4], E[3], E[2], E[1], G[0]);
    and #(7ns)(GG[1], E[5], E[4], E[3], E[2], G[1]);
    and #(7ns)(GG[2], E[5], E[4], E[3], G[2]);
    and #(7ns)(GG[3], E[5], E[4], G[3]);
    and #(7ns)(GG[4], E[5], G[4]);

    or #(7ns)(GT, G[5], GG[0], GG[1], GG[2], GG[3], GG[4]);

    // Cascading Less Than Logic
    and #(7ns)(LL[0], E[5], E[4], E[3], E[2], E[1], L[0]);
    and #(7ns)(LL[1], E[5], E[4], E[3], E[2], L[1]);
    and #(7ns)(LL[2], E[5], E[4], E[3], L[2]);
    and #(7ns)(LL[3], E[5], E[4], L[3]);
    and #(7ns)(LL[4], E[5], L[4]);

    or #(7ns)(LW, L[5], LL[0], LL[1], LL[2], LL[3], LL[4]);
endmodule

module signedm(A, B, GT, EQ, LW);
    input [5:0] A, B;
    output GT, EQ, LW;
	
	wire notA,notB,notEQ;
    wire [2:0]G; 
    wire notG_un, G_un,L_un;
   

    // Sign comparison logic
	not #(4ns)(notA,A[5]);
	not #(4ns)(notB,B[5]);
    and #(7ns)(G[0], notA, B[5]);

    // Instantiate unsigned comparator
    unsignedm u1(.A(A), .B(B), .GT(G_un), .EQ(EQ), .LW(L_un));

    // Combine results for signed logic
		
		and #(7ns)(G[1],notA,notB,G_un);
		not #(4ns)(notG_un,G_un);
		and #(7ns)(G[2],A[5],B[5],G_un);
		or  #(7ns)(GT,G[2],G[1],G[0]);
		nor #(5ns)(LW,EQ,GT);
		
    
endmodule

module mux2X1(A,B,S,OUT);
	input A,B,S;
	wire notS,Aw,Bw;
	output OUT;
	
	not #(4ns)(notS,S);
	and #(7ns)(Aw,A,notS);
	and #(7ns)(Bw,B,S);
	or  #(7ns)(OUT,Aw,Bw);
	
endmodule

module structural(A,B,S,CLK,GT,EQ,LW);
	
	input [5:0]A,B;
	input S,CLK	;
	output reg GT,EQ,LW;
	
	wire unGT,unLW,unEQ;
	wire sGT,sLW,sEQ;
	wire finalGT,finalLW,finalEQ;
	
	unsignedm num1(A,B,unGT,unEQ,unLW);
	signedm	  num2(A,B,sGT,sEQ,sLW);
	
	mux2X1 mux1(unGT,sGT,S,finalGT);
	mux2X1 mux2(unEQ,sEQ,S,finalEQ);
	mux2X1 mux3(unLW,sLW,S,finalLW); 
	
	always @(posedge CLK) 
		begin
			GT <= finalGT;
			EQ <= finalEQ;
			LW <= finalLW;
		end
	
endmodule

module behavioral (A, B, S, CLK, GT, EQ, LW);
	input [5:0] A;       // First number (6-bit)
    input [5:0] B;       // Second number (6-bit)
    input S;             // Selection bit (0: Unsigned, 1: Signed)
    input CLK;           // Clock signal
    output reg GT;       // Output: Greater
    output reg EQ;       // Output: Equal
    output reg LW;
    reg unEQ, unGT, unLW; // Unsigned comparison results
    reg sEQ, sGT, sLW;    // Signed comparison results

    always @(posedge CLK) begin
        // Unsigned comparison
        if (A > B)
			begin
				unEQ = 0; unGT = 1; unLW = 0;
            end 
		else if (A < B) 
			begin   
				unEQ = 0; unGT = 0; unLW = 1;
            end
		else
			begin
				unEQ = 1; unGT = 0; unLW = 0;
            end

        // Signed comparison (2's complement)
        if (A[5] == 1 && B[5] == 0)
			begin
				sEQ = 0; sGT = 0; sLW = 1; // A is negative, B is positive
			end
		else if (A[5] == 0 && B[5] == 1)
			begin
				sEQ = 0; sGT = 1; sLW = 0; // A is positive, B is negative
			end 
		else 
			begin
            // Both numbers have the same sign, compare as unsigned
            if (A > B)
				begin
					sEQ = 0; sGT = 1; sLW = 0;
				end 
			else if (A < B)
				begin
					sEQ = 0; sGT = 0; sLW = 1;
				end
			else
				begin
					sEQ = 1; sGT = 0; sLW = 0;
				end
			end	
		

        // Select between signed and unsigned results
        if (S)
			begin
				GT <= sGT;
                EQ <= sEQ;
                LW <= sLW;
			end 
		else
			begin
                GT <= unGT;
                EQ <= unEQ;
                LW <= unLW;
			end
		end

endmodule



	
module test();
    reg [5:0] A, B;      // 6-bit inputs A and B
    reg S, CLK;          // Selection signal and clock
    wire GT, EQ, LW;     // Outputs from behavioral
    wire sGT, sEQ, sLW;  // Outputs from structural

    // Instantiate the behavioral comparator module
    behavioral uu(A, B, S, CLK, GT, EQ, LW);
    structural u1(A, B, S, CLK, sGT, sEQ, sLW);

    // Clock generation
    initial CLK = 0;
    always #50 CLK = ~CLK; // Clock toggles every 5 time units

    // Monitor outputs
   

    initial begin
        {S, A, B} = 0; // Initialize inputs
        repeat (8191) begin
            #97ns {S, A, B} = {S, A, B} + 1; // Increment inputs
            if (GT != sGT || EQ != sEQ || LW != sLW)
				begin
					$display("FAIL");
					$stop; // Stop simulation if outputs mismatch
				end
			else
				if(S)
					begin
						$monitor("%0d signed :\nA = %d\t A = %b \t B = %d\t B = %b\t S = %b\t \nbGT = %b bEQ = %b bLW = %b \nsGT = %b sEQ = %b sLW = %b",
                 $time, $signed(A), A, $signed(B), B, S, GT, EQ, LW, sGT, sEQ, sLW);
					end
				else if(~S)
					begin
						$monitor("%0d unsigned :\nA = %d\t A = %b \t B = %d\t B = %b\t S = %b\t \nbGT = %b bEQ = %b bLW = %b \nsGT = %b sEQ = %b sLW = %b",
                 $time, (A), A, (B), B, S, GT, EQ, LW, sGT, sEQ, sLW);
					end
					
		
				$display("**********PASS***********");
				
        end
        $finish;
    end
endmodule