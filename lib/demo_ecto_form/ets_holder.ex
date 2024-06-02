defmodule DemoEctoForm.Ets do
  use GenServer, restart: :transient

  @votes_table :votes
  @candidates_table :candidates

  ### Public API ###

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_vote(vote) do
    IO.puts "add vote: #{inspect(vote)}"
    GenServer.cast(__MODULE__, {:add_vote, vote})
  end

  def get_votes do
    votes = :ets.tab2list(@votes_table)
    Enum.map(votes, fn {_key, vote} -> vote end)
  end

  def add_candidate(candidate) do
    GenServer.cast(__MODULE__, {:add_candidate, candidate})
  end

  def get_candidates do
    candidates = :ets.tab2list(@candidates_table)
    Enum.map(candidates, fn {_key, candidate} -> candidate end)
  end

  def get_key_candidates do
    candidates = :ets.tab2list(@candidates_table)
    Enum.map(candidates, fn {key, _candidate} -> key end)
  end

  ### Callbacks ###

  def init(_) do
    vote_table =:ets.new(@votes_table, [:named_table, :protected, read_concurrency: true, write_concurrency: true])
    candidate_table =:ets.new(@candidates_table, [:named_table, :protected, read_concurrency: true, write_concurrency: true])

    {:ok, {vote_table, candidate_table}}
  end

  def handle_cast({:add_vote, vote}, {votes, _} = state) do
    :ets.insert(votes, {vote.email, vote})
    IO.puts "Vote added: #{inspect(vote)}"
    {:noreply, state}
  end

  def handle_cast({:add_candidate, candidate}, {_, candidates} = state) do
    :ets.insert(candidates, {candidate.name, candidate})
    {:noreply, state}
  end
end
