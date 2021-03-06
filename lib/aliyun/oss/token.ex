defmodule Sonnam.AliyunOss.Token do
  @moduledoc """
  阿里云OSS token生成
  """

  alias Sonnam.AliyunOss.Client

  @callback_body """
  filename=${object}&size=${size}&mimeType=${mimeType}&height=${imageInfo.height}&width=${imageInfo.width}
  """

  @spec get_token(
          Client.t(),
          String.t(),
          String.t(),
          integer(),
          String.t()
        ) :: {:ok, String.t()}
  def get_token(cli, bucket, upload_dir, expire_sec, callback) do
    expire =
      DateTime.now!("Etc/UTC")
      |> DateTime.add(expire_sec, :second)

    policy =
      %{
        "expiration" => DateTime.to_iso8601(expire),
        "conditions" => [["starts-with", "$key", upload_dir]]
      }
      |> Jason.encode!()
      |> String.trim()
      |> Base.encode64()

    signature =
      policy
      |> do_sign(cli.access_key_secret)

    base64_callback_body =
      %{
        "callbackUrl" => callback,
        "callbackBody" => @callback_body,
        "callbackBodyType" => "application/x-www-form-urlencoded"
      }
      |> Jason.encode!()
      |> String.trim()
      |> Base.encode64()

    %{
      "accessid" => cli.access_key_id,
      "host" => "https://#{bucket}.#{cli.endpoint}",
      "policy" => policy,
      "signature" => signature,
      "expire" => DateTime.to_unix(expire),
      "dir" => upload_dir,
      "callback" => base64_callback_body
    }
    |> Jason.encode()
  end

  defp do_sign(string_to_sign, key) do
    :hmac
    |> :crypto.mac(:sha, key, string_to_sign)
    |> Base.encode64()
  end
end
