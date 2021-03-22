defmodule Chaton.Auth do
  alias Chaton.Auth.Admin

  @moduledoc """
  Authentication system
  """

  def add_admin(email, password) do
    %Admin{}
    |> Admin.registration_changeset(%{email: email, password: password})
    |> Chaton.Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %Admin{}}

  """
  def change_user_registration(%Admin{} = user, attrs \\ %{}) do
    Admin.registration_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Chaton.Repo.get_by(Admin, email: email)
    if Admin.valid_password?(user, password), do: user
  end

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end
end
