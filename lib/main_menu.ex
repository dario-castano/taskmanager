defmodule MainMenu do
  alias Taskmanager.Manager

  use GenServer

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(init_params) do
    GenServer.start_link(__MODULE__, init_params, name: __MODULE__)
  end

  @impl true
  def init(_) do
    loop()
    {:ok, []}
  end

  defp loop() do
    # Display the menu
    IO.puts("""
    Gestor de Tareas
    1. Agregar Tarea
    2. Listar Tareas
    3. Completar Tarea
    4. Salir
    """)

    # Get user input
    IO.write("Seleccione una opción: ")
    option = String.trim(IO.gets("")) |> String.to_integer()
    execute_option(option)
  end

  defp execute_option(1) do
    IO.write("Ingrese la descripción de la tarea: ")
    description = String.trim(IO.gets(""))
    Manager.add_task(description)
    loop()
  end

  defp execute_option(2) do
    Manager.list_tasks()
    loop()
  end

  defp execute_option(3) do
    IO.write("Ingrese el ID de la tarea a completar: ")
    id = String.trim(IO.gets("")) |> String.to_integer()
    Manager.complete_task(id)
    loop()
  end

  defp execute_option(4) do
    IO.puts("¡Adiós!")
    :exit
  end

  defp execute_option(_) do
    IO.puts("Opción no válida.")
    loop()
  end
end
