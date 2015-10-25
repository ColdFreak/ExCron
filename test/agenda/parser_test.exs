defmodule Agenda.ParserTest do
  use ExUnit.Case
  doctest Agenda

  # @command などの設定はtestの中にしては行けない
  @command  Code.string_to_quoted!("Module.function(:arg1)")
  @command2  Code.string_to_quoted!("Module.function(:arg2, :arg3)")

  test "parsing a schedule string" do
    assert Agenda.Parser.parse("0 0 0 0 1 Module.function(:arg1)") == %Agenda.Schedule{minute: [0], hour: [0], day_of_month: [0], month: [0], day_of_week: [1], command: @command}
    assert Agenda.Parser.parse("1 0 0 0 1 Module.function(:arg1)") == %Agenda.Schedule{minute: [1], hour: [0], day_of_month: [0], month: [0], day_of_week: [1], command: @command}
    assert Agenda.Parser.parse("1 2 3 4 5 Module.function(:arg1)") == %Agenda.Schedule{minute: [1], hour: [2], day_of_month: [3], month: [4], day_of_week: [5], command: @command}
    assert Agenda.Parser.parse("1 2 3 4 5 Module.function(:arg2, :arg3)") == %Agenda.Schedule{minute: [1], hour: [2], day_of_month: [3], month: [4], day_of_week: [5], command: @command2}
    assert Agenda.Parser.parse("1 2,6 3 4 5 Module.function(:arg2, :arg3)") == %Agenda.Schedule{minute: [1], hour: [2,6], day_of_month: [3], month: [4], day_of_week: [5], command: @command2}

  end
  
  test "parsing a wildcard" do
    assert Agenda.Parser.parse("1 2,6 3 4 * Module.function(:arg2, :arg3)") == %Agenda.Schedule{minute: [1], hour: [2,6], day_of_month: [3], month: [4], day_of_week: [1,2,3,4,5,6,7], command: @command2}
  end

  test "parsing patter like 'every five minutes'" do
    assert Agenda.Parser.parse("*/5 2,6 3 4 * Module.function(:arg2, :arg3)") == %Agenda.Schedule{minute: [0,5,10,15,20,25,30,35,40,45,50,55], hour: [2,6], day_of_month: [3], month: [4], day_of_week: [1,2,3,4,5,6,7], command: @command2}
  end
end
