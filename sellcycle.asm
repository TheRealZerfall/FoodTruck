; 10 SYS (4096)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $34, $30, $39, $36, $29, $00, $00, $00

wait    null '   in line                                  '
passers null '   no show                                  '
gone    null '   toolong                                  '
sold    null '   sold                                     '

Speed           byte 5
BakeTimer       byte 10
TruckType       byte 1
PassCount       byte 0
LineCount       byte 0
SaleCount       byte 0
LeftCount       byte 0

scnH            byte 0
scnL            byte 0

savx            byte 0
savy            byte 0
sava            byte 0


*=$1000

Start
        LDA     #$6F ;initalize randomness
        LDY     #$81 
        LDX     #$FF 
        STA     $D413 
        STY     $D412 
        STX     $D40E 
        STX     $D40F 
        STX     $D414

        lda     #$93 ;clr screen
        jsr     $ffd2

        ldx     #0          
txtloop lda     wait,x
        sta     $04A0,x
        lda     passers,x
        sta     $0568,x
        lda     gone,x
        sta     $0630,x
        lda     sold,x
        sta     $06f8,x
        inx
        cpx     #$28
        bne     txtloop

newcust
        ldx     #25
        ldy     #0
@lp1    jsr     delay
        lda     #$60
        sta     $07d4,x
        lda     #$7f
        dex
        sta     $07d4,x
        bne     @lp1

        lda     $d41b   ;do they stop?
        cmp     #$7f
        bcc     leave
        
        lda     #20
        cmp     LineCount
        bcc     leave
        inc     LineCount
        lda     #25
        sbc     LineCount
        tax
        lda     #00
        sta     $fb
        lda     #$07
        sta     $fc
        ldy     #$d4
        sty     $0400
        sec
lineup  jsr     delay
        lda     #$60
        sta     ($fb),y
        tya
        sty     $0401
        sbc     #40
        tay
        bcc     nxtbl
        sty     $0402
        lda     #$7f
        sta     ($fb),y
        dex
        bne     lineup
        jmp     keepgoing
nxtbl   dec     $fc
        sty     $0403
        sec
        lda     #$7f
        sta     ($fb),y
        dex
        bne     lineup
        
        
        
        jmp     keepgoing

leave   inc     LeftCount
        ldx     #20
@lp2    jsr     delay
        lda     #$60
        sta     $07c0,x
        lda     #$7f
        dex
        sta     $07c0,x
        bne     @lp2
        lda     #$60
        sta     $07c0,x
        
keepgoing
        jmp     newcust

delay   lda     $d012
        cmp     #$ff
        bne     delay
        rts
        
        