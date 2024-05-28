#Pascuzzo Matteo
#7072913

#ADD(1) ~ ADD(a) ~ ADD(a) ~ ADD(B) ~ ADD(;) ~ ADD(9) ~SSX~SORT~PRINT~DEL(b) ~DEL(B) ~PRI~SDX~REV~PRINT
#ADD(1) ~ SSX ~ ADD(a) ~ add(B) ~ ADD(B) ~ ADD ~ ADD(9) ~PRINT~SORT(a)~PRINT~DEL(bb) ~DEL(B) ~PRINT~REV~SDX~PRINT
#ADD(z) ~ADD(:) ~ADD(B) ~ADD(z) ~ ADD(;) ~ ADD(c) ~ ADD(0) ~ADD(a) ~ADD(b) ~ PRINT ~ DEL(z) ~ PRINT ~ REV ~ PRINT ~ SDX ~ PRINT ~ SSX ~ PRINT ~ SORT ~ PRINT


.data 
listInput: .string "ADD(])~DEL(]) ~PRINT ~ ADD(g) ~REV ~ ADD($) ~ADD(i) ~ ADD(()~ ADD(6) ~ SDX ~ PRINT ~DEL(g) ~ ADD(N)~ADD(D) ~ SSX ~ PRINT ~ADD(>) ~ ADD(;) ~ ADD(!) ~REV PRINT ~ ADD(M) ~ PRINT~DEL(M) ~ ADD(L)~SORT ~PRINT ~SDX ~ PRINT ~ DEL(6) ~ PRINT~PRINT~PRINT ~ PRINT"
newline: .string "\n"

.text
la s0 listInput
li s1 0                                     #contatore per scorrere la stringa in input
li s2 0                                     #contatore numero comandi
li s3 30                                    #numero max comandi
li s4 0x00500000                            #indirizzo di memoria del primo elemento - PAHEAD
li s5 0x00500000                            #contatore di ciclo posizionale degli elementi
li s6 0                                     #contatore del numero di elementi nella lista concatenata
li s7 7                                     #flag


##############################
############ Main ############
##############################

verifica_input_comando:
    add t1 s0 s1 
    lb t2 0(t1)                              #punto alla prima lettera della stringa
    
    beq t2 zero end_main                     #abbiamo raggiunto la fine della stringa
    
    beq s2 s3 end_main                       #abbiamo raggiunto il numero max di comandi ammessi
    
    li t3 32                                 #carico il char Space in un registro
    beq t2 t3 aumenta_contatore_stringa      #se il char a cui punto è uno spazio allora passo al char sucessivo                 
                
    li t3 65                                 #carico A in un registro
    beq t2 t3 verifica_ADD
    
    li t3 68                                 #carico D in un registro
    beq t2 t3 verifica_DEL
    
    li t3 80                                 #carico P in un registro
    beq t2 t3 verifica_PRINT
    
    li t3 83                                 #carico S in un registro --> rimandare ad un unico metodo che checka il char successivo
    beq t2 t3 verifica_S
    
    li t3 82                                 #carico R in un registro
    beq t2 t3 verifica_REV
    
    j scorri_prossima_tilde
    
    
verifica_ADD:
    beq s2 s3 scorri_prossima_tilde          #se sono al 31esimo comando non lo eseguo
    addi s1 s1 1                             #aumento il contatore
    add t1 s0 s1
    lb t2 0(t1)                              #punto alla seconda lettera
    li t3 68                                 #carico la lettera D in un registro 
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)                              #punto alla terza lettera
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)                              #punto a quella che dovrebbe essere la tonda aperta
    li t3 40                                 #metto la tonda aperta in un registro
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)                              #punto a quello che dovrebbe essere il carattere
    li t4 32                                 #carico ASCII 32 (Space) in un registro
    li t5 125                                #carico ASCII 125 (}) in un registro
    blt t2 t4 scorri_prossima_tilde          #se il char è minore di 32 skippo
    bgt t2 t5 scorri_prossima_tilde          #se il char è maggiore di } skippo
    addi a0 t2 0                             #SALVO IN a0 IL CHAR CORRETTO
    
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)                              #punto a quello che dovrebbe essere la tonda chiusa
    li t3 41                                 #metto la tonda chiusa in un registro
    bne t2 t3 scorri_prossima_tilde
 
comando_unico_ADD:
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    li t5 126
    li t4 32
    beq t2 t5 fine_verifica_ADD              #se trova un char tilde allora il comando è unico
    beq t2 zero ADD                          #sono arrivato fin qui, quindi il comando è corretto ma trovo uno zero quindi sono a fine stringa: eseguo il comando
    bne t2 t4 scorri_prossima_tilde          #se trova un char che non è Space, il comando non è unico e si va al prossimo comando, se trova space va avanti
    j comando_unico_ADD
       
fine_verifica_ADD:
    jal ADD
    li a0 0                                  #resetto l'argomento da passare alle funzioni
    addi s2 s2 1                             #aumento il contatore dei comandi effettuati
    j aumenta_contatore_stringa  


verifica_DEL:
    beq s2 s3 scorri_prossima_tilde          #se sono al 31esimo comando non lo eseguo
    addi s1 s1 1                             #aumento il contatore
    add t1 s0 s1
    lb t2 0(t1)                              #punto alla seconda lettera
    li t3 69                                 #carico la lettera E in un registro 
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)                              #punto alla terza lettera
    li t3 76                                 #carico la lettera L in un registro
    bne t2 t3 scorri_prossima_tilde       
    
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)                              #punto a quella che dovrebbe essere la tonda aperta
    li t3 40                                 #metto la tonda aperta in un registro
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)                              #punto a quello che dovrebbe essere il carattere
    li t4 32                                 #carico ASCII 32 (Space) in un registro
    li t5 125                                #carico ASCII } in un registro
    blt t2 t4 scorri_prossima_tilde          #se il char è minore di 32 skippo
    bgt t2 t5 scorri_prossima_tilde          #se il char è maggiore di } skippo
    addi a0 t2 0                             #SALVO IN a0 IL CHAR CORRETTO
    
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)                              #punto a quello che dovrebbe essere la tonda chiusa
    li t3 41                                 #metto la tonda chiusa in un registro
    bne t2 t3 scorri_prossima_tilde
 
comando_unico_DEL:
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    li t5 126
    li t4 32
    beq t2 t5 fine_verifica_DEL              #se trova un char tilde allora il comando è unico
    beq t2 zero DEL
    bne t2 t4 scorri_prossima_tilde          #se trova un char che non è Space, il comando non è unico e si va al prossimo comando, se trova space va avanti
    j comando_unico_DEL
       
fine_verifica_DEL:
    jal DEL
    li a0 0                                  #resetto l'argomento da passare alle funzioni
    addi s2 s2 1                             #aumento il contatore dei comandi effettuati
    j aumenta_contatore_stringa  


verifica_PRINT:
    beq s2 s3 scorri_prossima_tilde          #se sono al 31esimo comando non lo eseguo
    addi s1 s1 1
    add t1 s0 s1 
    lb t2 0(t1)
    li t3 82                                 #metto il char R in un registro
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1  
    add t1 s0 s1 
    lb t2 0(t1)
    li t3 73                                 #metto il char I in un registro
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1 
    add t1 s0 s1 
    lb t2 0(t1)
    li t3 78                                 #metto il char N in un registro
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1 
    add t1 s0 s1 
    lb t2 0(t1)
    li t3 84                                 #metto il char T in un registro
    bne t2 t3 scorri_prossima_tilde

comando_unico_PRINT:
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    li t5 126
    li t4 32
    beq t2 t5 fine_verifica_PRINT            #se trova un char tilde allora il comando è unico
    beq t2 zero PRINT
    bne t2 t4 scorri_prossima_tilde          #se trova un char che non è Space, il comando non è unico e si va al prossimo comando; se trova space va avanti
    j comando_unico_PRINT
       
fine_verifica_PRINT:
    jal PRINT
    li a0 0                                  #resetto l'argomento da passare alle funzioni
    addi s2 s2 1                             #aumento il contatore dei comandi effettuati
    j aumenta_contatore_stringa  


verifica_REV:
    beq s2 s3 scorri_prossima_tilde          #se sono al 31esimo comando non lo eseguo
    addi s1 s1 1
    add t1 s0 s1 
    lb t2 0(t1)
    li t3 69 
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1
    add t1 s0 s1 
    lb t2 0(t1)
    li t3 86
    bne t2 t3 scorri_prossima_tilde
     
comando_unico_REV:
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    li t5 126
    li t4 32
    beq t2 t5 fine_verifica_REV              #se trova un char tilde allora il comando è unico
    beq t2 zero REV
    bne t2 t4 scorri_prossima_tilde          #se trova un char che non è Space, il comando non è unico e si va al prossimo comando; se trova space va avanti
    j comando_unico_REV
    
fine_verifica_REV:
    jal REV
    li a0 0                                  #resetto l'argomento da passare alle funzioni
    addi s2 s2 1                             #aumento il contatore dei comandi effettuati
    j aumenta_contatore_stringa     
          
             
verifica_S:
    addi s1 s1 1
    add t1 s0 s1 
    lb t2 0(t1)
    li t3 79                                 #metto il char O in un registro
    li t4 68                                 #metto il char D in un registro
    li t5 83                                 #metto il char S in un registro
    
    beq t2 t3 verifica_SORT
    beq t2 t4 verifica_SDX
    beq t2 t5 verifica_SSX
    
    j scorri_prossima_tilde
  

verifica_SORT:
    beq s2 s3 scorri_prossima_tilde          #se sono al 31esimo comando non lo eseguo
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    li t3 82
    bne t2 t3 scorri_prossima_tilde
    
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    li t3 84
    bne t2 t3 scorri_prossima_tilde
    
comando_unico_SORT:
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    li t5 126
    li t4 32
    beq t2 t5 fine_verifica_SORT             #se trova un char tilde allora il comando è unico
    beq t2 zero SORT
    bne t2 t4 scorri_prossima_tilde          #se trova un char che non è Space, il comando non è unico e si va al prossimo comando; se trova space va avanti
    j comando_unico_SORT   
  
fine_verifica_SORT: 
    jal SORT
    li a0 0                                  #resetto l'argomento da passare alle funzioni
    addi s2 s2 1                             #aumento il contatore dei comandi effettuati
    j aumenta_contatore_stringa     
          
   
verifica_SDX:
    beq s2 s3 scorri_prossima_tilde          #se sono al 31esimo comando non lo eseguo
    addi s1 s1 1
    add t1 s0 s1 
    lb t2 0(t1)
    li t3 88
    bne t2 t3 scorri_prossima_tilde 
    
comando_unico_SDX:  
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    li t5 126
    li t4 32
    beq t2 t5 fine_verifica_SDX              #se trova un char tilde allora il comando è unico
    beq t2 zero SDX
    bne t2 t4 scorri_prossima_tilde          #se trova un char che non è Space, il comando non è unico e si va al prossimo comando; se trova space va avanti  
  
fine_verifica_SDX:
    jal SDX
    li a0 0
    addi s2 s2 1
    j aumenta_contatore_stringa    
    
 
verifica_SSX:
    beq s2 s3 scorri_prossima_tilde          #se sono al 31esimo comando non lo eseguo
    addi s1 s1 1
    add t1 s0 s1 
    lb t2 0(t1)
    li t3 88
    bne t2 t3 scorri_prossima_tilde 
       
comando_unico_SSX:
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    li t5 126
    li t4 32
    beq t2 t5 fine_verifica_SSX              #se trova un char tilde allora il comando è unico
    beq t2 zero SSX
    bne t2 t4 scorri_prossima_tilde          #se trova un char che non è Space, il comando non è unico e si va al prossimo comando; se trova space va avanti
    j comando_unico_SSX   
      
fine_verifica_SSX:
    jal SSX
    li a0 0
    addi s2 s2 1
    j aumenta_contatore_stringa      
  
  
scorri_prossima_tilde:
    beq t2 zero end_main
    li t5 126                                 #carico tilde in un registro
    beq t2 t5 aumenta_contatore_stringa       #se il carattere a cui punto è tilde
    addi s1 s1 1
    add t1 s0 s1
    lb t2 0(t1)
    j scorri_prossima_tilde

    
aumenta_contatore_stringa:
    beq t2 zero end_main
    addi s1 s1 1
    j verifica_input_comando
     
  
     
#######################################
################ ADD ##################
#######################################
     
ADD:
    beq s6 zero ADD_primo_elemento                #controllo che sia il primo elemento della catena
    sb a0 0(s5)                                   #Salvo il byte passato come parametro
    sw s4 1(s5)                                   #salvo il puntatore
    addi s6 s6 1 
    addi t6 s5 0                
    addi t6 t6 -5
    j cerca_precedente
        
ADD_primo_elemento:
    sb a0 0(s4)                                   #Salvo il byte passato come parametro
    sw s4 1(s5)                                   #salvo il puntatore 
    addi s5 s5 5                                  #punto alla cella in cui andrò il prossimo elemento
    addi s6 s6 1                                  #numero elementi ++
    jr ra    

cerca_precedente:
    lb t3 0(t6)
    bne t3 s7 collega_successivo
    addi t6 t6 -5
    j cerca_precedente
    
collega_successivo:
    sw s5 1(t6)
    addi s5 s5 5
    jr ra  


#######################################
################ DEL ##################
#######################################

DEL:
    addi t0 s4 0
    addi t6 t0 5
    lb t3 0(t0)
    beq t3 a0 rimuovi_primo                      #funzione che rimuove SOLO il primo elemento

trova_elemento:
    lb t3 0(t6)
    beq t3 a0 elimina
    lw t4 1(t0)
    beq t4 s4 fine_DEL
    beq t3 s7 prosegui
    lw t4 1(t6)
    beq t4 s4 fine_DEL
    addi t0 t6 0
    addi t6 t6 5
    j trova_elemento

elimina:
    sb s7 0(t6)
    lw t4 1(t6)
    beq t4 s4 cambia_PAHEAD
    addi t6 t6 5
    addi s6 s6 -1
    j cerca_successivo  
    
cambia_PAHEAD:
    sw s4 1(t0)
    jr ra
    
cerca_successivo:
    lb t3 0(t6)
    beq t3 a0 elimina
    bne t3 s7 linka
    addi t6 t6 5
    j cerca_successivo
    
linka:
    sw t6 1(t0)
    lw t4 1(t6)
    beq t4 s4 fine_DEL
    addi t6 t6 5
    j trova_elemento                   

prosegui:
    addi t6 t6 5
    j cerca_successivo
        
rimuovi_primo:
    lb t4 1
    beq s6 t4 reset
    lb t3 0(t0)
    beq t3 a0 rimuovi
    bne t3 s7 aggiorna_secondo
    addi t0 t0 5
    j rimuovi_primo
 
rimuovi:
    sb s7 0(t0)
    addi s6 s6 -1
    addi t0 t0 5
    j rimuovi_primo
   
aggiorna_secondo:
    addi t6 t0 0
    j trova_ultimo        

trova_ultimo:
    lb t3 0(t6)
    bne t3 s7 check_puntatore
    addi t6 t6 5
    j trova_ultimo

check_puntatore:
    lw t4 1(t6)
    beq t4 s4 collega_alla_testa
    addi t6 t6 5
    j trova_ultimo

collega_alla_testa:
    addi s4 t0 0
    sw s4 1(t6)
    j DEL
    
reset:
    sb s7 0(t0)
    addi s4 s5 0
    jr ra    

fine_DEL:
    jr ra

#######################################
############### PRINT #################
#######################################  

PRINT:
    beq s6 zero fine_print
    addi t6 s4 0
    
check:
    lb t3 0(t6)
    bne t3 s7 stampa
    addi t6 t6 5
    j check
    
stampa:
    lb a0 0(t6)
    li a7 11
    ecall
    lw t4 1(t6)
    beq t4 s4 fine_print
    addi t6 t6 5
    j check
    
fine_print:
    la a0 newline
    li a7 4
    ecall
    jr ra        


#######################################
################ REV ##################
#######################################  

REV:
    beq s6 zero nessun_elemento
    addi sp sp -30                        #massimo numero di elementi 
    addi t6 s4 0
    
da_catena_a_stack:
    lb t3 0(t6)
    bne t3 s7 metti_in_stack   
    addi t6 t6 5
    j da_catena_a_stack
       
metti_in_stack:
    sb t3 0(sp)
    addi sp sp 1
    lw t4 1(t6)
    beq t4 s4 end_chain
    addi t6 t6 5
    j da_catena_a_stack   
    
end_chain:
    addi sp sp -1
    addi t6 s4 0
    j da_stack_a_catena

da_stack_a_catena:
    lb t3 0(t6)
    bne t3 s7 metti_in_catena
    addi t6 t6 5
    j da_stack_a_catena
    
    
metti_in_catena:
    lb t3 0(sp)
    sb t3 0(t6)
    addi sp sp -1
    lw t4 1(t6)
    beq t4 s4 fine_stack
    addi t6 t6 5
    j da_stack_a_catena            
    
nessun_elemento:
    jr ra    
    
fine_stack:
    addi sp sp 30
    jr ra
    
    


#######################################
################ SORT #################
#######################################

SORT:
    lw s8, 1(s4)
    addi a6, s4, 0
    lw t3, 1(s4)
    beq t3, zero, fine_sort                             #la lista è vuota
    
    add t3, s4, zero
    lw t1, 1(t3)                                        

    beq t1, s4, fine_sort                               #la lista contiene un solo elemento che quindi è ordinato
    
sorting_loop:
    lb t0, 0(t1)
    lb t2, 0(t3)
    li a2, 65                                           #carattere 'A' in codice ASCII
    li a3, 90                                           #carattere 'Z' in codice ASCII
    blt t2, a2, primo_minuscola
    bgt t2, a3, primo_minuscola
    li a4, 0                                            #se arrivo qui vuol dire che è un carattere maiuscolo --> indicato con 0
    j secondo_maiuscola
        
primo_minuscola:
    li a2, 97                                           #carattere 'a' in codice ASCII
    li a3, 122                                          #carattere 'z' in codice ASCII
    blt t2, a2, primo_numero
    bgt t2, a3, primo_numero
    li a4, 1                                            #se arrivo fin qui vuol dire che è un carattere minuscolo --> indicato con 1
    j secondo_maiuscola
                      
primo_numero:
    li a2, 48                                           #carattere '0' in codice ASCII
    li a3, 57                                           #carattere '9' in codice ASCII
    blt t2, a2, primo_extra
    bgt t2, a3, primo_extra
    li a4, 2                                            #se arrivo fin qui vuol dire che è un carattere numerico --> indicato con 2
    j secondo_maiuscola
                
primo_extra:
    li a4, 3                                            #se arrivo fin qui vuol dire che è un carattere speciale --> indicato con 3
              
secondo_maiuscola:
    li a2, 65                                           
    li a3, 90                                        
    blt t0, a2, secondo_minuscola
    bgt t0, a3, secondo_minuscola
    li a5, 0                                            #se arrivo fin qui vuol dire che è un carattere maiuscolo --> indicato con 0
    j compara
        
secondo_minuscola:
    li a2, 97                                           #carattere 'a' in codice ASCII
    li a3, 122                                          #carattere 'z' in codice ASCII
    blt t0, a2, secondo_numero
    bgt t0, a3, secondo_numero
    li a5, 1                                            #se arrivo fin qui vuol dire che è un carattere minuscolo --> indicato con 1
    j compara
                      
secondo_numero:
    li a2, 48                                           #carattere '0' in codice ASCII
    li a3, 57                                           #carattere '9' in codice ASCII
    blt t0, a2, secondo_extra
    bgt t0, a3, secondo_extra
    li a5, 2                                            #se arrivo fin qui vuol dire che è un carattere numerico --> indicato con 2
    j compara
                
secondo_extra:
    li a5, 3                                            #se arrivo fin qui vuol dire che è un carattere speciale --> indicato con 3
                        
compara:
    bgt a4, a5, increment_loop                          #i due elementi appartengono a due categorie diverse
    beq a4, a5, compara_ASCII                           #i due elementi appartengono alla stessa categoria 
    sb t2, 0(t1)
    sb t0, 0(t3)
    j increment_loop
                   
compara_ASCII:
    blt t2, t0, increment_loop
    sb t2, 0(t1)
    sb t0, 0(t3)
                    
increment_loop:
    addi t3, t1, 0
    lw t1, 1(t1)                                        
    bne t1, a6, sorting_loop                            
    addi a6, t3, 0
    add t3, s4, zero
    lw t1, 1(t3)
    bne a6, s8, sorting_loop
                    
fine_sort:
    jr ra
    

#######################################
################ SDX ##################
#######################################

SDX:
    beq s6 zero fine_SDX
    li t0 1
    beq s6 t0 fine_SDX
    li s9 0x00600000
    addi t0 s9 0
    addi t6 s4 0
    
da_catena_a_stringaSDX:
    lb t3 0(t6)
    bne t3 s7 metti_in_stringaSDX
    addi t6 t6 5
    j da_catena_a_stringaSDX
    
metti_in_stringaSDX:
    sb t3 0(t0)
    lw t4 1(t6)
    beq t4 s4 salva_ultimo_SDX
    addi t0 t0 1
    addi t6 t6 5
    j da_catena_a_stringaSDX     

salva_ultimo_SDX:
    lb t1 0(t0)                            #salvo l'ultimo char
    sb s7 0(t0)                            #metto il flag al posto dell'ultimo elemento
    li s10 0x00625000                      #stringa shiftata
    addi t0 s10 0
    sb t1 0(t0)                            #setto l'ultimo char come primo nella stringa shiftata
    addi t1 s9 0
    addi t0 t0 1
    j metti_il_resto_SDX
    
metti_il_resto_SDX:
    lb t2 0(t1)
    beq t2 s7 metti_flag_SDX
    sb t2 0(t0)
    addi t0 t0 1
    addi t1 t1 1
    j metti_il_resto_SDX
    
metti_flag_SDX:
    sb s7 0(t0)
    j put_back_in_chain_SDX    
    
put_back_in_chain_SDX:
    addi t0 s10 0
    addi t6 s4 0
    j stringa_to_catena_SDX    

stringa_to_catena_SDX:
    lb t1 0(t0)                            #carica in un registro i valori della stringa
    beq t1 s7 fine_SDX
    lb t2 0(t6)                            #controlla se è il nodo cancellato logicamente
    beq t2 s7 prossimo_SDX
    sb t1 0(t6)
    addi t0 t0 1
    addi t6 t6 5
    j stringa_to_catena_SDX

prossimo_SDX:
    addi t6 t6 5
    j stringa_to_catena_SDX

fine_SDX:
    jr ra  


#######################################
################ SSX ##################
#######################################

SSX:
    beq s6 zero fine_SSX
    li t0 1
    beq s6 t0 fine_SSX
    li s9 0x00600000
    addi t0 s9 0
    addi t6 s4 0
     
da_catena_a_stringa_SSX:
    lb t3 0(t6)
    bne t3 s7 metti_in_stringa_SSX
    addi t6 t6 5
    j da_catena_a_stringa_SSX
    
metti_in_stringa_SSX:
    sb t3 0(t0)
    lw t4 1(t6)
    beq t4 s4 salva_primo_SSX
    addi t0 t0 1
    addi t6 t6 5
    j da_catena_a_stringa_SSX     

salva_primo_SSX:
    addi t0 t0 1
    sb s7 0(t0)                        #metto il flag alla fine di s9
    addi t0 s9 0
    lb t1 0(t0)                        #salvo il primo carattere che poi sarà l'ultimo
    li s10 0x00625000
    addi t2 s10 0
    addi t0 t0 1
    j metti_il_resto_SSX
    
metti_il_resto_SSX:
    lb t3 0(t0)
    beq t3 s7 metti_flag_e_ultimo_SSX
    sb t3 0(t2)
    addi t2 t2 1
    addi t0 t0 1
    j metti_il_resto_SSX
    
metti_flag_e_ultimo_SSX:
    sb t1 0(t2)
    addi t2 t2 1
    sb s7 0(t2)
    j put_back_in_chain_SSX   
    
put_back_in_chain_SSX:
    addi t0 s10 0
    addi t6 s4 0
    j stringa_to_catena_SSX    

stringa_to_catena_SSX:
    lb t1 0(t0)                            #carica in un registro i valori della stringa
    beq t1 s7 fine_SSX
    lb t2 0(t6)                            #controlla se è un nodo cancellato logicamente
    beq t2 s7 prossimo_SSX
    sb t1 0(t6)
    addi t0 t0 1
    addi t6 t6 5
    j stringa_to_catena_SSX

prossimo_SSX:
    addi t6 t6 5
    j stringa_to_catena_SSX

fine_SSX:
    jr ra  



#######################################
#######################################
#######################################

end_main:
    li a7 10
    ecall   





