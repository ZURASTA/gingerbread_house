if Application.fetch_env(:gingerbread_house_service, GingerbreadHouse.Service.Repo) == :error do
    Application.put_env(:gingerbread_house_service, GingerbreadHouse.Service.Repo, case Mix.env do
        :dev -> [
            adapter: Ecto.Adapters.Postgres,
            username: "postgres",
            password: "postgres",
            database: "gingerbread_house_service_dev",
            hostname: "localhost",
            pool_size: 10
        ]
        :test -> [
            adapter: Ecto.Adapters.Postgres,
            username: "postgres",
            password: "postgres",
            database: "gingerbread_house_service_test",
            hostname: "localhost",
            pool: Ecto.Adapters.SQL.Sandbox
        ]
        _ -> nil
    end)
end

defmodule GingerbreadHouse.Service.Repo do
    use Ecto.Repo, otp_app: :gingerbread_house_service

    def child_spec(_args) do
        %{
            id: __MODULE__,
            start: { __MODULE__, :start_link, [] },
            type: :supervisor
        }
    end
end
