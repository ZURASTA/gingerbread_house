defmodule GingerbreadHouse.Service.Business do
    @moduledoc """
      Handles the management of business details.
    """
    use GenServer
    alias GingerbreadHouse.BusinessDetails
    alias GingerbreadHouse.Service.Business
    require Logger
    import Ecto.Query

    def child_spec(_args) do
        %{
            id: __MODULE__,
            start: { __MODULE__, :start_link, [] },
            type: :worker
        }
    end

    def start_link() do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def handle_call({ :create, { entity, details }, :business }, from, state) do
        Task.start(fn -> GenServer.reply(from, Business.create(entity, details)) end)
        { :noreply, state }
    end
    def handle_call({ :update, { entity, details }, :business }, from, state) do
        Task.start(fn -> GenServer.reply(from, Business.update(entity, details)) end)
        { :noreply, state }
    end
    def handle_call({ :delete, { entity }, :business }, from, state) do
        Task.start(fn -> GenServer.reply(from, Business.delete(entity)) end)
        { :noreply, state }
    end
    def handle_call({ :get, { entity }, :business }, from, state) do
        Task.start(fn -> GenServer.reply(from, Business.get(entity)) end)
        { :noreply, state }
    end
    def handle_call({ :create, { entity, details }, :representative }, from, state) do
        Task.start(fn -> GenServer.reply(from, Business.Representative.create(entity, details)) end)
        { :noreply, state }
    end
    def handle_call({ :update, { entity, id, details }, :representative }, from, state) do
        Task.start(fn -> GenServer.reply(from, Business.Representative.update(entity, id, details)) end)
        { :noreply, state }
    end
    def handle_call({ :delete, { entity, id }, :representative }, from, state) do
        Task.start(fn -> GenServer.reply(from, Business.Representative.delete(entity, id)) end)
        { :noreply, state }
    end
    def handle_call({ :get, { entity, id }, :representative }, from, state) do
        Task.start(fn -> GenServer.reply(from, Business.Representative.get(entity, id)) end)
        { :noreply, state }
    end
    def handle_call({ :all, { entity }, :representative }, from, state) do
        Task.start(fn -> GenServer.reply(from, Business.Representative.all(entity)) end)
        { :noreply, state }
    end

    @type uuid :: String.t

    @doc """
      Create a new business entry.

      The entity should be the unique ID to reference this business.
    """
    @spec create(uuid, struct()) :: :ok | { :error, String.t }
    def create(entity, details) do
        #todo: maybe add validated field, and set it to false, where a worker passes it along and attempts to validate it?
        case GingerbreadHouse.Service.Repo.insert(Business.Model.insert_changeset(%Business.Model{}, Map.put(BusinessDetails.to_map(details), :entity, entity))) do
            { :ok, _ } -> :ok
            { :error, changeset } ->
                Logger.debug("create business: #{inspect(changeset.errors)}")
                { :error, "Failed to create business" }
        end
    end

    @doc """
      Update a business entry.

      To update only certain business details, leave the other details for the business as `nil`.
    """
    @spec update(uuid, struct()) :: :ok | { :error, String.t }
    def update(entity, details) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :update, { :ok, _ } } <- { :update, GingerbreadHouse.Service.Repo.update(Business.Model.update_changeset(business, BusinessDetails.to_map(details))) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :update, _ } -> { :error, "Failed to update business info" }
        end
    end

    @doc """
      Delete a business entry.
    """
    @spec delete(uuid) :: :ok | { :error, String.t }
    def delete(entity) do
        with { :business, business = %Business.Model{} } <- { :business, GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) },
             { :delete, { :ok, _ } } <- { :delete, GingerbreadHouse.Service.Repo.delete(business) } do
                :ok
        else
            { :business, _ } -> { :error, "Business does not exist" }
            { :delete, _ } -> { :error, "Failed to delete business info" }
        end
    end

    @doc """
      Get the details of a given business entry.
    """
    @spec get(uuid) :: { :ok, struct() } | { :error, String.t }
    def get(entity) do
        case GingerbreadHouse.Service.Repo.get_by(Business.Model, entity: entity) do
            business = %Business.Model{} -> { :ok, BusinessDetails.new(business) }
            _ -> { :error, "Business does not exist" }
        end
    end
end
