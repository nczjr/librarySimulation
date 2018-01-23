-module(library_initializator).

-export([start/0]).

start() ->
    io:format("Initializator Start~n"),
    add_books(),
    {ok}.

add_books() -> 
    Books = [book_handler:init("1","author"),
            book_handler:init("2","author"),
            book_handler:init("3","author"),
            book_handler:init("4","author"),
            book_handler:init("5","author"),
            book_handler:init("6","author"),
            book_handler:init("7","author"),
            book_handler:init("8","author"),
            book_handler:init("9","author"),
            book_handler:init("10","author")],
        lists:foreach(fun(X) -> gen_server_book:add(X) end,Books).

