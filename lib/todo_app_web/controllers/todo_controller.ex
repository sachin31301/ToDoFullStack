defmodule TodoAppWeb.TodoController do
  use TodoAppWeb, :controller

  alias TodoApp.Todos

  def index(conn, _params) do
    todos = Todos.list_todos()
    render(conn, :index, todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    case Todos.create_todo(todo_params) do
      {:ok, todo} ->
        conn
        |> put_status(:created)
        |> render(:show, todo: todo)

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Could not create todo"})
    end
  end

  def toggle(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    case Todos.toggle_todo(todo) do
      {:ok, todo} ->
        render(conn, :show, todo: todo)
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Could not toggle todo"})
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    case Todos.delete_todo(todo) do
      {:ok, _todo} ->
        send_resp(conn, :no_content, "")
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Could not delete todo"})
    end
  end
end
