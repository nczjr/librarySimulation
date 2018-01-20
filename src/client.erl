-module(client).
-compile([export_all]).

-record(client, {name, books = []}).
-record(book, {name, author, state = available}).

init(Name) ->
    spawn(fun() -> create_client(Name) end).

create_client(Name) ->
    io:format("Create client: ~s~n", [Name]),
    #client{name = Name}.

handle() ->
    receive
        {From, get_books, Self} -> 
            From ! Self#client.books;
        {From, borrow_book, {Self, Book}} ->
            io:format("Client borrowed book: ~s~n", [Book#book.name]),
            Books = Self#client.books,
            From ! Self#client{books = Books ++ [Book]};
        {From, return_book, {Self, Book}} -> 
            Books = Self#client.books, 
            case lists:member(Book, Books) of
                true ->
                    io:format("Client returned book: ~s~n", [Book#book.name]),
                    New_books = lists:delete(Book, Books),
                    New_client = Self#client{books = New_books},
                    From ! {New_client, Book};
                false ->
                    io:format("Client didn't borrow book: ~s~n", [Book#book.name]),
                    From ! {Self, not_found}
            end
    end.




    