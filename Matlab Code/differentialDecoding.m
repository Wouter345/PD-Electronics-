function decodedBitstream = differentialDecoding(encodedBitstream)
  % Initialize the decoded bitstream with the first bit of the encoded stream.
  decodedBitstream = encodedBitstream(1);

  % Perform differential decoding for the remaining bits.
  for i = 2:length(encodedBitstream)
    % XOR the current encoded bit with the previous decoded bit to get the original bit.
    decodedBitstream(i) = bitxor(encodedBitstream(i), encodedBitstream(i-1));
  end
end