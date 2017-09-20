defmodule GingerbreadHouse.Service.Repo do
    @app :gingerbread_house_service
    GingerbreadHouse.Service.Repo.Config.setup(@app, __MODULE__)
    use Ecto.Repo, otp_app: @app

    def child_spec(_args) do
        %{
            id: __MODULE__,
            start: { __MODULE__, :start_link, [] },
            type: :supervisor
        }
    end

    @on_load :setup_config
    defp setup_config() do
        GingerbreadHouse.Service.Repo.Config.setup(@app, __MODULE__)
        :ok
    end
end
