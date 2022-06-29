defmodule Sonnam.Macros.Response do
  defmacro __using__(_opts) do
    quote do
      require Logger
      defguard is_struct(term) when is_map(term) and :erlang.is_map_key(:__struct__, term)

      @spec reducer({any, any}, map) :: map
      defp reducer({k, v}, map) when is_map(v), do: Map.put(map, k, prune_nils(v))
      defp reducer({k, v}, map) when is_list(v), do: Map.put(map, k, prune_nils(v))
      defp reducer({_k, v}, map) when is_nil(v), do: map
      defp reducer({k, v}, map), do: Map.put(map, k, v)

      @spec prune_nils(term()) :: term()
      def prune_nils(s) when is_struct(s),
        do: s |> Map.from_struct() |> Enum.reduce(%{}, &reducer/2)

      def prune_nils(m) when is_map(m), do: Enum.reduce(m, %{}, &reducer/2)
      def prune_nils(m) when is_list(m), do: Enum.map(m, &prune_nils(&1))
      def prune_nils(m), do: m

      def reply_succ(conn, data \\ "success") do
        Logger.debug(%{"data" => data})

        json(conn, %{code: 200, data: prune_nils(data)})
      end

      def reply_err(conn, msg \\ "Internal server error", code \\ 400)

      def reply_err(conn, msg, code) do
        Logger.error(%{"msg" => msg, "code" => code})

        json(conn, %{code: code, msg: msg})
      end
    end
  end
end
