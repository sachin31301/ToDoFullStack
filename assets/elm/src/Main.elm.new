module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Json.Encode as Encode

-- MODEL
type alias Todo =
    { id : String
    , title : String
    , completed : Bool
    }

type alias Model =
    { todos : List Todo
    , newTodo : String
    , error : Maybe String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { todos = []
      , newTodo = ""
      , error = Nothing
      }
    , fetchTodos
    )

-- UPDATE
type Msg
    = NoOp
    | UpdateNewTodo String
    | AddTodo
    | ToggleTodo String
    | DeleteTodo String
    | GotTodos (Result Http.Error (List Todo))
    | TodoAdded (Result Http.Error Todo)
    | TodoToggled (Result Http.Error Todo)
    | TodoDeleted String (Result Http.Error ())

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdateNewTodo str ->
            ( { model | newTodo = str }, Cmd.none )

        AddTodo ->
            if String.isEmpty (String.trim model.newTodo) then
                ( model, Cmd.none )
            else
                ( { model | newTodo = "" }
                , createTodo model.newTodo
                )

        ToggleTodo id ->
            ( model, toggleTodo id )

        DeleteTodo id ->
            ( model, deleteTodo id )

        GotTodos (Ok todos) ->
            ( { model | todos = todos, error = Nothing }, Cmd.none )

        GotTodos (Err _) ->
            ( { model | error = Just "Failed to load todos" }, Cmd.none )

        TodoAdded (Ok todo) ->
            ( { model | todos = todo :: model.todos, error = Nothing }, Cmd.none )

        TodoAdded (Err _) ->
            ( { model | error = Just "Failed to add todo" }, Cmd.none )

        TodoToggled (Ok updatedTodo) ->
            ( { model
                | todos =
                    List.map
                        (\todo ->
                            if todo.id == updatedTodo.id then
                                updatedTodo
                            else
                                todo
                        )
                        model.todos
                , error = Nothing
              }
            , Cmd.none
            )

        TodoToggled (Err _) ->
            ( { model | error = Just "Failed to toggle todo" }, Cmd.none )
            
        TodoDeleted id (Ok _) ->
            ( { model
                | todos = List.filter (\todo -> todo.id /= id) model.todos
                , error = Nothing
              }
            , Cmd.none
            )

        TodoDeleted _ (Err _) ->
            ( { model | error = Just "Failed to delete todo" }, Cmd.none )

-- VIEW
view : Model -> Html Msg
view model =
    div [ class "container mx-auto px-4 py-8" ]
        [ h1 [ class "text-3xl font-bold text-center mb-8" ] [ text "Todo App" ]
        , viewForm model
        , viewTodos model.todos
        , viewError model.error
        ]

viewForm : Model -> Html Msg
viewForm model =
    div [ class "flex gap-4 mb-8" ]
        [ input
            [ type_ "text"
            , value model.newTodo
            , onInput UpdateNewTodo
            , placeholder "What needs to be done?"
            , class "flex-grow p-2 border rounded"
            ] []
        , button 
            [ onClick AddTodo
            , class "px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            ] 
            [ text "Add" ]
        ]

viewTodos : List Todo -> Html Msg
viewTodos todos =
    ul [ class "space-y-2" ] (List.map viewTodoItem todos)

viewTodoItem : Todo -> Html Msg
viewTodoItem todo =
    li [ class "flex items-center gap-4 p-2 border rounded" ]
        [ input
            [ type_ "checkbox"
            , checked todo.completed
            , onClick (ToggleTodo todo.id)
            , class "w-5 h-5"
            ] []
        , span 
            [ class (if todo.completed then "line-through text-gray-500 flex-grow" else "flex-grow") ]
            [ text todo.title ]
        , button
            [ onClick (DeleteTodo todo.id)
            , class "px-2 py-1 text-red-500 hover:text-red-700"
            ]
            [ text "×" ]
        ]

viewError : Maybe String -> Html Msg
viewError maybeError =
    case maybeError of
        Just error ->
            div [ class "text-red-500 mt-4" ] [ text error ]
        Nothing ->
            text ""

-- HTTP
fetchTodos : Cmd Msg
fetchTodos =
    Http.get
        { url = "/api/todos"
        , expect = Http.expectJson GotTodos (Decode.field "data" (Decode.list todoDecoder))
        }

createTodo : String -> Cmd Msg
createTodo title =
    Http.post
        { url = "/api/todos"
        , body = Http.jsonBody (encodeTodo title)
        , expect = Http.expectJson TodoAdded (Decode.field "data" todoDecoder)
        }

toggleTodo : String -> Cmd Msg
toggleTodo id =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "/api/todos/" ++ id ++ "/toggle"
        , body = Http.emptyBody
        , expect = Http.expectJson TodoToggled (Decode.field "data" todoDecoder)
        , timeout = Nothing
        , tracker = Nothing
        }

deleteTodo : String -> Cmd Msg
deleteTodo id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "/api/todos/" ++ id
        , body = Http.emptyBody
        , expect = Http.expectWhatever (TodoDeleted id)
        , timeout = Nothing
        , tracker = Nothing
        }

-- JSON
todoDecoder : Decode.Decoder Todo
todoDecoder =
    Decode.map3 Todo
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "completed" Decode.bool)

encodeTodo : String -> Encode.Value
encodeTodo title =
    Encode.object
        [ ( "todo"
          , Encode.object
                [ ( "title", Encode.string title )
                ]
          )
        ]

-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
