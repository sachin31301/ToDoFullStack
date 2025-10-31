defmodule TodoAppWeb.PageHTML do
  use Phoenix.Component
  import Phoenix.Controller, only: [get_csrf_token: 0]

  def index(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta name="csrf-token" content={get_csrf_token()} />
        <title>Todo App</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
      </head>
      <body>
        <div id="elm-app"></div>
        <script src="/assets/elm.js"></script>
        <script>
          var app = Elm.Main.init({
            node: document.getElementById("elm-app")
          });
        </script>
      </body>
    </html>
    """
  end
end
