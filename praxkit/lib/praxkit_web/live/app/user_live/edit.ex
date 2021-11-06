defmodule PraxkitWeb.App.UserLive.Edit do
  use PraxkitWeb, :live_view

  alias Praxkit.Accounts

  on_mount PraxkitWeb.App.InitAssigns

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.user

    {
      :ok,
      socket
      |> assign(:email_changeset, Accounts.change_user_email(user))
      |> assign(:password_changeset, Accounts.change_user_password(user))
    }
  end

  @impl true
  def handle_event("validate_email", %{"user" => user_params}, socket) do
    email_changeset =
      socket.assigns.user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :email_changeset, email_changeset)}
  end

  def handle_event("save_email", %{"user" => user_params, "current_password" => current_password}, socket) do
    case Accounts.apply_user_email(socket.assigns.user, current_password, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Email updated successfully")
         |> push_redirect(to: Routes.app_user_edit_path(socket, :edit))}

      {:error, %Ecto.Changeset{} = email_changeset} ->
        {:noreply, assign(socket, :email_changeset, email_changeset)}
    end
  end

  def handle_event("save_password", %{"user" => user_params}, socket) do
    case Accounts.update_user_password(socket.assigns.user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password updated successfully")
         |> push_redirect(to: Routes.app_user_edit_path(socket, :edit))}

      {:error, %Ecto.Changeset{} = password_changeset} ->
        {:noreply, assign(socket, :password_changeset, password_changeset)}
    end
  end
end
