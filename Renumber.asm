;
; renumber a BASIC program
;
; NOTE this program ONLY renumbers the lines themselves, GOTO, GOSUB etc.
; are NOT taken into account!
;
*=$C000

ad      = 251
inc     = 255
lin     = 253
        lda     #<100   ; lo byte of starting line number
        sta     lin
        lda     #>100   ; hi byte of starting line number
        sta     lin+1
        lda     #<10    ; lo byte of line number increment
        sta     inc
        lda     #>10    ; hi byte of line number increment
        sta     inc+1

        clc
        lda     43
        sta     ad
        lda     44
        sta     ad+1
loop    ldy     #0
        lda     (ad),y
        pha
        iny
        lda     (ad),y
        pha
        iny
        lda     lin
        sta     (ad),y
        iny
        lda     lin+1
        sta     (ad),y
        lda     lin
        adc     inc
        sta     lin
        bcc     nxt
        inc     lin+1
        clc
nxt     pla
        sta     ad+1
        pla
        sta     ad
        bne     loop
        lda     ad+1
        bne     loop
        rts
