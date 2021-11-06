defmodule Praxkit.Accounts do
  @moduledoc """
  The Accounts context. THis holds functions regarding accounts and users.
  """

  import Ecto.Query, warn: false

  import Saas.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  alias Praxkit.Repo
  alias Praxkit.Accounts.{Account, User}

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of accounts using filtrex
  filters.

  ## Examples

  iex> list_accounts(%{})
  %{accounts: [%Account{}], ...}
  """
  def paginate_accounts(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:accounts), params["account"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_accounts(filter, params) do
      {:ok,
        %{
          accounts: page.entries,
          page_number: page.page_number,
          page_size: page.page_size,
          total_pages: page.total_pages,
          total_entries: page.total_entries,
          distance: @pagination_distance,
          sort_field: sort_field,
          sort_direction: sort_direction
        }
      }
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_accounts(filter, params) do
    Repo.put_skip_account_id(true) # Because of billing_customer has the field account_id

    records =
      from(a in Account, preload: [:billing_customer])
      |> Filtrex.query(filter)
      |> order_by(^sort(params))
      |> paginate(Repo, params, @pagination)

    Repo.put_skip_account_id(false) # Because of billing_customer has the field account_id

    records
  end

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account by token.

  Returns nil if the Account does not exist.

  ## Examples

      iex> get_account_by_token(123)
      %Account{}

      iex> get_account_by_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account_by_token!(token), do: Repo.get_by!(Account, token: token)

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.registration_changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers()
  end

  def notify_subscribers({:ok, %{users: [user|_]} = account} = result) do
    Phoenix.PubSub.broadcast(Praxkit.PubSub, "account_created", %{account: account, email: user.email})
    result
  end

  def notify_subscribers(result), do: result

  def subscribe_on_account_created do
    Phoenix.PubSub.subscribe(Praxkit.PubSub, "account_created")
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account_registration(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account_registration(%Account{} = account, attrs \\ %{}) do
    Account.registration_changeset(account, attrs)
    |> Ecto.Changeset.put_assoc(:users, [change_user_registration(%User{})])
  end


  @doc """
  Returns the list of users for an account.

  ## Examples

      iex> list_users(account)
      [%User{}, ...]

  """
  def list_users(account) do
    Repo.all(User, account_id: account.id)
  end

  @doc """
  Paginate the list of users using filtrex
  filters.

  ## Examples

  iex> paginate_users(%{})
  %{users: [%Account{}], ...}
  """
  def paginate_users(account, params \\ %{}) do
    Repo.put_account_id(account.id)

    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:users), params["user"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_users(filter, params) do
      {:ok,
        %{
          users: page.entries,
          page_number: page.page_number,
          page_size: page.page_size,
          total_pages: page.total_pages,
          total_entries: page.total_entries,
          distance: @pagination_distance,
          sort_field: sort_field,
          sort_direction: sort_direction
        }
      }
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_users(filter, params) do
    User
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Gets a single user for an account.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(account, 123)
      %User{}

      iex> get_user!(account, 456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(account, id), do: Repo.get!(User, id, account_id: account.id)

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password) do
    with %User{} = user <- Repo.get_by(User, [email: email], [skip_account_id: true]),
         %Ecto.Changeset{} = changeset <- Ecto.Changeset.cast(user, %{}, []),
         %Ecto.Changeset{valid?: true} <- User.validate_current_password(changeset, password) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Preload account for a user or a list of users.

  ## Examples

      iex> with_account(%User{})
      %User{account: %Account{}}

  """
  def with_account(user_or_users) do
    user_or_users
    |> Repo.preload(:account)
  end

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(account, %{field: value})
      {:ok, %User{}}

      iex> register_user(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(account, attrs) do
    account
    |> Ecto.build_assoc(:users)
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    # User.registration_changeset(user, attrs)
    User.changeset(user, attrs)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs)
  end

  @doc """
  Updates the email in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, %{current_password: "valid password", password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, %{current_password: "invalid password", password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  defp filter_config(:accounts) do
    defconfig do
      text :name
      text :token
    end
  end

  defp filter_config(:users) do
    defconfig do
      text :name
      text :token
    end
  end
end
