
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

  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this.
seta20.1:
  inb     $0x64,%al               # Wait for not busy || http://pdos.csail.mit.edu/6.828/2011/readings/i386/IN.htm
  testb   $0x2,%al
  jnz     seta20.1

  movb    $0xd1,%al               # 0xd1 -> port 0x64
  outb    %al,$0x64				  # || http://pdos.csail.mit.edu/6.828/2011/readings/i386/OUT.htm

seta20.2:
  inb     $0x64,%al               # Wait for not busy
  testb   $0x2,%al
  jnz     seta20.2

  movb    $0xdf,%al               # 0xdf -> port 0x60
  outb    %al,$0x60


  # Switch from real to protected mode, using a bootstrap GDT
  # and segment translation that makes virtual addresses 
  # identical to their physical addresses, so that the 
  # effective memory map does not change during the switch.
   lgdt gdtdesc 				# http://pdos.csail.mit.edu/6.828/2008/readings/i386/LGDT.htm
   movl %cr0, %eax
   orl $CR0_PE_ON, %eax
   movl    %eax, %cr0

