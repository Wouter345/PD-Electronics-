function encodedBitstream = differentialEncoding(bitstream)
  % Initialize the encoded bitstream with the first bit of the original stream.
  encodedBitstream = [];
  encodedBitstream = bitstream(1);

  % Perform differential encoding for the remaining bits.
  for i = 2:length(bitstream)
    % XOR the current bit with the previous encoded bit to get the encoded bit.
    encodedBitstream(i) = bitxor(bitstream(i), encodedBitstream(i-1));
  end
end