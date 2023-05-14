defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    do_palette_bit_size(color_count, 1)
  end

  defp do_palette_bit_size(color_count, bits) do
    if Integer.pow(2, bits) >= color_count do
      bits
    else
      do_palette_bit_size(color_count, bits + 1)
    end
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0b00::2, 0b01::2, 0b10::2, 0b11::2>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    bits_needed = palette_bit_size(color_count)
    <<pixel_color_index::size(bits_needed), picture::bitstring>>
  end

  def get_first_pixel(<<>>, _color_count), do: nil
  def get_first_pixel(picture, color_count) do
    bits = palette_bit_size(color_count)
    <<first::size(bits), _rest::bitstring>> = picture
    first
  end
  
  def drop_first_pixel(<<>>, _color_count), do: <<>>
  def drop_first_pixel(picture, color_count) do
    bits = palette_bit_size(color_count)
    <<_first::size(bits), rest::bitstring>> = picture
    rest
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
