defmodule HelloNerves.Blinky do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, pidA} = Gpio.start_link(26, :output)
    {:ok, pidB} = Gpio.start_link(16, :output)
    spawn(fn -> blink_forever(pidA) end)
    :timer.sleep(1000)
    spawn(fn -> blink_forever(pidB) end)
    {:ok, []}
  end

  defp blink_forever(pid) do
    Gpio.write(pid, 1)
    :timer.sleep(1000)
    Gpio.write(pid, 0)
    :timer.sleep(1000)
    blink_forever(pid)
  end
end
