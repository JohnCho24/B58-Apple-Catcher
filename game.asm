#####################################################################
#
# CSCB58 Winter 2022 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: John Cho, 1007661594, chojohn1, johnlee.cho@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 3 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. health (three lives are kept track top right, and every stick caught is -1)
# 2. score (score is kept track top left, a pink pixel is shown for every 5 points)
# 3. fail condition (when three lives are lost)
# 4. moving platforms (moves left after hitting right boundary, and 
#		       right after hitting left boundary)
# 5. moving objects (apple, platform, stick, gold apple, basket)
# 6. Pick-up effects (apple: 1 point, stick: -1 life, gold apple: 5 points)
# 7. double jump
#
#
# Link to video demonstration for final submission:
# - https://drive.google.com/file/d/1dY0tZhjBxRMvhhBcf9kNp0CMxSCXcxkI/view?usp=drive_link
#
# Are you OK with us sharing the video with people outside course staff?
# - yes, https://github.com/JohnCho24/B58-Apple-Catcher
#
# Any additional information that the TA needs to know:
# - Forgot to include that there's natural gravity for all objects
#
#####################################################################

# $t3 keeps track of point location
# $t5 keeps track of double jump (1 if already double, 0 if not)
# $t8 is gold apple location
# $t9 is stick location (top pixel)
# $s3 is moving platform control (left = 1, right = 0)
# $s4 is moving platform location (left pixel)
# $s5 is point tracker
# $s6 is apple location (top left pixel)
# $s7 is basket location (top left pixel)

.eqv BASE_ADDRESS 0x10008000
.data	# leave variables, strings, arrays, constants and buffers here

keyboardAddress: .word 0xffff0000
colorSky: .word 0x0087CEEB
colorLeaves: .word 0x00228B22
colorTree: .word 0x00725c42
colorGrass: .word 0x0000ff00
colorPlatform: .word 0x005A5A5A
colorBasket: .word 0x001e140a
colorApple: .word 0x00C7372F
colorStick: .word 0x008a7362
colorHealth: .word 0x00FFC000
colorBlack: .word 0x00000000
colorRed: .word 0x00FF0000
colorGold: .word 0x00D4AF37
colorPoint: .word 0x00FFC0CB

.text
main:
	li $s7, BASE_ADDRESS
	addi $s7, $s7, 7540	# the basket's position
	
drawWorld:
	lw $t1, colorSky
	li $t2, 0
	li $t3, 2048
	li $t4, BASE_ADDRESS

	drawSky:
		sw $t1, 0($t4)
		addi $t4, $t4, 4
		addi $t2, $t2, 1
		bne $t2, $t3, drawSky 

	lw $t1, colorLeaves
	li $t2, 0	
	li $t3, 512	
	li $t4, BASE_ADDRESS

	drawTreeLeaves1:
   		sw $t1, 0($t4)
    		addi $t4, $t4, 4
    		addi $t2, $t2, 4
    		bne $t2, $t3, drawTreeLeaves1

	li $t2, 0
	li $t3, 256
	la $t5, ($t4)

	drawTreeLeaves2:
		addi $t4, $t4, 4
		sw $t1, 0($t4)
    		addi $t4, $t4, 4
    		sw $t1, 0($t4)
    		addi $t4, $t4, 4
    		sw $t1, 0($t4)
    		addi $t4, $t4, 4
    		sw $t1, 0($t4)
    		addi $t4, $t4, 4
    		sw $t1, 0($t4)
    		addi $t4, $t4, 4
    		addi $t4, $t4, 4
    		addi $t2, $t2, 32
    		ble $t2, $t3, drawTreeLeaves2

	lw $t1, colorTree
	li $t2, 0
	li $t3, 28
	addi $t4, $t4, 4

	drawTrees:
		#addi $t4, $t4, 116
		sw $t1, 0($t4)
		addi $t4, $t4, 4
		sw $t1, 0($t4)
		addi $t4, $t4, 244
		
		sw $t1, 0($t4)
		addi $t4, $t4, 4
		sw $t1, 0($t4)
		addi $t4, $t4, 4
		
		addi $t2, $t2, 1
		bne $t2, $t3, drawTrees
	
	addi $t5, $t5, 0
	sw $t1, 0($t5)
	addi $t5, $t5, 248
	sw $t1, 0($t5)
	addi $t5, $t5, 4
	sw $t1, 0($t5)
	
	addi $t4, $t4, -4
	lw $t1, colorGrass
	li $t2, 0
	li $t3, 256

	drawGrass:
		addi $t4, $t4, 4
		sw $t1, 0($t4)
    		addi $t2, $t2, 4
    		bne $t2, $t3, drawGrass
    	
	lw $t1, colorPlatform
	li $t2, 0
	li $t3, 14
	li $t4, BASE_ADDRESS
	addi $t4, $t4, 6936

	drawPlatform1:
		sw $t1, 0($t4)
		addi $t4, $t4, 4
		addi $t2, $t2, 1
		bne $t2, $t3, drawPlatform1

	li $t2, 0
	li $t3, 14
	addi $t4, $t4, 92

	drawPlatform2:
		sw $t1, 0($t4)
		addi $t4, $t4, 4
		addi $t2, $t2, 1
		bne $t2, $t3, drawPlatform2
	
	li $t2, 0
	li $t3, 7
	subi $t4, $t4, 1756
	la $s4, ($t4)	# store beginning of platform3 
	
	drawPlatform3:
		sw $t1, 0($t4)
		addi $t4, $t4, 4
		addi $t2, $t2, 1
		bne $t2, $t3, drawPlatform3
		
	drawBasketInitial:
		addi $sp, $sp, -8
		sw $s0, 0($sp)
		sw $s1, 4($sp)
	
		lw $s1, colorBasket
		addi $s0, $s7, 0
		sw $s1, 0($s0)
		sw $s1, 256($s0)
		sw $s1, 260($s0)
		sw $s1, 264($s0)
		sw $s1, 268($s0)
		sw $s1, 272($s0)
		sw $s1, 16($s0)
	
		lw $s1, 4($sp)
		lw $s0, 0($sp)
		addi $sp, $sp, 8
	
	lw $t1, colorHealth
	lw $t2, colorBlack
	li $t4, BASE_ADDRESS
	addi $t4, $t4, 240
	drawHealth:
		sw $t2, -4($t4)
		sw $t2, 252($t4)
		sw $t2, 256($t4)
		sw $t2, 260($t4)
		sw $t2, 264($t4)
		sw $t2, 268($t4)
		sw $t1, 0($t4)
		sw $t1, 4($t4)
		sw $t1, 8($t4)
		sw $t2, 12($t4)
	
	li $t3, BASE_ADDRESS

loopGame:
	
	li $v0, 32
	li $a0, 200	# 200ms sleep
	syscall
	
	jal movePlatformRight
	jal gravityGoldApple
	jal gravityApple
	jal gravityStick
	jal gravityBasket
	jal resetDoubleJump
	jal keypress

	j loopGame

movePlatformRight:
	beq $s3, 1, movePlatformLeft
	
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $t0, 8($sp)
	
	# Check if it hit right boundary
	lw $s1, 28($s4)	# remember that $s4 is tracking the left of the platform
	lw $t0, colorTree
	beq $t0, $s1, platformHitRightBoundary
	
	# Check if it hit apple (right of platform)
	lw $t0, colorApple
	beq $t0, $s1, platformHitBoundary
	
	# Check if it hit apple (right of platform)
	lw $t0, colorGold
	beq $t0, $s1, platformHitBoundary
	
	# Check if it hit stick (right of platform)
	lw $t0, colorStick
	beq $t0, $s1, platformHitBoundary
	
	# Check if it hit basket (left of platform)
	lw $t0, colorBasket
	beq $t0, $s1, platformHitBoundary
	
	addi $s0, $s4, 0
	lw $t0, colorPlatform
	sw $t0, 28($s0)		# make next unit colorPlatform
	
	lw $t0, colorSky
	sw $t0, 0($s0)	# make the tail of platform, colorSky
	
	# move address one unit right
	addi $s4, $s4, 4
		
	lw $t0, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra

movePlatformLeft:
	beq $s3, 0, movePlatformRight
	
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $t0, 8($sp)
	
	# Check if it hit left boundary
	lw $s1, -4($s4)	# remember that $s4 is tracking the left of the platform
	lw $t0, colorTree
	beq $t0, $s1, platformHitLeftBoundary
	
	# Check if it hit apple (left of platform)
	lw $t0, colorApple
	beq $t0, $s1, platformHitBoundary
	
	# Check if it hit apple (left of platform)
	lw $t0, colorGold
	beq $t0, $s1, platformHitBoundary
	
	# Check if it hit stick (left of platform)
	lw $t0, colorStick
	beq $t0, $s1, platformHitBoundary
	
	# Check if it hit basket (left of platform)
	lw $t0, colorBasket
	beq $t0, $s1, platformHitBoundary
	
	addi $s0, $s4, 0
	lw $t0, colorPlatform
	sw $t0, -4($s0)		# make next unit colorPlatform
	
	lw $t0, colorSky
	sw $t0, 24($s0)	# make the tail of platform, colorSky
	
	# move address one unit left
	addi $s4, $s4, -4
		
	lw $t0, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra

keypress:
	lw $t7, keyboardAddress	# address of keyboard
	lw $t6, 0($t7)
	
    	# Check if jump/reset key has been pressed
    	beq $t6, 1, keypressTrue
	
	# if there was no keypress
	jr $ra

keypressTrue:
	lw $t6, 4($t7)
	
	beq $t6, 97, moveLeft	# if 'a' is pressed move left
	beq $t6, 100, moveRight	# if 'd' is pressed move right
	beq $t6, 119, startJump	# if 'w' is pressed jump up
	beq $t6, 112, restartGame	# if 'p' is pressed restart the game
	
	jr $ra
	
moveLeft:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $t0, 12($sp)
	
	# Check if it hit left boundary
	lw $s2, -4($s7)
	lw $t0, colorTree
	beq $t0, $s2, hitBoundary
	
	# Check if it hit platform (top left basket)
	lw $t0, colorPlatform
	beq $t0, $s2, hitBoundary
	
	# Check if it hit stick (top left basket)
	lw $t0, colorStick
	beq $t0, $s2, stickHitBasketMove
	
	# Check if it hit apple (top left basket)
	lw $t0, colorApple
	beq $t0, $s2, appleHitBasketMove
	
	# Check if it hit apple (top left basket)
	lw $t0, colorGold
	beq $t0, $s2, goldAppleHitBasketMove
	
	# Check if it hit platform (bottom left basket)
	lw $s2, 252($s7)
	lw $t0, colorPlatform
	beq $t0, $s2, hitBoundary
	
	# Check if it hit stick (bottom left basket)
	lw $t0, colorStick
	beq $t0, $s2, stickHitBasketMove
	
	# Check if it hit apple (bottom left basket)
	lw $t0, colorApple
	beq $t0, $s2, appleHitBasketMove
	
	# Check if it hit apple (bottom left basket)
	lw $t0, colorGold
	beq $t0, $s2, goldAppleHitBasketMove
	
	# delete Basket
	lw $s1, colorSky
	addi $s0, $s7, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 264($s0)
	sw $s1, 268($s0)
	sw $s1, 272($s0)
	sw $s1, 16($s0)
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# move address one unit left
	addi $s7, $s7, -4
	
	# redraw Basket
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	lw $s1, colorBasket
	addi $s0, $s7, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 264($s0)
	sw $s1, 268($s0)
	sw $s1, 272($s0)
	sw $s1, 16($s0)
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra

moveRight:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $t0, 12($sp)
	
	# Check if it hit right boundary
	lw $s2, 20($s7)	# remember that $s7 is tracking the top left of basket
	lw $t0, colorTree
	beq $t0, $s2, hitBoundary
	
	# Check if it hit platform (top right basket)
	lw $t0, colorPlatform
	beq $t0, $s2, hitBoundary
	
	# Check if it hit stick (top right basket)
	lw $t0, colorStick
	beq $t0, $s2, stickHitBasketMove
	
	# Check if it hit apple (top right basket)
	lw $t0, colorApple
	beq $t0, $s2, appleHitBasketMove
	
	# Check if it hit apple (top right basket)
	lw $t0, colorGold
	beq $t0, $s2, goldAppleHitBasketMove
	
	# Check if it hit platform (bottom right basket)
	lw $s2, 276($s7)
	lw $t0, colorPlatform
	beq $t0, $s2, hitBoundary
	
	# Check if it hit stick (bottom right basket)
	lw $t0, colorStick
	beq $t0, $s2, stickHitBasketMove
	
	# Check if it hit apple (bottom right basket)
	lw $t0, colorApple
	beq $t0, $s2, appleHitBasketMove
	
	# Check if it hit apple (bottom right basket)
	lw $t0, colorGold
	beq $t0, $s2, goldAppleHitBasketMove
	
	# delete Basket
	lw $s1, colorSky
	addi $s0, $s7, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 264($s0)
	sw $s1, 268($s0)
	sw $s1, 272($s0)
	sw $s1, 16($s0)
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# move address one unit Right
	addi $s7, $s7, 4
	
	# redraw Basket
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	lw $s1, colorBasket
	addi $s0, $s7, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 264($s0)
	sw $s1, 268($s0)
	sw $s1, 272($s0)
	sw $s1, 16($s0)
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra

resetDoubleJump:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $t0, 12($sp)
	
	# Check if it is on a platform/ground (left side)
	lw $s2, 512($s7)
	lw $t0, colorGrass
	beq $t0, $s2, resetDoubleJumpTrue
	
	lw $t0, colorPlatform
	beq $t0, $s2, resetDoubleJumpTrue
	
	# Check if it is on a platform/ground (right side)
	lw $s2, 528($s7)
	lw $t0, colorGrass
	beq $t0, $s2, resetDoubleJumpTrue
	
	lw $t0, colorPlatform
	beq $t0, $s2, resetDoubleJumpTrue
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra

resetDoubleJumpTrue:
	li $t5, 0
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra
	
endJump2:
	# Check if it has double jump
	beq $t5, 1, endJump
	
	li $t5, 1
	li $t4, 0
	
	j jumpUp

endJump1:
	# Check if it is on a platform/ground (right side)
	lw $s2, 528($s7)
	beq $t0, $s2, endJump2
	
	li $t4, 0
	
	j jumpUp

startJump:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $t0, 12($sp)
	
	# Check if it is on a platform/ground (left side)
	lw $s2, 512($s7)
	lw $t0, colorSky
	beq $t0, $s2, endJump1
	
	li $t4, 0

jumpUp:
	addi $t4, $t4, 1
	
	li $v0, 32
	li $a0, 10	# 10ms sleep
	syscall
	
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $t0, 12($sp)
	
	# Check if it hit platform (top left basket)
	lw $s2, -256($s7)
	lw $t0, colorPlatform
	beq $t0, $s2, endJump
	
	# Check if it hit leaves (top left basket)
	lw $t0, colorLeaves
	beq $t0, $s2, endJump
	
	# Check if it hit stick (top left basket)
	lw $t0, colorStick
	beq $t0, $s2, endJump
	
	# Check if it hit apple (top left basket)
	lw $t0, colorApple
	beq $t0, $s2, endJump
	
	# Check if it hit apple (top left basket)
	lw $t0, colorGold
	beq $t0, $s2, endJump
	
	# Check if it hit platform (bottom left basket)
	lw $s2, 4($s7)
	lw $t0, colorPlatform
	beq $t0, $s2, endJump
	
	# Check if it hit leaves (bottom left basket)
	lw $t0, colorLeaves
	beq $t0, $s2, endJump
	
	# Check if it hit stick (bottom left basket)
	lw $t0, colorStick
	beq $t0, $s2, endJump
	
	# Check if it hit apple (bottom left basket)
	lw $t0, colorApple
	beq $t0, $s2, endJump
	
	# Check if it hit apple (bottom left basket)
	lw $t0, colorGold
	beq $t0, $s2, endJump
	
	# Check if it hit platform (bottom middle basket)
	lw $s2, 8($s7)
	lw $t0, colorPlatform
	beq $t0, $s2, endJump
	
	# Check if it hit leaves (bottom middle basket)
	lw $t0, colorLeaves
	beq $t0, $s2, endJump
	
	# Check if it hit stick (bottom middle basket)
	lw $t0, colorStick
	beq $t0, $s2, endJump
	
	# Check if it hit apple (bottom middle basket)
	lw $t0, colorApple
	beq $t0, $s2, endJump
	
	# Check if it hit apple (bottom middle basket)
	lw $t0, colorGold
	beq $t0, $s2, endJump
	
	# Check if it hit platform (bottom right basket)
	lw $s2, 12($s7)
	lw $t0, colorPlatform
	beq $t0, $s2, endJump
	
	# Check if it hit leaves (bottom right basket)
	lw $t0, colorLeaves
	beq $t0, $s2, endJump
	
	# Check if it hit stick (bottom right basket)
	lw $t0, colorStick
	beq $t0, $s2, endJump
	
	# Check if it hit apple (bottom right basket)
	lw $t0, colorApple
	beq $t0, $s2, endJump
	
	# Check if it hit apple (bottom right basket)
	lw $t0, colorGold
	beq $t0, $s2, endJump
	
	
	# Check if it hit platform (top right basket)
	lw $s2, -240($s7)
	lw $t0, colorPlatform
	beq $t0, $s2, endJump
	
	# Check if it hit leaves (top right basket)
	lw $t0, colorLeaves
	beq $t0, $s2, endJump
	
	# Check if it hit stick (top right basket)
	lw $t0, colorStick
	beq $t0, $s2, endJump
	
	# Check if it hit apple (top right basket)
	lw $t0, colorApple
	beq $t0, $s2, endJump
	
	# Check if it hit apple (top right basket)
	lw $t0, colorGold
	beq $t0, $s2, endJump
	
	# delete Basket
	lw $s1, colorSky
	addi $s0, $s7, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 264($s0)
	sw $s1, 268($s0)
	sw $s1, 272($s0)
	sw $s1, 16($s0)
	
	lw $t0, 112($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# move address one unit up
	addi $s7, $s7, -256
	
	# redraw Basket
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	lw $s1, colorBasket
	addi $s0, $s7, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 264($s0)
	sw $s1, 268($s0)
	sw $s1, 272($s0)
	sw $s1, 16($s0)
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	# loop the jump for 8 units
	bne $t4, 8, jumpUp
	
	# end the jump
	li $t4, 0	# reset jump counter
	
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
endJump:
	li $t4, 0	# reset jump counter
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra
	
gravityBasket:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $t0, 12($sp)
	
	# Check if it hit ground
	lw $s2, 512($s7) # remember that $s7 is tracking the top left of basket
	lw $t0, colorGrass
	beq $t0, $s2, hitBoundary
	
	# Check if it hit platform (left side of basket)
	lw $t0, colorPlatform
	beq $t0, $s2, hitBoundary
	
	# Check if it hit platform (right side of basket)
	lw $s2, 528($s7)
	beq $t0, $s2, hitBoundary
	
	# delete Basket
	lw $s1, colorSky
	addi $s0, $s7, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 264($s0)
	sw $s1, 268($s0)
	sw $s1, 272($s0)
	sw $s1, 16($s0)
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# move address one unit down
	addi $s7, $s7, 256
	
	# redraw Basket
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	lw $s1, colorBasket
	addi $s0, $s7, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 264($s0)
	sw $s1, 268($s0)
	sw $s1, 272($s0)
	sw $s1, 16($s0)
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra

gravityApple:
	beq $s6, 0, drawApple

	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $t0, 12($sp)
	
	# delete apple
	lw $s1, colorSky
	addi $s0, $s6, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 4($s0)
	
	# Check if it hit ground
	lw $s2, 512($s6) # remember that $s6 is tracking the top left of apple
	lw $t0, colorGrass
	beq $t0, $s2, appleHitBoundary
	
	# Check if it hit platform (bottom left of apple)
	lw $t0, colorPlatform
	beq $t0, $s2, appleHitBoundary
	
	# Check if it hit platform (bottom right of apple)
	lw $s2, 516($s6)
	beq $t0, $s2, appleHitBoundary
	
	# Check if it hit basket (bottom right of apple)
	lw $t0, colorBasket
	beq $t0, $s2, appleHitBasket
	
	# Check if it hit basket (bottom left of apple)
	lw $s2, 512($s6)
	beq $t0, $s2, appleHitBasket
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# move address one unit down
	addi $s6, $s6, 256
	
	# redraw Apple
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	lw $s1, colorApple
	addi $s0, $s6, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 4($s0)
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra

gravityGoldApple:
	beq $t8, 0, drawGoldApple

	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $t0, 12($sp)
	
	# delete apple
	lw $s1, colorSky
	addi $s0, $t8, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 4($s0)
	
	# Check if it hit ground
	lw $s2, 512($t8) # remember that $t8 is tracking the top left of apple
	lw $t0, colorGrass
	beq $t0, $s2, goldAppleHitBoundary
	
	# Check if it hit platform (bottom left of apple)
	lw $t0, colorPlatform
	beq $t0, $s2, goldAppleHitBoundary
	
	# Check if it hit platform (bottom right of apple)
	lw $s2, 516($t8)
	beq $t0, $s2, goldAppleHitBoundary
	
	# Check if it hit basket (bottom right of apple)
	lw $t0, colorBasket
	beq $t0, $s2, goldAppleHitBasket
	
	# Check if it hit basket (bottom left of apple)
	lw $s2, 512($t8)
	beq $t0, $s2, goldAppleHitBasket
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# move address one unit down
	addi $t8, $t8, 256
	
	# redraw Apple
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	lw $s1, colorGold
	addi $s0, $t8, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 4($s0)
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra

gravityStick:
	beq $t9, 0, drawStick

	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $t0, 12($sp)
	
	# delete Stick
	lw $s1, colorSky
	addi $s0, $t9, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 512($s0)
	
	# Check if it hit ground
	lw $s2, 768($t9) # remember that $t9 is tracking the top left of apple
	lw $t0, colorGrass
	beq $t0, $s2, stickHitBoundary
	
	# Check if it hit platform (bottom of stick)
	lw $t0, colorPlatform
	beq $t0, $s2, stickHitBoundary
	
	# Check if it hit platform (middle of stick)
	lw $s2, 512($t9)
	beq $t0, $s2, stickHitBoundary
	
	# Check if it hit platform (top of stick)
	lw $s2, 256($t9)
	beq $t0, $s2, stickHitBoundary
	
	# Check if it hit basket (top of stick)
	lw $t0, colorBasket
	beq $t0, $s2, stickHitBasket
	
	# Check if it hit basket (middle of stick)
	lw $s2, 512($t9)
	beq $t0, $s2, stickHitBasket
	
	# Check if it hit basket (bottom of stick)
	lw $s2, 768($t9)
	beq $t0, $s2, stickHitBasket
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# move address one unit down
	addi $t9, $t9, 256
	
	# redraw Stick
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	lw $s1, colorStick
	addi $s0, $t9, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 512($s0)
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra


drawApple:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $t0, 8($sp)
	
	# random number that gets put into $a0 after syscall
	li $v0, 42
	li $a0, 0
	li $a1, 58
	syscall
	
	li $t0, 4
	mult $a0, $t0
	mflo $t0
	
	addi $s0, $t0, BASE_ADDRESS 	# get address + random num
	addi $s0, $s0, 776	# put on the correct line to be generated
	addi $s6, $s0, 0	# store location of apple
	
	lw $s1, colorApple
	sw $s1, 0($s0)
	sw $s1, 4($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	
	lw $t0, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
	j gravityApple

drawGoldApple:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $t0, 8($sp)
	
	# random number that gets put into $a0 after syscall
	li $v0, 42
	li $a0, 0
	li $a1, 58
	syscall
	
	li $t0, 4
	mult $a0, $t0
	mflo $t0
	
	addi $s0, $t0, BASE_ADDRESS 	# get address + random num
	addi $s0, $s0, 776	# put on the correct line to be generated
	addi $t8, $s0, 0	# store location of apple
	
	lw $s1, colorGold
	sw $s1, 0($s0)
	sw $s1, 4($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	
	lw $t0, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
	j gravityGoldApple

drawStick:
	li $v0, 32
	li $a0, 30	# sleep for 30ms
	syscall
	
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $t0, 8($sp)
	
	# random number that gets put into $a0 after syscall
	li $v0, 42
	li $a0, 0
	li $a1, 58
	syscall
	
	li $t0, 4
	mult $a0, $t0
	mflo $t0
	
	addi $s0, $t0, BASE_ADDRESS 	# get address + random num
	addi $s0, $s0, 776	# put on the correct line to be generated
	addi $t9, $s0, 0	# store location of apple
	
	lw $s1, colorStick
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 512($s0)
	
	lw $t0, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
	j gravityStick

hitBoundary:
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra

appleHitBoundary:
	li $s6, 0	# make new apple
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra

goldAppleHitBoundary:
	li $t8, 0	# make new apple
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra

stickHitBoundary:
	li $t9, 0	# make new stick
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra

platformHitBoundary:
	lw $t0, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra

platformHitRightBoundary:
	li $s3, 1	# tell to move left
	
	lw $t0, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra

platformHitLeftBoundary:
	li $s3, 0	# tell to move Right
	
	lw $t0, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra

appleHitBasket:
	li $s6, 0	# make new apple
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# if hit basket, gain a point
	addi $s5, $s5, 1
	b gainedPoint
	
	jr $ra

goldAppleHitBasket:
	li $t8, 0	# make new apple
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# if hit basket, gain a point
	addi $s5, $s5, 5
	b drawPoint
	
	jr $ra

gainedPoint:
	li $t1, 5
	div $s5, $t1
	mfhi $t1
	beq $t1, 0, drawPoint
	
	jr $ra

drawPoint:
	lw $t0, colorPoint
	sw $t0, 0($t3)
	addi $t3, $t3, 4
	 
	jr $ra

stickHitBasket:
	
	li $t9, 0	# make new stick
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	# if you have three lives, lose first
	lw $t0, colorRed
	li $t1, BASE_ADDRESS
	addi $t1, $t1, 240
	lw $t2, 0($t1)
	bne $t0, $t2, loseLife1
	
	# if you have two lives, lose second
	lw $t2, 4($t1)
	bne $t0, $t2, loseLife2
	
	# if you have one life remaining, you LOSE :)
	j endScreen
	
	jr $ra

appleHitBasketMove:
	# delete apple
	lw $s1, colorSky
	addi $s0, $s6, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 4($s0)
	
	li $s6, 0	# make new apple
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# if hit basket, gain a point
	addi $s5, $s5, 1
	b gainedPoint
	
	jr $ra

goldAppleHitBasketMove:
	# delete apple
	lw $s1, colorSky
	addi $s0, $t8, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 260($s0)
	sw $s1, 4($s0)
	
	li $t8, 0	# make new apple
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	# if hit basket, gain 5 points
	addi $s5, $s5, 5
	b drawPoint
	
	jr $ra

stickHitBasketMove:
	# delete stick
	lw $s1, colorSky
	addi $s0, $t9, 0
	sw $s1, 0($s0)
	sw $s1, 256($s0)
	sw $s1, 512($s0)
	
	li $t9, 0	# make new stick
	
	lw $t0, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	# if you have three lives, lose first
	lw $t0, colorRed
	li $t1, BASE_ADDRESS
	addi $t1, $t1, 240
	lw $t2, 0($t1)
	bne $t0, $t2, loseLife1
	
	# if you have two lives, lose second
	lw $t2, 4($t1)
	bne $t0, $t2, loseLife2
	
	# LOST YOUR LAST LIFE, you LOSE :)
	j endScreen
	
	jr $ra

loseLife1:
	sw $t0, 0($t1)
	
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra

loseLife2:
	sw $t0, 4($t1)
	
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra

restartGame:
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	j main

endScreen:
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 12
	
	lw $t1, colorBlack
	li $t2, 0
	li $t3, 2048
	li $t4, BASE_ADDRESS

	drawBlack:
		sw $t1, 0($t4)
		addi $t4, $t4, 4
		addi $t2, $t2, 1
		bne $t2, $t3, drawBlack
	
	lw $t1, colorSky
	li $t2, BASE_ADDRESS
	drawText:
		# draw P
		addi $t3, $t2, 2068
		sw $t1, 0($t3)
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 768($t3)
		sw $t1, 1024($t3)
		sw $t1, 1280($t3)
		sw $t1, 1536($t3)
		sw $t1, 1792($t3)
		sw $t1, 2048($t3)
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 776($t3)
		sw $t1, 772($t3)
		
		# draw o
		addi $t3, $t3, 1300
		sw $t1, 508($t3)
		sw $t1, 252($t3)
		sw $t1, 0($t3)
		sw $t1, 4($t3)
		sw $t1, 264($t3)
		sw $t1, 520($t3)
		sw $t1, 772($t3)
		sw $t1, 768($t3)
		
		# draw i
		addi $t3, $t3, 24
		sw $t1, -256($t3)
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 768($t3)
		
		# draw n
		addi $t3, $t3, 16
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 768($t3)
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 780($t3)
		
		# draw t
		addi $t3, $t3, 28
		sw $t1, -512($t3)
		sw $t1, -256($t3)
		sw $t1, 0($t3)
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 768($t3)
		sw $t1, -4($t3)
		sw $t1, 4($t3)
		
		# draw s
		addi $t3, $t3, 16
		sw $t1, -252($t3)
		sw $t1, -248($t3)
		sw $t1, 0($t3)
		sw $t1, 260($t3)
		sw $t1, 264($t3)
		sw $t1, 524($t3)
		sw $t1, 776($t3)
		sw $t1, 772($t3)
		
		# draw :
		addi $t3, $t3, 20
		sw $t1, 0($t3)
		sw $t1, 512($t3)
		
		# retrieve point and match it
		li $t5, 10
		div $s5, $t5
		mflo $t6	# takes the first and second digit
		mfhi $t8	# takes the third digit
		div $t6, $t5
		mflo $t6	# first digit
		mfhi $t7	# second digit
		
		
		# draw point
		addi $t3, $t3, -752
		jal drawFirstDigit
		
		addi $t3, $t3, 24
		jal drawSecondDigit
		
		addi $t3, $t3, 24
		jal drawThirdDigit
		
		j end
	
	drawFirstDigit:
		beq $t6, 0, drawZero
		beq $t6, 1, drawOne
		beq $t6, 2, drawTwo
		beq $t6, 3, drawThree
		beq $t6, 4, drawFour
		beq $t6, 5, drawFive
		beq $t6, 6, drawSix
		beq $t6, 7, drawSeven
		beq $t6, 8, drawEight
		beq $t6, 9, drawNine
		
		jr $ra
	
	drawSecondDigit:
		beq $t7, 0, drawZero
		beq $t7, 1, drawOne
		beq $t7, 2, drawTwo
		beq $t7, 3, drawThree
		beq $t7, 4, drawFour
		beq $t7, 5, drawFive
		beq $t7, 6, drawSix
		beq $t7, 7, drawSeven
		beq $t7, 8, drawEight
		beq $t7, 9, drawNine
		
		jr $ra
		
	drawThirdDigit:
		beq $t8, 0, drawZero
		beq $t8, 1, drawOne
		beq $t8, 2, drawTwo
		beq $t8, 3, drawThree
		beq $t8, 4, drawFour
		beq $t8, 5, drawFive
		beq $t8, 6, drawSix
		beq $t8, 7, drawSeven
		beq $t8, 8, drawEight
		beq $t8, 9, drawNine
		
		jr $ra
		
	drawOne:
		sw $t1, 12($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 780($t3)
		sw $t1, 1036($t3)
		sw $t1, 1292($t3)
		sw $t1, 1548($t3)
		
		jr $ra
		
	drawTwo:
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 776($t3)
		sw $t1, 772($t3)
		sw $t1, 1024($t3)
		sw $t1, 1280($t3)
		sw $t1, 1540($t3)
		sw $t1, 1544($t3)
		
		jr $ra
		
	drawThree:
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 776($t3)
		sw $t1, 772($t3)
		sw $t1, 1036($t3)
		sw $t1, 1292($t3)
		sw $t1, 1540($t3)
		sw $t1, 1544($t3)
		
		jr $ra
			
	drawFour:
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 776($t3)
		sw $t1, 772($t3)
		sw $t1, 1036($t3)
		sw $t1, 1292($t3)
		
	drawFive:
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 776($t3)
		sw $t1, 772($t3)
		sw $t1, 1036($t3)
		sw $t1, 1292($t3)
		sw $t1, 1540($t3)
		sw $t1, 1544($t3)
		
		jr $ra
		
	drawSix:
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 776($t3)
		sw $t1, 772($t3)
		sw $t1, 1036($t3)
		sw $t1, 1292($t3)
		sw $t1, 1024($t3)
		sw $t1, 1280($t3)
		sw $t1, 1540($t3)
		sw $t1, 1544($t3)
		
		jr $ra
		
	drawSeven:
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 780($t3)
		sw $t1, 1036($t3)
		sw $t1, 1292($t3)
		sw $t1, 1548($t3)
		
		jr $ra
		
	drawEight:
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 776($t3)
		sw $t1, 772($t3)
		sw $t1, 1024($t3)
		sw $t1, 1280($t3)
		sw $t1, 1036($t3)
		sw $t1, 1292($t3)
		sw $t1, 1540($t3)
		sw $t1, 1544($t3)
		
		jr $ra
		
	drawNine:
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 776($t3)
		sw $t1, 772($t3)
		sw $t1, 1036($t3)
		sw $t1, 1292($t3)
		sw $t1, 1540($t3)
		sw $t1, 1544($t3)
		
		jr $ra
			
	drawZero:
		sw $t1, 4($t3)
		sw $t1, 8($t3)
		sw $t1, 256($t3)
		sw $t1, 512($t3)
		sw $t1, 768($t3)
		sw $t1, 268($t3)
		sw $t1, 524($t3)
		sw $t1, 780($t3)
		sw $t1, 1024($t3)
		sw $t1, 1280($t3)
		sw $t1, 1036($t3)
		sw $t1, 1292($t3)
		sw $t1, 1540($t3)
		sw $t1, 1544($t3)
		
		jr $ra
		
		
end:
	li $v0, 10 # terminate the program gracefully
	syscall
