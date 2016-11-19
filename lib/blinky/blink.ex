defmodule HelloNerves.Blinky do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, pidA} = Gpio.start_link(26, :output)
    spawn(fn -> blink_forever(pidA) end)
    :timer.sleep(25)
    {:ok, pidB} = Gpio.start_link(16, :output)
    {:ok, pidButton} = Gpio.start_link(6, :output)
    spawn(fn -> blink_on_buton(pidB, pidButton) end)
    {:ok, []}
  end

  def blink_on_buton(pidLed, pidButton) do
    status = Gpio.read(pidButton)
    Gpio.write(pidLed, status)
    :timer.sleep(50)
    blink_on_buton(pidLed, pidButton)
  end

  defp blink_forever(pid) do
    Gpio.write(pid, 1)
    :timer.sleep(50)
    Gpio.write(pid, 0)
    :timer.sleep(50)
    blink_forever(pid)
  end
end
