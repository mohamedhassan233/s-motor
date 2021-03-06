.MODEL SMALL
.DATA
    
    ; bin data for anti clock-wise
    data_acw  DB 0000_0011B
              	   DB 0000_0001B    
              	   DB 0000_0110B
              	   DB 0000_0010B        
    

.CODE
.STARTUP

MOV BX, OFFSET data_acw
MOV SI, 0
MOV CX, 0 ; step counter


next_step: 

MOV AL, [BX][SI] ; accessing the array by index
OUT 7, AL ; update stepper motors's bins by the value at AL
INC SI
INC CX
CMP SI, 4      
JB next_step
MOV SI,0
CMP CX ,4     ; '4' for 45-degree rotation
JB  next_step

.EXIT
