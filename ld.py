def corput(i: int):
	i_bin = bin(i)
	i_bin = i_bin[0:2]+i_bin[:1:-1]
	while len(i_bin) < 10:
		i_bin = i_bin + '0'
	return int(i_bin,2)

def rightmost_zero_index(n):
    """Returns the 0-based index of the rightmost zero bit."""
    x = 0
    # Check bits starting from LSB
    while (n & 1) != 0:
        n >>= 1
        x += 1
    return x

def generate_sobol_1d(num_points):
    # 1. Define Direction Numbers (Simplified for demo)
    # In a real scenario, these are derived from primitive polynomials.
    # We use 32-bit integer scaling.
    # m values for 1st dimension usually start: 1, 3, 5, 15...
    m = [1, 3, 5, 15, 17, 51, 85, 255] 
    
    # Create V array: v_i = m_i << (32 - i)
    # Note: i is 1-based in math, 0-based here for convenience
    V = []
    for i, m_val in enumerate(m):
        shift = 31 - i
        if shift < 0: shift = 0
        V.append(m_val << shift)
    
    # 2. Initialization
    x = 0
    sobol_sequence = []
    
    # 3. Generation Loop (Antonov-Saleev)
    for n in range(num_points):
        # Find index of rightmost zero in n (current step count)
        c = rightmost_zero_index(n)
        
        # Safety check if we run out of direction numbers
        if c >= len(V):
            break 
            
        # XOR current value with specific direction number
        x = x ^ V[c]
        
        # Normalize to [0, 1) for output
        normalized_val = x / (2**32)
        sobol_sequence.append(normalized_val)
        
    return sobol_sequence

# Generate first 10 points
points = generate_sobol_1d(10)
print("1-D Sobol Sequence:", [f"{p:.4f}" for p in points])