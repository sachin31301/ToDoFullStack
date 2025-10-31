defmodule TodoAppWeb.TodoJSON do
  def index(%{todos: todos}) do
    %{data: for(todo <- todos, do: data(todo))}
  end

  def show(%{todo: todo}) do
    %{data: data(todo)}
  end

  defp data(%{} = todo) do
    %{
      id: todo.id,
      title: todo.title,
      completed: todo.completed
    }
  end
end
