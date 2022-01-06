.MODEL SMALL
.DATA
    
    ; bin data for clock-wise
    
    datcw    DB 0000_0110B
             DB 0000_0100B    
             DB 0000_0011B
             DB 0000_0010B
             
    
.CODE
.STARTUP

MOV BX, OFFSET datcw ; start from clock-wise half-step.
MOV SI, 0
MOV CX, 0 ; step counter

next_step: 

MOV AL, [BX][SI]
OUT 7, AL
INC SI
INC CX
CMP SI, 4      
JB next_step
MOV SI,0
CMP CX ,4     ; '4' for 45-degree rotation
JB  next_step

.EXIT




