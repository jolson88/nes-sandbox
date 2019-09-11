prg_npage = 2 ; Size of PRG (units of 16KB)
chr_npage = 1 ; Size of CHR (units of 8KB)
mapper = 0    ; INES mapper number
mirroring = 1 ; 0 = horizontal, 1 = vertical

.segment "HEADER"
	.byte $4e, $45, $53, $1a ; 'NES'
	.byte prg_npage
	.byte chr_npage
	.byte ((mapper & $0f) << 4) | (mirroring & 1)
	.byte mapper & $f0