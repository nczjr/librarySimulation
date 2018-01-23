-module(library_initializator).

-export([start/0]).

start() ->
    io:format("Initializator Start~n"),
    add_books(),
    {ok}.

add_books() -> 
    Books = [book_handler:init("book1","author1"),
            book_handler:init("book2","author2"),
            book_handler:init("book3","author3"),
            book_handler:init("book4","author4"),
            book_handler:init("book5","author5"),
            book_handler:init("book6","author6"),
            book_handler:init("book7","author7"),
            book_handler:init("book8","author8"),
            book_handler:init("book9","author9"),
            book_handler:init("book10","author10")],
        lists:foreach(fun(X) -> gen_server_book:add(X) end,Books).

