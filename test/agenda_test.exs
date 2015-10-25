defmodule Agenda.Schedule do
  # :commandはASTフォーマットにしている，Code.string_toquoted!を使っているから
  defstruct [:minute, :hour, :day_of_month, :month, :day_of_week, :command]
end

defmodule Agenda.Parser do
  def parse(schedule_string) do
    ## iex(5)> [minute, hour, day_of_month, month, day_of_week | command_bits] = String.split("1 2 3 4 5 Module.function(:arg2, :arg3)")
    ## ["1", "2", "3", "4", "5", "Module.function(:arg2,", ":arg3)"]
    ## iex(6)> command_bits
    ## ["Module.function(:arg2,", ":arg3)"]
    [minute, hour, day_of_month, month, day_of_week | command_bits] = String.split(schedule_string)
    command_string = Enum.join(command_bits)
    {:ok, command} = Code.string_to_quoted(command_string)
    parse(minute, hour, day_of_month, month, day_of_week, command)
  end
  def parse(minute, hour, day_of_month, month, day_of_week, command) do
    %Agenda.Schedule{minute: parse_pattern(minute, 0..59), hour: parse_pattern(hour, 0..23), day_of_month: parse_pattern(day_of_month, 1..31), month: parse_pattern(month, 1..12), day_of_week: parse_pattern(day_of_week, 0..6), command: command}
  end

  def parse_pattern("*", range) do
    Enum.to_list(range)
  end

  def parse_pattern("*/"<> modulo, range) do
    modulo = String.to_integer(modulo)
    Enum.filter(range, fn(i) -> rem(i, modulo) == 0 end)
  end

  def parse_pattern(pattern, _range) do
    String.split(pattern, ",")
    |> Enum.map(fn(unit) -> String.to_integer(unit) end)
  end

end

defmodule AgendaTest do
  use ExUnit.Case
  doctest Agenda

  # @command などの設定はtestの中にしては行けない
  @command  Code.string_to_quoted!("Module.function(:arg1)")
  @command2  Code.string_to_quoted!("Module.function(:arg2, :arg3)")

  test "parsing a schedule string" do
    assert Agenda.Parser.parse("0 0 0 0 0 Module.function(:arg1)") == %Agenda.Schedule{minute: [0], hour: [0], day_of_month: [0], month: [0], day_of_week: [0], command: @command}
    assert Agenda.Parser.parse("1 0 0 0 0 Module.function(:arg1)") == %Agenda.Schedule{minute: [1], hour: [0], day_of_month: [0], month: [0], day_of_week: [0], command: @command}
    assert Agenda.Parser.parse("1 2 3 4 5 Module.function(:arg1)") == %Agenda.Schedule{minute: [1], hour: [2], day_of_month: [3], month: [4], day_of_week: [5], command: @command}
    assert Agenda.Parser.parse("1 2 3 4 5 Module.function(:arg2, :arg3)") == %Agenda.Schedule{minute: [1], hour: [2], day_of_month: [3], month: [4], day_of_week: [5], command: @command2}
    assert Agenda.Parser.parse("1 2,6 3 4 5 Module.function(:arg2, :arg3)") == %Agenda.Schedule{minute: [1], hour: [2,6], day_of_month: [3], month: [4], day_of_week: [5], command: @command2}

  end
  
  test "parsing a wildcard" do
    assert Agenda.Parser.parse("1 2,6 3 4 * Module.function(:arg2, :arg3)") == %Agenda.Schedule{minute: [1], hour: [2,6], day_of_month: [3], month: [4], day_of_week: [0,1,2,3,4,5,6], command: @command2}
  end

  test "parsing patter like 'every five minutes'" do
    assert Agenda.Parser.parse("*/5 2,6 3 4 * Module.function(:arg2, :arg3)") == %Agenda.Schedule{minute: [0,5,10,15,20,25,30,35,40,45,50,55], hour: [2,6], day_of_month: [3], month: [4], day_of_week: [0,1,2,3,4,5,6], command: @command2}
  end
end
