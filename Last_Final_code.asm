.MODEL SMALL
.DATA
 HCARRAY    DB  00001000B,
			DB   00001100B,
			DB   00000100B,
			DB   00000110B,
			DB   00000010B,
			DB   00000011B,
			DB   00000001B,
			DB   00000101B
 
 HAARRAY   DB 00001001B,
			DB 00000001B,
			 DB 00000011B,
			 DB 00000010B,
			DB 00000110B,
			DB 00000100B,
			DB 00001100B,
			DB 00001000B
 
 FCARRAY   DB 00000011B,
		   DB	 00001001B,
		DB	 00001100B,
			DB 00000110B
             
 FAARRAY  DB 00000110B,
		   DB     00001100B,
			DB 00001001B,
			DB 00000011B
.CODE
 PORTA  EQU 00H    ;Address of Port A = 00H
 PORTB  EQU 02H    ;Address of Port B= 02H
 PORTC  EQU 04H    ;Address of Port C= 04H
 CR EQU 06H    ;Address of Control register = 06H
ORG 1000H         ;starts code at address 100H
  
   MOV AL, 10001011B ; means I/O device operates in I/O operatio mode and ports A,B are used as outputs port C as input with mode0
  OUT CR, AL    ;outputs(copies) value of AL 80H=1000000B  to I/O port CR 
  
 
START:   ;THE MAIN CODE
 IN AL,PORTC
 MOV BL,AL
 CALL MODE       ;if Al = 01H jumps to Full(Full clockwise mode) else compelte the code(goes to HALFCW)
 ;-------------
HALF:     ;Half mode region
IN AL,PORTC
MOV CL,AL  ;cl=portC
 TEST CL,02H
 JNZ HALFACW   ;if cl=00000010 go to half anticlockwise
 JMP HALFCW    ;if cl=00000000 go to half clockwise
 
HALFCW:  ;Half mode clockwise 8steps each step is 45
CALL HALFCWP
JMP START

HALFACW:    ;Half mode anti clockwise 
CALL HALFACWP
JMP START

FULL: ;full mode clock wise
 IN AL,PORTC
 MOV CL,AL     ;CL=PORTC
 TEST CL,02H   
 JNZ FULLACW  ;if cl=00000011 go to full anticlockwise
 JMP FULLCW   ;if cl=00000001 go to full clockwise
 
 FULLCW:     ;FULL mode clockwise 4steps each step is 90
CALL FULLCWP
JMP START   
;--------------------
FULLACW:     ;full mode anticlock wise
CALL FULLACWP
JMP START
;-----------------
 
 DELAY PROC NEAR  ; DELAY PROCEDURE 
    IN AL, PORTC
    MOV CL,AL
    AND CL,1CH
    CMP CL, 00H   
    JE  STOP
    CMP CL, 04H   ;00000100 
    JE  NORM  
    CMP CL, 08H
    JE MID
    CMP CL,10H
    JE FAST
    RET
  DELAY ENDP
 ;------
   NORM:
 NORMP PROC NEAR
  MOV CX,0ffffH
  LOOPY: LOOP LOOPY
  RET
 NORMP ENDP
;-----------------
 MID:
 MIDP PROC NEAR 
  MOV CX,04000H
  LOOPY1: LOOP LOOPY
  RET
 MIDP ENDP
;----------------- 

 FAST:
 FASTP PROC NEAR
  MOV CX,0fffH
  LOOPY2: LOOP LOOPY
  RET
 FASTP ENDP
 ;--------------------
 
 STOP:
 STOPP PROC NEAR
  MOV AL, 00H
  OUT PORTA , AL
  RET
  STOPP ENDP
  ;---------------
  
 PRESS PROC NEAR
 IN AL, PORTC
 CMP BL, AL
 JNE  MODE1
 RET
 PRESS ENDP
 ;-------------------------
 
 MODE1: 
 MODE PROC NEAR
 IN AL, PORTC   ;Copies value of port B to AL (the value of the 8 bits of portB)
 MOV BL,AL       ;new value of BL 
 TEST BL,1
 JNZ FULL 
 JMP HALF
 MODE ENDP
 ;--------
 ;--------------- Half mode clockwise
;Half mode clockwise

HALFCWP PROC NEAR
MOV BX, OFFSET HCARRAY
MOV SI , 0
 next_step:
   MOV AL, [SI+BX] 
   OUT PORTA,AL        
   CALL PRESS
  CALL DELAY ;DELAY
  INC SI
  CMP SI, 8
  JB next_step
RET
 HALFCWP ENDP
 
;Half mode anti clockwise
HALFACWP PROC NEAR
MOV BX, OFFSET HAARRAY
MOV SI , 0
 next_step2:
   MOV AL, [SI+BX] 
   OUT PORTA,AL        
   CALL PRESS
   CALL DELAY ;DELAY
   INC SI
   CMP SI, 8
   JB next_step2    
RET
 HALFACWP ENDP
 
;Clock-wise Full mode
FULLCWP PROC NEAR 
MOV BX, OFFSET FCARRAY
MOV SI , 0
 next_step3:
   MOV AL, [SI+BX] 
   OUT PORTA,AL        
   CALL PRESS
   CALL DELAY ;DELAY
   INC SI
   CMP SI, 4
   JB next_step3
 RET
 FULLCWP ENDP
 
 ;Anti clock-wise Full mode
 FULLACWP PROC NEAR
MOV BX, OFFSET FAARRAY
MOV SI , 0
 next_step4:
   MOV AL, [SI+BX] 
   OUT PORTA,AL        
   CALL PRESS
   CALL DELAY ;DELAY
   INC SI
   CMP SI, 4
   JB next_step4
RET
FULLACWP ENDP
 
;CODE ENDS
END