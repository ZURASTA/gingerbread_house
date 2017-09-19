defmodule GingerbreadHouse.Service.Repo.Migrations.Business do
    use Ecto.Migration

    def change do
        business_type = if Application.get_env(:gingerbread_house_service, GingerbreadHouse.Service.Repo, adapter: Ecto.Adapters.Postgres)[:adapter] == Ecto.Adapters.Postgres do
            GingerbreadHouse.Service.Business.TypeEnum.create_type()
            :business_type
        else
            :integer
        end

        create table(:businesses) do
            add :entity, :uuid,
                null: false

            add :type, business_type,
                    null: false

            add :name, :string,
                null: false

            add :contact, :string,
                null: false

            add :country, :char,
                size: 2,
                null: false,
                comment: "The ISO 3166-1 alpha-2 code for the country"

            add :address, :map,
                null: false

            add :additional_details, :map,
                default: "{}",
                null: false

            timestamps()
        end

        create index(:businesses, [:entity], unique: true)
    end
end
