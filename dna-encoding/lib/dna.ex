defmodule DNA do
  @nucleotide_encode_map %{
    ?\s => 0b0000,
    ?\A => 0b0001,
    ?\C => 0b0010,
    ?\G => 0b0100,
    ?\T => 0b1000,
  }

  @nucleotide_decode_map Enum.map(@nucleotide_encode_map, fn {k,v} -> {v,k} end)
    |> Map.new()

  def encode_nucleotide(code_point), do:  Map.fetch!(@nucleotide_encode_map, code_point)

  def decode_nucleotide(encoded_code), do: Map.fetch!(@nucleotide_decode_map, encoded_code)

  def encode(dna)
  def encode([]), do: <<>>
  def encode([h | t]) do
    << encode_nucleotide(h)::4, encode(t)::bitstring >>
  end

  def decode(dna)
  def decode(<<>>), do: []
  def decode(<< h::4, t::bitstring >>) do
    [decode_nucleotide(h) | decode(t) ]
  end
end
