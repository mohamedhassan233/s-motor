; it writes values to virtual i/o port
; that controls the stepper-motor.
; stepper_motor.exe is on port 7

#start=stepper_motor.exe#

.MODEL SMALL
.DATA
    
    ; bin data for clock-wise
    
    data_cw   DB 0000_0110B
              DB 0000_0100B    
              DB 0000_0011B
              DB 0000_0010B
                             
    ; bin data for anti clock-wise
                             
    data_acw  DB 0000_0011B
              DB 0000_0001B    
              DB 0000_0110B
              DB 0000_0010B 
              
    delay     DB 0000_0000B
              DB 0000_0000B    
              DB 0000_0000B
              DB 0000_0000B          
    
.CODE
.STARTUP

    MOV BX , OFFSET data_cw ; start from clock-wise.
    MOV SI , 0
    MOV CX , 0 ; steps counter
    
    next_step: 
    
        MOV AL , [BX][SI] ; spcifiy the offest
        OUT 7 , AL        ; update bins of motor
        INC SI
        INC CX
        CMP SI, 4      
        JB next_step
        MOV SI ,0
        CMP CX ,8     ; '8' for 90-degree rotation  
        JB  next_step
    
    MOV BX , OFFSET delay 
    MOV SI , 0
    JMP delay_func
    
    RET:                         
    ; Change the direction                         
    MOV BX , OFFSET data_acw 
    MOV SI , 0
    MOV CX , 0
    
    reverse_step: 
    
        MOV AL , [BX][SI] ; spcifiy the offest
        OUT 7 , AL        ; update bins of motor
        INC SI
        INC CX
        CMP SI, 4      
        JB reverse_step
        MOV SI ,0
        CMP CX ,8     ; '8' for 90-degree rotation  
        JB  reverse_step      
        JMP END
        
    ; hold before direction change 
    delay_func:
        MOV AL , [BX][SI]
        OUT 7 , AL
        INC SI
        CMP SI , 4
        JB delay_func
        JMP RET
    END:     
.EXIT




