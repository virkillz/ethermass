defmodule Ethermass.Scheduler do
  @moduledoc """

  """
  use GenServer

  alias Ethermass.Transaction

  def start_link(bool) do
    GenServer.start_link(__MODULE__, %{running: bool})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do


    if state.running do

        spawn(fn ->
          Transaction.list_in_progress_transaction_batch()
          |> Enum.map(fn x -> Transaction.run_all_transaction(x) end)
        end)


        #Update all transaction status wait for confirmation
        spawn(fn ->

          Transaction.list_wait_confirmation_transaction_plan()
          |> Enum.map(fn x -> Transaction.run_all_wait_for_confirmation(x) end)

          Transaction.list_in_progress_transaction_batch()
          |> Enum.map(fn x -> Transaction.check_and_update_transaction_batch_complete_status(x.id) end)
        end)

    end

    # Leave this part alone
    schedule_work()
    {:noreply, state}
  end

  #handle failure
  def handle_info(_other, state), do: {:noreply, state}

  defp schedule_work() do
    # in 2 seconds
    Process.send_after(self(), :work, 2000)
  end
end
