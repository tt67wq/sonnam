defmodule Sonnam.Utils.CryptoUtil do
  @moduledoc """
  加密工具
  """

  @doc """
  md5
  """
  @deprecated """
  use Sonnam.Crypto module instead
  """
  @spec md5(String.t()) :: binary()
  def md5(plaintext), do: :crypto.hash(:md5, plaintext)

  @doc """
  sha1
  """
  @deprecated """
  use Sonnam.Crypto module instead
  """
  @spec sha(String.t()) :: binary()
  def sha(plaintext), do: :crypto.hash(:sha, plaintext)

  @doc """
  sha256
  """
  @deprecated """
  use Sonnam.Crypto module instead
  """
  @spec sha256(String.t()) :: binary()
  def sha256(plaintext), do: :crypto.hash(:sha256, plaintext)

  @doc """
  generate random string
  ## Example

  iex(17)> Common.Crypto.random_string 16
  "2jqDlUxDuOt-qyyZ"
  """
  @deprecated """
  use Sonnam.Crypto module instead
  """
  @spec random_string(integer()) :: String.t()
  def random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  @doc """
  generate short random id

  ## Examples

  iex> generate_id("H")
  "H68203790HX446F"
  """
  @deprecated """
  use Sonnam.Crypto module instead
  """
  @spec generate_id(String.t()) :: String.t()
  def generate_id(prefix) do
    mid =
      1..8
      |> Enum.map(fn _ -> Enum.random(0..9) end)
      |> Enum.join()

    "#{prefix}#{mid}#{gen_reference()}"
  end

  defp gen_reference() do
    min = String.to_integer("100000", 36)
    max = String.to_integer("ZZZZZZ", 36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end

  #### ssl tools
  defp decode_public(nil), do: nil

  defp decode_public(pem) do
    [{:Certificate, der_bin, :not_encrypted}] = :public_key.pem_decode(pem)
    der_bin
  end

  defp decode_private(pem) do
    [{type, der_bin, :not_encrypted}] = :public_key.pem_decode(pem)
    {type, der_bin}
  end

  @spec load_ssl(Keyword.t()) :: [any()]
  @deprecated """
  use Sonnam.Crypto module instead
  """
  def load_ssl([]), do: []

  def load_ssl(ssl) do
    ssl = Enum.into(ssl, %{})

    [
      cacerts: ssl.ca_cert |> decode_public() |> List.wrap(),
      cert: ssl.cert |> decode_public(),
      key: ssl.key |> decode_private()
    ]
    |> Enum.reject(fn {_k, v} -> v == nil end)
  end

  @doc """
  map按照key字典序列排列并用&链接，value为空串，map，list，非string的binary等不参与

  * params - map
  * case_sensetive - 是否大小写敏感

  ## Examples

  iex> params = %{"a" => 1, "B" => "2", "c" => "", "d" => [], "e" => %{}}
  %{"a" => 1, "B" => "2", "c" => "", "d" => [], "e" => %{}}
  iex> Common.Format.sort_and_concat(params)
  "a=1&B=2"
  iex> Common.Format.sort_and_concat(params, true)
  "B=2&a=1"
  """
  @spec sort_and_concat(map()) :: String.t()
  @deprecated """
  use Sonnam.Crypto module instead
  """
  def sort_and_concat(params, case_sensitive \\ false)

  def sort_and_concat(params, true) do
    params
    |> Map.to_list()
    |> Enum.filter(fn {_, y} -> y != "" and valid_value(y) end)
    |> Enum.sort(fn {x, _}, {y, _} -> x < y end)
    |> Enum.map(fn {x, y} -> "#{x}=#{y}" end)
    |> Enum.join("&")
  end

  def sort_and_concat(params, false) do
    params
    |> Map.to_list()
    |> Enum.filter(fn {_, y} -> y != "" and valid_value(y) end)
    |> Enum.sort(fn {x, _}, {y, _} ->
      String.downcase(to_string(x)) < String.downcase(to_string(y))
    end)
    |> Enum.map(fn {x, y} -> "#{x}=#{y}" end)
    |> Enum.join("&")
  end

  defp valid_value(value), do: String.valid?(value) or is_integer(value) or is_float(value)
end
