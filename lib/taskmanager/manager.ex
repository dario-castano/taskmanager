defmodule Taskmanager.Manager do
  use GenServer

  defstruct tasks: []

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
    {:ok, new()}
  end

  def new(), do: __struct__()
  def new(%{tasks: tasks}), do: __struct__(tasks: tasks)

  def add_task(description) do
    GenServer.call(__MODULE__, {:add, description})
  end

  def list_tasks() do
    GenServer.call(__MODULE__, {:list})
  end

  def complete_task(id) do
    GenServer.call(__MODULE__, {:complete, id})
  end

  @impl true
  def handle_call({:add, description}, _from, %{tasks: tasks}) do
    task = %{id: length(tasks) + 1, description: description, completed: false}
    new_state = new(%{tasks: tasks ++ [task]})

    IO.puts("")
    IO.puts("**** Tarea agregada exitosamente con id -> #{task.id} ****")
    IO.puts("")

    {:reply, {:ok, task.id}, new_state}
  end

  @impl true
  def handle_call({:list}, _from, %{tasks: tasks} = state) do
    statuses =
      Enum.map(tasks, fn task -> if task.completed, do: "Completada", else: "Pendiente" end)

    IO.puts("")
    IO.puts("**** LISTA DE TAREAS ****")
    Enum.zip_with(tasks, statuses, fn task, status -> Map.put(task, :status, status) end)
    |> Enum.each(fn element ->
      IO.puts("#{element.id}. #{element.description} #{element.status}")
    end)
    IO.puts("**** FIN ****")
    IO.puts("")

    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:complete, id}, _from, %{tasks: tasks}) do
    updated_tasks =
      Enum.map(tasks, fn task ->
        if task.id == id, do: Map.put(task, :completed, true), else: task
      end)

    new_state = new(%{tasks: updated_tasks})

    IO.puts("")
    IO.puts("**** Tarea completada exitosamente ****")
    IO.puts("")

    {:reply, :ok, new_state}
  end
end
