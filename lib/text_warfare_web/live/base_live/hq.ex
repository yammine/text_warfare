defmodule TextWarfareWeb.BaseLive.HQ do
  use TextWarfareWeb, :live_view

  alias TextWarfare.Game

  def mount(_params, session, socket) do
    current_user = TextWarfare.Accounts.get_user_by_session_token(session["user_token"])
    base = Game.get_base_by_user_id!(current_user.id)

    {:ok, assign(socket, base: base)}
  end

  def render(assigns) do
    ~L"""
    <table>
    <thead>
     <tr>
      <th>Land</th>
      <th>Money</th>
    </tr>
    </thead>
    <tbody id="bases">
      <tr id="base-<%= @base.id %>">
        <td><%= @base.land %> ft²</td>
        <td>$ <%= @base.money %></td>
      </tr>
    </tbody>
    </table>
    """
  end
end
