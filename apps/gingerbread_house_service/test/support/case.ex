defmodule GingerbreadHouse.Service.Case do
    @moduledoc """
      This module defines the test case to be used by all tests.
    """

    use ExUnit.CaseTemplate

    using do
        quote do
            import Ecto
            import Ecto.Changeset
            import Ecto.Query
            use Defecto, repo: GingerbreadHouse.Service.Repo
        end
    end

    setup tags do
        :ok = Ecto.Adapters.SQL.Sandbox.checkout(GingerbreadHouse.Service.Repo)

        unless tags[:async] do
            Ecto.Adapters.SQL.Sandbox.mode(GingerbreadHouse.Service.Repo, { :shared, self() })
        end

        :ok
    end
end
