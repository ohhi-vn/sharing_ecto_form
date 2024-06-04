defmodule DemoEctoFormWeb.CandidateForm do
  use DemoEctoFormWeb, :live_view

  alias DemoEctoForm.{Candidate, Ets}

  import Ecto.Changeset

  def mount(_params, _session, socket) do
    changeset = Candidate.changeset(%Candidate{})

    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("validate", %{"candidate" => candidate_params}, socket) do
    changeset =
      %Candidate{}
      |> Candidate.changeset(candidate_params)
      |> Map.put(:action, :validate)

    IO.inspect(changeset)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("submit", %{"candidate" => candidate_params}, socket) do
    changeset =
      %Candidate{}
      |> Candidate.changeset(candidate_params)

    if changeset.valid? do
      data = apply_action!(changeset, :update)
      IO.puts "Candidate data: #{inspect(data, [pretty: true, struct: false])}"
      Ets.add_candidate(data)

      socket =
        socket
        |> put_flash(:info, "You added a candidate!")
        |> redirect(to: ~p"/")

      {:noreply, socket}
    else
      changeset =
        %Candidate{}
        |> Candidate.changeset(candidate_params)

      {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="bg-red-600 text-white rounded-md">
    <br>
    <.form
      id="candidate-form"
      :let={f} for={@changeset}
      phx-change="validate"
      phx-submit="submit"
      class="flex flex-col max-w-md mx-auto mt-8"
    >
     <h1 class="text-4xl font-bold text-center">Make Elixir Great NOW!</h1>
     <br>
      <.input field={f[:name]} placeholder="Nguyen Van Great" id="name" label="Full Name" />
      <br>
      <.input field={f[:bio]} placeholder="example: Elixir, Phoenix, Ecto, Hòzô" id="bio" label="Bio"/>
      <br>
      <.button type="submit">Add Candidate</.button>
      <br><br>
    </.form>
    </div>
    """
  end
end
