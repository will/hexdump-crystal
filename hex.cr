struct Slice(T)
  def hexdump
    self as Slice(UInt8)

    str_size = ((size / 8) + 1) * 58
    String.new(str_size) do |buffer|
      hexdump(buffer)
      {str_size, str_size}
    end
  end

  def hexdump(buffer)
    self as Slice(UInt8)

    # (((size / 8) + 1) * 58).times do |i|
    #   buffer[i] = 0x20_u8
    # end

    hex_offset = 0
    ascii_offset = 41
    each_with_index do |v, i|
      buffer[hex_offset] = to_hex(v >> 4)
      buffer[hex_offset + 1] = to_hex(v & 0x0f)
      hex_offset += 2

      buffer[ascii_offset] = (v > 31 && v < 127) ? v : '.'.ord.to_u8
      ascii_offset += 1

      if (i % 2 != 0)
        buffer[hex_offset] = 0x20_u8
        hex_offset += 1
      end

      if i % 16 == 15
        buffer[hex_offset] = 0x20_u8
        buffer[ascii_offset] = '\n'.ord.to_u8
        ascii_offset += 42
        hex_offset += 18
      end
    end

    while hex_offset % 58 < 41
      buffer[hex_offset] = 0x20_u8
      hex_offset += 1
    end

    nil
  end
end

j = ("\u{FF}abcdefghijk\5lmnopqrstuvxyzabcdefgh"*3).to_slice
j = StaticArray(UInt8, 255).new(&.to_u8).to_slice
# p j
puts j.hexstring
puts
puts j.hexdump
