defmodule Agenda.Schedule do
  # :commandはASTフォーマットにしている，Code.string_toquoted!を使っているから
  defstruct [:minute, :hour, :day_of_month, :month, :day_of_week, :command]

  @type year      :: non_neg_integer
  @type month     :: 1..12
  @type day       :: 1..31 
  @type hour      :: 0..23
  @type minute    :: 0..59
  @type second    :: 0..59
  @type date      :: {year, month, day}
  @type time      :: {hour, minute, second}
  @type datetime  :: {date, time}

  @spec include?(Agenda.Schedule, datetime) :: boolean
  def include?(schedule, {{year, month, day}=date, {hour, minute, _second}}) do
    #IO.puts "year = #{inspect year} , month = #{inspect month} , day = #{inspect day},  hour = #{inspect hour},  minute = #{inspect minute}"
    #IO.puts "schedule.minute = #{inspect schedule.minute}"
    #IO.puts "schedule.hour = #{inspect schedule.hour}"
    #IO.puts "schedule.day_of_week = #{inspect schedule.day_of_week}"
    #IO.puts "schedule.day_of_month = #{inspect schedule.day_of_month}"
    #IO.puts "schedule.month = #{inspect schedule.month}"

    #if Enum.any?(schedule.minute, fn(min) -> min == minute end) do
    #  IO.puts "minute true"
    #end
    #if Enum.any?(schedule.hour, fn(hr) -> hr == hour end) do
    #  IO.puts "hour true"
    #end
    #if Enum.any?(schedule.day_of_week, fn(dow) -> dow == :calendar.day_of_the_week(date) end) do
    #  IO.puts "day_of_week true"
    #else 
    #  num = :calendar.day_of_the_week(date)
    #  IO.puts "day_of_week false, day_of_week = #{num}"
    #end
    #if Enum.any?(schedule.day_of_month, fn(dom) -> dom == day end) do
    #  IO.puts "day_of_month true"
    #end
    #if Enum.any?(schedule.month, fn(mon) -> mon == month end) do
    #  IO.puts "month true"
    #end
    res = 
    [
      Enum.any?(schedule.minute, fn(min) -> min == minute end),
      Enum.any?(schedule.hour, fn(hr) -> hr == hour end),
      Enum.any?(schedule.day_of_week, fn(dow) -> dow == :calendar.day_of_the_week(date) end),
      Enum.any?(schedule.day_of_month, fn(dom) -> dom == day end),
      Enum.any?(schedule.month, fn(mon) -> mon == month end)
    ] 
    |> Enum.all?
    #IO.puts "res = #{res}"
    res
  end

  @spec execute_command(Agenda.Schedule) :: any
  def execute_command(%Agenda.Schedule{command: command}) do
    #IO.puts "command = #{inspect command}"
    spawn(fn() -> Code.eval_quoted(command) end)
  end
end

