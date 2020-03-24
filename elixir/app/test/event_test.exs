defmodule Analyzer.Event.Test do
  use ExUnit.Case, async: true

  alias Analyzer.Event

  test "should receive a new event" do
    tests = [
      %{
        line:
          "7898ce65-bc90-47fb-8784-a3cd43a0e283,proponent,added,2019-11-11T14:28:01Z,50cedd7f-44fd-4651-a4ec-f55c742e3477,de92d973-15b4-4d69-98e4-c2d93eb590e6,Minh Batz,53,226014.83,true",
        result: "7898ce65-bc90-47fb-8784-a3cd43a0e283"
      },
      %{
        line:
          "72ff1d14-756a-4549-9185-e60e326baf1b,proposal,created,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,1141424.0,240",
        result: "72ff1d14-756a-4549-9185-e60e326baf1b"
      },
      %{
        line:
          "450951ee-a38d-475c-ac21-f22b4566fb29,warranty,added,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,c8753500-1982-4003-8287-3b46c75d4803,3413113.45,DF",
        result: "450951ee-a38d-475c-ac21-f22b4566fb29"
      }
    ]

    Enum.each(tests, fn test ->
      event = Event.receive(test.line)
      assert event.id == test.result
    end)
  end

  # @tag :only
  test "should parser data event" do
    tests = [
      %{
        line:
          "72ff1d14-756a-4549-9185-e60e326baf1b,proposal,created,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,1141424.0,240",
        result: "80921e5f-4307-4623-9ddb-5bf826a31dd7"
      },
      %{
        line:
          "72ff1d14-756a-4549-9185-e60e326baf1b,proposal,updated,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,1141424.0,240",
        result: "80921e5f-4307-4623-9ddb-5bf826a31dd7"
      },
      %{
        line:
          "72ff1d14-756a-4549-9185-e60e326baf1b,proposal,deleted,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7",
        result: "80921e5f-4307-4623-9ddb-5bf826a31dd7"
      },
      %{
        line:
          "450951ee-a38d-475c-ac21-f22b4566fb29,warranty,added,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,c8753500-1982-4003-8287-3b46c75d4803,3413113.45,DF",
        result: "c8753500-1982-4003-8287-3b46c75d4803"
      },
      %{
        line:
          "450951ee-a38d-475c-ac21-f22b4566fb29,warranty,updated,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,c8753500-1982-4003-8287-3b46c75d4803,3413113.45,DF",
        result: "c8753500-1982-4003-8287-3b46c75d4803"
      },
      %{
        line:
          "450951ee-a38d-475c-ac21-f22b4566fb29,warranty,deleted,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,c8753500-1982-4003-8287-3b46c75d4803",
        result: "c8753500-1982-4003-8287-3b46c75d4803"
      },
      %{
        line:
          "6fe55df2-e259-40c1-8ffd-e0f049f7a7cb,proponent,added,2019-11-11T14:28:01Z,51a41350-d105-4423-a9cf-5a24ac46ae84,4d475987-e27a-46fd-946c-236ea33c4d09,Earle Leffler V,45,73279.19,true",
        result: "4d475987-e27a-46fd-946c-236ea33c4d09"
      },
      %{
        line:
          "6fe55df2-e259-40c1-8ffd-e0f049f7a7cb,proponent,updated,2019-11-11T14:28:01Z,51a41350-d105-4423-a9cf-5a24ac46ae84,4d475987-e27a-46fd-946c-236ea33c4d09,Earle Leffler V,45,73279.19,true",
        result: "4d475987-e27a-46fd-946c-236ea33c4d09"
      },
      %{
        line:
          "450951ee-a38d-475c-ac21-f22b4566fb29,proponent,deleted,2019-11-11T14:28:01Z,51a41350-d105-4423-a9cf-5a24ac46ae84,4d475987-e27a-46fd-946c-236ea33c4d09",
        result: "4d475987-e27a-46fd-946c-236ea33c4d09"
      }
    ]

    Enum.each(tests, fn test ->
      event = Analyzer.Event.receive(test.line)

      cond do
        event.type == "proposal" and (event.action == "created" or event.action == "updated") ->
          assert event.data.id == test.result

        event.type == "proposal" and event.action == "deleted" ->
          assert event.data == test.result

        event.type == "warranty" and (event.action == "added" or event.action == "updated") ->
          assert event.data.id == test.result

        event.type == "warranty" and event.action == "deleted" ->
          assert event.data.id == test.result

        event.type == "proponent" and (event.action == "added" or event.action == "updated") ->
          assert event.data.id == test.result

        event.type == "proponent" and event.action == "deleted" ->
          assert event.data.id == test.result
      end
    end)
  end
end
