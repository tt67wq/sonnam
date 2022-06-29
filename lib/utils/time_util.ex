defmodule Sonnam.Utils.TimeUtil do
  @moduledoc """
  时间相关工具
  """

  @doc """
  get current timestamp
  ## Example
  iex> Common.TimeTool.timestamp(:seconds)
  1534466694
  iex> Common.TimeTool.timestamp(:milli_seconds)
  1534466732335
  iex> Common.TimeTool.timestamp(:micro_seconds)
  1534466750683862
  iex> Common.TimeTool.timestamp(:nano_seconds)
  1534466778949821000
  """
  @spec timestamp(atom()) :: integer()
  def timestamp(typ \\ :seconds), do: :os.system_time(typ)

  @spec now(Calendar.time_zone()) :: {:ok, DateTime.t()}
  def now(tz \\ "Etc/UTC"), do: DateTime.now(tz)

  @spec naive_now(atom()) :: NaiveDateTime.t()
  def naive_now(typ \\ :second),
    do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(typ)

  @spec china_now() :: {:ok, DateTime.t()}
  def china_now(), do: now("Asia/Shanghai")

  # ############# ts <==> datetime #############
  @spec ts_to_datetime(integer(), Calendar.time_zone()) :: {:ok, DateTime.t()}
  def ts_to_datetime(ts, tz \\ "Asia/Shanghai") do
    ts
    |> DateTime.from_unix!()
    |> DateTime.shift_zone(tz)
  end

  @spec datetime_to_ts(DateTime.t()) :: integer()
  def datetime_to_ts(datetime) do
    datetime
    |> DateTime.shift_zone!("Etc/UTC")
    |> DateTime.to_unix()
  end

  # ############# string <==> datetime #############
  @spec datetime_to_str(DateTime.t(), String.t()) :: String.t()
  def datetime_to_str(datetime, format \\ "%Y-%m-%d %H:%M:%S"),
    do: Calendar.strftime(datetime, format)

  @spec str_to_datetime(String.t(), String.t()) :: {:ok, DateTime.t()}
  def str_to_datetime(s, shift \\ "+08:00") do
    {:ok, datetime, _} = DateTime.from_iso8601(s <> shift)
    {:ok, datetime}
  end

  # ############# naive <==> datetime #############

  @spec naive_to_datetime(NaiveDateTime.t(), Calendar.time_zone()) :: {:ok, DateTime.t()}
  def naive_to_datetime(ndt, tz \\ "Asia/Shanghai") do
    ndt
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.shift_zone(tz)
  end

  @spec datetime_to_naive(DateTime.t()) :: NaiveDateTime.t()
  def datetime_to_naive(datetime), do: DateTime.to_naive(datetime)
end
