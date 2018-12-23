program = [
'lw 2',
'mov 14 28',
'lw 4',
'mov 15 28',
'nop'
]

f = open('rom.dat', 'r+')
f.truncate(0)

with open("rom.dat", "a") as myfile:
	for line in program:
		fields = line.split(' ')
		if 'lw' in line:
			op = '0001'
			imm = '{0:010b}'.format(int(fields[1]))
			command = imm + op
		elif 'mov' in line:
			op = '0000'
			src = '{0:05b}'.format(int(fields[2]))
			dst = '{0:05b}'.format(int(fields[1]))
			command = dst + src + op
		elif 'j' in line:
			op = '0010'
			imm = '{0:010b}'.format(int(fields[1]))
			command = imm + op
		elif 'beq' in line:
			op = '0011'
			imm = '{0:010b}'.format(int(fields[1]))
			command = imm + op
		elif 'blt' in line:
			op = '0100'
			imm = '{0:010b}'.format(int(fields[1]))
			command = imm + op
		elif 'nop' in line:
			command = '000000000000'
		myfile.write(format(int(command, 2), 'x') + '\n')
		print(format(int(command, 2), 'x'))