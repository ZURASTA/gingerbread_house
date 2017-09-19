defmodule GingerbreadHouse.Service do
    @moduledoc false

    use Application

    def start(_type, args) do
        import Supervisor.Spec, warn: false

        setup_mode = args[:setup_mode] || :auto

        if setup_mode == :auto do
            if Mix.env == :test do
                GingerbreadHouse.Service.Repo.DB.drop()
            end
            GingerbreadHouse.Service.Repo.DB.create()
        end

        children = [
            GingerbreadHouse.Service.Repo,
            GingerbreadHouse.Service.Business
        ]

        opts = [strategy: :one_for_one, name: GingerbreadHouse.Service.Supervisor]
        supervisor = Supervisor.start_link(children, opts)

        if setup_mode == :auto do
            GingerbreadHouse.Service.Repo.DB.migrate()
        end

        supervisor
    end
end
