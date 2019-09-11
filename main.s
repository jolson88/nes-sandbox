.include "defs.s"


; ----------------------------------------------------------------------------
; CHR ROM

.segment "TILES"
	; .incbin "background.chr"
	; .incbin "sprite.chr"


; ----------------------------------------------------------------------------
; VECTORS

.segment "VECTORS"
.word nmi
.word reset
.word irq

; ----------------------------------------------------------------------------
; RESET handler

.segment "CODE"

reset:
	sei			; Disable interrupts
	cld			; Clear decimal mode
	ldx #$ff
	txs			; Initialize SP = $FF
	inx
	stx PPUCTRL		; PPUCTRL = 0
	stx PPUMASK		; PPUMASK = 0
	stx APUSTATUS		; APUSTATUS = 0

	; PPU warmup, wait two frames, plus a third later.
	; http://forums.nesdev.com/viewtopic.php?f=2&t=3958
:
	bit PPUSTATUS
	bpl :-
:
	bit PPUSTATUS
	bpl :-

	; Zero ram.
	txa
:	
	sta $000, x
	sta $100, x
	sta $200, x
	sta $300, x
	sta $400, x
	sta $500, x
	sta $600, x
	sta $700, x
	inx
	bne :-

	; Final wait for PPU warmup.
:	
	bit PPUSTATUS
	bpl :-

	; TEMP: Play audio forever.
	lda #$01		; enable pulse 1
	sta APUSTATUS
	lda #$08		; period
	sta $4002
	lda #$02
	sta $4003
	lda #$bf		; volume
	sta $4000

	; NES is initialized, ready to begin!
	; enable the NMI for graphical updates, and jump to our main program
	lda #%10001000
	sta $2000
	jmp main

; ----------------------------------------------------------------------------
; NMI (vertical blank) handler

.segment "ZEROPAGE"
scroll_x:       .res 1 ; x scroll position
scroll_y:       .res 1 ; y scroll position

.segment "BSS"
palette:    .res 32  ; palette buffer for PPU update

.segment "OAM"
oam: .res 256        ; sprite OAM data to be uploaded by DMA

.segment "CODE"
nmi:
	rti


; ----------------------------------------------------------------------------
; NMI (vertical blank) handler

.segment "CODE"
irq:
	rti


; ----------------------------------------------------------------------------
; UTILITIES

.segment "CODE"

; ----------------------------------------------------------------------------
; MAIN

.segment "RODATA"
example_palette:
.byte $0F,$15,$26,$37 ; bg0 purple/pink
.byte $0F,$09,$19,$29 ; bg1 green
.byte $0F,$01,$11,$21 ; bg2 blue
.byte $0F,$00,$10,$30 ; bg3 greyscale
.byte $0F,$18,$28,$38 ; sp0 yellow
.byte $0F,$14,$24,$34 ; sp1 purple
.byte $0F,$1B,$2B,$3B ; sp2 teal
.byte $0F,$12,$22,$32 ; sp3 marine

.segment "CODE"
main:
	; setup
	ldx #0

@loop:
	jmp @loop
