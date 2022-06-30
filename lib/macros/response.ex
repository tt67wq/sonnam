defmodule Sonnam.Macros.Response do
  defmacro __using__(_opts) do
    quote do
      require Logger

      def reply_succ(conn, data \\ "success") do
        Logger.debug(%{"data" => data})
        json(conn, %{code: 200, data: data})
      end

      def reply_err(conn, msg \\ "Internal server error", code \\ 400)

      def reply_err(conn, msg, code) do
        Logger.error(%{"msg" => msg, "code" => code})

        json(conn, %{code: code, msg: msg})
      end
    end
  end
end

defmodule Sonnam.Macros.BinResponse do
  defmacro __using__(_opts) do
    quote do
      require Logger

      def bin_succ(conn, data) when is_binary(data) do
        Logger.debug(%{"data" => inspect(data)})

        conn
        |> Plug.Conn.put_resp_content_type("application/octet-stream")
        |> send_resp(200, data)
      end

      def bin_err(conn, msg \\ "Internal server error", code \\ 400)

      def bin_err(conn, msg, code) do
        Logger.error(%{"msg" => msg, "code" => code})

        conn
        |> Plug.Conn.put_resp_content_type("application/octet-stream")
        |> Plug.Conn.send_resp(code, msg)
      end
    end
  end
end
