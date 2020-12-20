#Written by Harshith(IMT2017516)
#email: Harshith.Reddy@iiitb.org

#run in linux terminal by java -jar Mars4_5.jar nc filename.asm(take inputs from console)

#system calls by MARS simulator:
#http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html
.data
	next_line: .asciiz "\n"	
.text
#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       
#############################################################
#Do not change any code above this line
#Occupied registers $t1,$t2,$t3. Don't use them in your sort function.
#############################################################
#function: should be written by students(sorting function)
#You have to replace this with your code

jal move_inputs # copy the inputs to the location Y(i.e, location saved in $t2)
return: jal bubble_sort # "return" is the "else" part of the beq used in "move_inputs" function

# function to copy inputs to location Y
move_inputs:

# We should NOT change the values of $t1,$t2 and $t3. So we copy the values of $t2 to $t8 and $t3 to $t9
move $t8,$t2
move $t9,$t3

move $s7,$zero	#i = 0
loop2:  beq $s7,$t1,return # loop will go until i != N
	lw $t5,0($t8) # analogous to copying the data at X in a temporary register
	sw $t5,0($t9) # analogous to pasting the data at Y from the temporary register
	addi $s7,$s7,1 # i++
	addi $t8,$t8,4 # updating the address contained in $t8 to the data at X
	addi $t9,$t9,4 # updating the address contained in $t9 whereto the data is to be moved at Y
        j loop2 
        
# bubble_sort function to sort the inputs   
bubble_sort:

# We should NOT change the values of $t1,$t2 and $t3. So we copy the values of $t3 to $t6
# upper limits of the 2 nested loops will be stored in $t4(limit of outer loop) and $t5(limit of inner loop)
subi $t4,$t1,1 # limit1 = N-1
move $t5,$t4 # limit2 = N-1

move $t6,$t3 

move $s6,$zero # i = 0
move $s7,$zero # j = 0

loop3: beq $s6,$t4,loop3end # loop will go until i != N-1
       loop4: beq $s7,$t5,loop4end # loop will go until j != N-i-1 
              lw $t7,0($t6) # copy arr[i]
              lw $t8,4($t6) # copy arr[i+1]
              bgt $t7,$t8,swap # if(arr[i] > arr[i+1]) then swap(arr[i], arr[i+1])
              return1: addi $t6,$t6,4 
         	       addi $s7,$s7,1 
              j loop4
       swap: sw $t8,0($t6)
             sw $t7,4($t6)              
       	     jal return1
       	     
   loop4end:addi $s6,$s6,1 # i = i+1
            subi $t5,$t5,1 # upper limit of inner loop is updated to N-i-1 for updated i
            move $t6,$t3 
            move $s7,$zero # j is reinitialized to zero
       	    j loop3
       	    
loop3end: move $t8,$zero    	     
#endfunction
#############################################################
#You need not change any code below this line

#print sorted numbers
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1		#1 implie
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra
     
