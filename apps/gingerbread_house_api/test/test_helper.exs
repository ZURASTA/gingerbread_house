Application.ensure_all_started(:gingerbread_house_service)
Application.ensure_all_started(:ecto)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(GingerbreadHouse.Service.Repo, :manual)
