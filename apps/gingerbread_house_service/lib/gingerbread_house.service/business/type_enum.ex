import EctoEnum

if Application.get_env(:gingerbread_house_service, GingerbreadHouse.Service.Repo, adapter: Ecto.Adapters.Postgres)[:adapter] == Ecto.Adapters.Postgres do
    quote do: defenum GingerbreadHouse.Service.Business.TypeEnum, :business_type, [:individual, :company]
else
    quote do: defenum GingerbreadHouse.Service.Business.TypeEnum, [individual: 0, company: 1]
end
|> Code.eval_quoted()
