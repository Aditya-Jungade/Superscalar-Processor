

For Refrence :
----------------

	Main Features :
		A. 2-way fetch superscalar processor
		B. 16-bit
		C. 8 registers (R0 - R7)
		D. Stages : 
			1. Instruction Fetch
			2. Instruction Decode
			3. Dispatch
			4. Reservayion Station
			5. Execute
			6. Completion Stage
			7. Write Back into storage buffer
		E. Optimized Performance
		F. Hazard Mitigation Techniques
		G. Branch Prediction

	Detailed Description :
		
		R7 always stores PC.
		All addresses are short word address 
			(Addr = 0 -> first 2 bytes, 
			 Addr = 1 -> second 2 bytes).
		Has Carry(C) and Zero(Z) flags.
		Three machine code instruction formats.
			
		1. R - Register - Register type
			-----------------------------------------
		 	Opcode	R_A  R_B  R_B   Unused	Condn(CZ)
			  4	 3    3    3	   1	   2	
			-----------------------------------------
		2. I - Immidiate type
			-----------------------------------------
			Opcode	R_A  R_C	Immediate
			  4	 3    3		   6
			-----------------------------------------
		3. J - Jump type
			-----------------------------------------
			Opcode	R_A		Immediate
			  4	 3		   9
			-----------------------------------------
	Instructions Encoding :
	
	1. ADD	00_01	RA	RB	RC	0	00
	2. ADC	00_01	RA	RB	RC	0	10
	3. ADZ	00_01	RA	RB	RC	0	01
	4. ADL  00_01	RA	RB	RC	0	11

	5. ADI	00_00	RA	RB	  6-bit Immidiate

	6. NDU	00_10	RA	RB	RC	0	00
	7. NDC	00_10	RA	RB	RC	0	10
	8. NDZ	00_10	RA	RB	RC	0	01

	9. LHI	00_11	RA	      9-bit Immidiate

	10. LW	01_00	RA	RB	  6-bit Immidiate
	11. SW	01_01	RA	RB	  6-bit Immidiate

	12. LM	11_00	RA      0+8bit(corresponds to R0-R7)
	13. SM	11_01	RA      0+8bit(corresponds to R0-R7)

	14. LA	11_10	RA		0_0000_0000
	15. SA	11_11	RA		0_0000_0000

	16.BEQ	10_00	RA	RB	  6-bit Immidiate

	17.JAL	10_01	RA	    9-bit Immidiate offset
	18.JLR	10_10	RA	RB	   000_000	
	19.JRI	10_11	RA	    9-bit Immidiate offset
