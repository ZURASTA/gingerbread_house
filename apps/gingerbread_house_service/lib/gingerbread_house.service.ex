defmodule GingerbreadHouse.Service do
    @moduledoc """
      The service application for managing and verifying business
      details.
    """

    use Application

    @doc """
      Start the service application.

      By default the service will run in `:auto` setup mode, which
      will automatically create and migrate the database. To override
      this behaviour, the mode can be passed in as an argument for the
      `:setup_mode` key. The supported setup modes are: `:auto` and
      `:manual`. If using manual mode, the state of the database is
      left up to the caller.
    """
    def start(_type, args) do
        import Supervisor.Spec, warn: false

        setup_mode = args[:setup_mode] || :auto

        if setup_mode == :auto do
            prepare_db()
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

    if Mix.env == :test do
        defp prepare_db(), do: GingerbreadHouse.Service.Repo.DB.drop()
    else
        defp prepare_db(), do: :ok
    end
end
