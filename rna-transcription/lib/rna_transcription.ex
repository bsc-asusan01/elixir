defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """

  @dna_to_rna  %{?A => ?U, ?C => ?G, ?T => ?A, ?G => ?C }

  @spec to_rna([char]) :: [char]
  def to_rna(dna) do

    #Enum.map( dna, &map_lookup/1 )
    Enum.map( dna, &( @dna_to_rna[&1]) ) #
    #Enum.map( dna, fn (x) -> @dna_to_rna[x] end)

  end

end
