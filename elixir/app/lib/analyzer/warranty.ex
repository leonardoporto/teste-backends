defmodule Analyzer.Warranty do
  @moduledoc """
  Responsible for Warranty rules
  """
  defstruct id: nil, proposal_id: nil, value: nil, province: nil

  def is_valid?(warranty) do
    is_valid_province?(warranty)
  end

  def is_valid_province?(%{province: province})  do
    !Enum.member?(["RS", "SC", "PR"], province)
  end

end
