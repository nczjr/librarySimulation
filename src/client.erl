-module(client).
-compile([export_all]).

-record(client, {name, books = []}).
-record(book, {name, author, state = available}).

init(Name) ->
    spawn(fun() -> create_client(Name) end).

create_client(Name) ->
    io:format("Create client: ~s~n", [Name]),
    handle(#client{name = Name}).

handle(Self) ->
    receive
        {_, get_books} -> 
            io:format("Client ~s has: ~s~n", [Self#client.name, Self#client.books]),
            handle(Self);
        {_, borrow_book, Book} ->
            io:format("Client ~s borrowed book: ~s~n", [Self#client.name, Book#book.name]),
            Books = Self#client.books,
            handle(Self#client{books = Books ++ [Book]});
        {From, return_book, Book} -> 
            Books = Self#client.books, 
            case lists:member(Book, Books) of
                true ->
                    io:format("Client returned book: ~s~n", [Book#book.name]),
                    New_books = lists:delete(Book, Books),
                    From ! Book,
                    handle(Self#client{books = New_books});
                false ->
                    io:format("Client didn't borrow book: ~s~n", [Book#book.name]),
                    From ! not_found,
                    handle(Self)
            end
    end.




    