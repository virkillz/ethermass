defmodule Ethermass.Scheduler do
  @moduledoc """
  Ethermass.Scheduler.start_link(true)
  """
  use GenServer

  def start_link(bool) do
    GenServer.start_link(__MODULE__, %{running: bool}, name: __MODULE__)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    if state.running do
      # if batch in_progress, run all plan with status unstarted and tx is nil, only take 2 every second.
      # ONLY RUN IT ONCE
      # spawn(fn ->
      #   Ethermass.Transaction.list_in_progress_transaction_batch()
      #   |> Enum.map(fn x -> Ethermass.Transaction.run_all_transaction(x) end)
      # end)

      # Update all transaction status wait for confirmation
      spawn(fn ->
        # :ok

        # update status transaction plan if status == wait_confirmation or undefined
        Ethermass.Transaction.list_wait_confirmation_transaction_plan()
        |> Enum.map(fn x -> Ethermass.Transaction.run_all_wait_for_confirmation(x) end)

        Ethermass.Transaction.list_in_progress_transaction_batch()
        |> Enum.take(5)
        |> Enum.map(fn x ->
          Ethermass.Transaction.check_and_update_transaction_batch_complete_status(x.id)
        end)
      end)
    end

    # Leave this part alone
    schedule_work()
    {:noreply, state}
  end

  # handle failure
  def handle_info(_other, state), do: {:noreply, state}

  defp schedule_work() do
    # in 2 seconds
    Process.send_after(self(), :work, 5000)
  end
end
