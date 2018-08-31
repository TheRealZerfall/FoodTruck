; 10 SYS (4096)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $34, $30, $39, $36, $29, $00, $00, $00
wait    null '   in line                                  '
passers null '   no show                                  '
gone    null '   toolong                                  '
sold    null '   sold                                     '

*=$1000

BAKETIMER = 10

        LDA #$6F 
        LDY #$81 
        LDX #$FF 
        STA $D413 
        STY $D412 
        STX $D40E 
        STX $D40F 
        STX $D414 
        



clearScreen
        lda #$93
        jsr $ffd2
        

        ldx #0
txtloop lda wait,x
        sta $04A0,x
        lda passers,x
        sta $0568,x
        lda gone,x
        sta $0630,x
        lda sold,x
        sta $06f8,x
        inx
        cpx #$28
        bne txtloop

WhoStopped
        lda #00
        sta $2000       ;number in line
        sta $2001       ;number that left
        sta $2003
        sta $2004       ;number sold
        sta $2005       ;people angry
start   jsr delay
        jsr delay

                        ;remove angry from line
        lda $2000
        cmp $11
        bcc cont
        

cont    lda $d41b
        cmp #$4F
        bcc leave
stay    lda #144
        inc $2000
        ldx $2000
        sta $04C8,x
        inx
        stx $04AD
        inc $2003       ;total number of people
        lda $2003
        cmp #80
        bne sell
        jmp done
leave   lda #144
        inc $2001
        ldx $2001
        sta $0590,x
        inx
        stx $0575
        inc $2003
        lda $2003
        cmp #80
        bne sell
        jmp done

sell    dec baketime
        bne skip
        ldy #5
        lda #BAKETIMER
        sta baketime
sellp   lda $2000
        cmp #1
        bcc start
        sta     $0400           ;debug for x-animation
        inc     $D800      
        lda #144
        inc $2004
        ldx $2004
        sta $0720,x
        inx  
        stx $0705
        ldx $2000
        lda #$20
        sta $04C8,x
        dec $2000
        dex
        stx $04AD
        jsr delay
        jsr delay
        dey
        bne sellp
skip    jmp start

done    ldy #11
dnlp    sty $0402
        lda $2000
        cmp #1
        bcc end
        sty $0403
        sta     $0400           ;debug for x-animation
        inc     $D800      
        lda #144
        ldx $2004
        sta $0720,x
        inc $2004
        inx  
        stx $0705
        ldx $2000
        lda #$20
        sta $04C8,x
        dec $2000
        dex
        stx $04AD
        jsr delay2
        sty $0404
        dey
        bne dnlp
end     nop
        jmp end


delay   sty     $0405
        lda     $d012
        cmp     #$ff
        bne     delay
        rts

delay2  ldx     #$7f
delay3  sty     $0406
        lda     $d012
        cmp     #$ff
        bne     delay3
        dex     
        bne     delay3
        rts


baketime byte BAKETIMER