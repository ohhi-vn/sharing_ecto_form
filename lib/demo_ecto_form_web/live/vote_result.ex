defmodule DemoEctoFormWeb.VoteResult do
  use DemoEctoFormWeb, :live_view

  alias DemoEctoForm.Ets

  def mount(_params, _session, socket) do
    votes = Ets.get_votes()
    {:ok, assign(socket, votes: votes)}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-red-600 p-10">

      <h1 class="text-4xl font-bold text-center text-white">Voted List</h1>
      <br>
      <table class="table-auto mx-auto">
        <thead>
          <tr>
            <th class="px-4 py-2 text-white">Name</th>
            <th class="px-4 py-2 text-white">Email</th>
            <th class="px-4 py-2 text-white">Phone</th>
            <th class="px-4 py-2 text-white">Voted For</th>
            <th class="px-4 py-2 text-white">Reason</th>
          </tr>
        </thead>
        <tbody>
          <%= for vote <- @votes do %>
            <tr>
              <td class="border px-4 py-2 text-white"><%= vote.name %></td>
              <td class="border px-4 py-2 text-white"><%= vote.email %></td>
              <td class="border px-4 py-2 text-white"><%= vote.phone %></td>
              <td class="border px-4 py-2 text-white"><%= vote.vote_for %></td>
              <td class="border px-4 py-2 text-white"><%= vote.reason %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end
