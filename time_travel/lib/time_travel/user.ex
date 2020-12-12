defmodule TimeTravel.User do
  def get_user_by_session_token(_token) do
    %TimeTravel.Schemas.User{name: "ted", email: "bundy@aol.net"}
  end
end
