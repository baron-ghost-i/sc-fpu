def halton(i: int):
	i_bin = bin(i)
	i_bin = i_bin[0:2]+i_bin[:1:-1]
	while len(i_bin) < 10:
		i_bin = i_bin + '0'
	print(int(i_bin, 2))

for i in range(256):
	halton(i)