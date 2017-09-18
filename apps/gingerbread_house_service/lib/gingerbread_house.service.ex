defmodule GingerbreadHouse.Service do
    @moduledoc false

    use Application

    def start(_type, _args) do
        import Supervisor.Spec, warn: false

        if Mix.env == :test do
            GingerbreadHouse.Service.Repo.DB.drop()
        end
        GingerbreadHouse.Service.Repo.DB.create()

        children = [
            GingerbreadHouse.Service.Repo,
            GingerbreadHouse.Service.Business
        ]

        opts = [strategy: :one_for_one, name: GingerbreadHouse.Service.Supervisor]
        supervisor = Supervisor.start_link(children, opts)

        GingerbreadHouse.Service.Repo.DB.migrate()

        supervisor
    end
end
