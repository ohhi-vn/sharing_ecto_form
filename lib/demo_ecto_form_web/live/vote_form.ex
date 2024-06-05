defmodule DemoEctoFormWeb.VoteForm do
  use DemoEctoFormWeb, :live_view

  alias DemoEctoForm.{Vote, Ets}

  import Ecto.Changeset

  def mount(%{"user" => user} = _params, _session, socket) do
    changeset =  Ets.get_state(user)

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(user: user)
      |> assign(recovered: nil)

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(changeset: Vote.changeset(%Vote{}))
      |> assign(user: nil)

    {:ok, socket}
  end


  def handle_event("validate", %{"vote" => vote_params}, socket) do
    changeset =
       Vote.changeset(%DemoEctoForm.Vote{}, vote_params)
       |> Map.put(:action, :validate)

    IO.inspect(changeset)

    if socket.assigns.user != nil do
      Ets.set_state(socket.assigns.user, changeset)
      IO.puts "saved state for #{inspect(socket.assigns.user)}"
    end

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("submit", %{"vote" => vote_params}, socket) do
    changeset =
      Vote.changeset(%Vote{}, vote_params)
      |> Map.put(:action, :validate)


    IO.puts "Vote changeset: #{inspect(changeset, [pretty: true, struct: false])}"

    if changeset.valid? do
      data = apply_action!(changeset, :update)

      IO.puts "Vote data: #{inspect(data, [pretty: true, struct: false])}"
      Ets.add_vote(data)

      if socket.assigns.user != nil do
        Ets.remove_state(socket.assigns.user)
      end

      socket =
        socket
        |> put_flash(:info, "You voted for #{data.vote_for}!")
        |> redirect(to: ~p"/result")

      {:noreply, socket}
    else
      {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("recover_form",  _params, socket) do
    IO.puts "recovering form"
    changeset = socket.assigns.changeset

    invalid_fields = changeset.errors |> Enum.map(fn {field, _} -> field end)
    IO.inspect(invalid_fields)
    filtered_correct_fields = Map.drop(changeset.changes, invalid_fields)
    IO.inspect(filtered_correct_fields)

    changeset =
      Vote.changeset(%Vote{})
      |> Map.put(:changes, filtered_correct_fields)

    IO.puts "Recovered changeset: #{inspect(changeset, [pretty: true, struct: false])}"

    socket =
      socket
      |> assign(changeset: changeset)
      |> put_flash(:info, "Recovered form data, please add invalid fields again")

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-red-600 text-white rounded-md">
    <br>
    <.form
      id="votes-form"
      :let={f} for={@changeset}
      phx-change="validate"
      phx-submit="submit"
      phx-auto-recover="recover_form"
      class="flex flex-col max-w-md mx-auto mt-8"
    >
     <h1 class="text-4xl font-bold text-center" phx-click="crash_me">Make Elixir Great NOW!</h1>
     <br>
      <.input field={f[:name]} placeholder="Nguyen Van A" id="votes-name" label="Full Name" />
      <br>
      <.input field={f[:email]} placeholder="example@mail.com" id="votes-email" label="Email"/>
      <br>
      <.input  field={f[:phone]} placeholder="+8498888888" id="votes-phone" label="Phone"/>
      <br>
      <.input  field={f[:vote_for]} placeholder="Candidate's name" id="votes-vote_for" label="Vote for"/>
      <br>
      <.input  field={f[:reason]} placeholder="Nhiều tiền để làm gì?" id="vote-reason" label="Reason(optional)" />
      <br><br><br>
      <.button type="submit">Vote!</.button>
      <br><br>
    </.form>
    </div>
    """
  end
end
