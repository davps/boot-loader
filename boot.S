
#Set the value of symbol to expression: ".set symbol, expression"
.set PROT_MODE_CSEG, 0x8		# kernel code segment selector
.set PROT_MODE_DSEG, 0x10		# kernel data segment selector
.set CR0_PE_ON, 0x10			# protected mode enable flag

.globl start
start:
	.code16 					# assemble for 16-bit mode
	cli							# disable interrups	|| http://en.wikipedia.org/wiki/Interrupt_flag#CLI
	cld							# string operations increment || clears direction flag http://stackoverflow.com/a/9636772
	xorw %ax, %ax 				# Segment number zero || xor - the 'w' in xorw, which stands for word, means 2 bytes
	movw %ax, %ds 				# -> Data segment
	movw %ax, %es 				# -> Extra segment
	movw %ax, %ss 				# -> Stack segment

