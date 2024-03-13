# Python: Load vector
import numpy as np

data = np.loadtxt('input.txt')
input = np.array(data)  # Convert loaded data to NumPy array
data1 = np.loadtxt('output.txt')
output = np.array(data1)

for i in range(50):
    print(int(output[i]))

with open("CIC_test.txt", 'w') as f:
    for i in range(len(input)):
        f.write("//sample "+str(i)+"\n")
        f.write("sample_indicator <= 1;\n")
        f.write("in <= " + str(int(input[i]))+";\n")
        f.write("#(clk_period);\n")
        f.write("sample_indicator <= 0;\n")
        f.write("#15575;\n")
        f.write("\n")

