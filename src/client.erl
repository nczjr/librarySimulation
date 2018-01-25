-module(client).

-compile([export_all]).

-record(client, {name, books = []}).
-record(book, {name, author, state = available}).


start(Name) ->
    spawn_link(fun() -> init(Name) end).

init(Name) ->
    io:format("Create client: ~w~n", [Name]),
    handle(#client{name = Name}).
    

handle(Self) ->
    receive 
        get_books ->
            Books = Self#client.books,
            io:format("Client ~w has: ~n", [Self#client.name]),
            lists:foreach(fun(X) -> io:format("~p ~n", [X#book.name]) end, Books),
            handle(Self);
        
        work ->
            LibraryBooks = gen_server_book:get_books(),
                case rand:uniform(3) of
                    1 -> 
                        UpdatedSelf = random_return(Self);
                    _ -> 
                        UpdatedSelf = random_borrow(Self, LibraryBooks)
                end,
                self() ! work,
                timer:sleep(5000),
                handle(UpdatedSelf);

        {borrow_book, Book} ->
            Borrowed_book = gen_server_book:borrow(Book#book.name),
            borrow(Self, Borrowed_book);
        
        {return_book, Book} -> 
            Books = Self#client.books, 
            case lists:member(Book, Books) of
                true ->
                    io:format("Client ~w returned book: ~p~n", [Self#client.name,Book#book.name]),
                    New_books = lists:delete(Book, Books),
                    gen_server_book:return(Book#book.name),
                    handle(Self#client{books = New_books});
                false ->
                    io:format("Client didn't borrow book: ~p~n", [Book#book.name]),
                    handle(Self)
            end
    end.
    
    
borrow(Self, Book) when is_record(Book, book) ->
    io:format("Client ~w borrowed book: ~p~n", [Self#client.name, Book#book.name]),
    Books = Self#client.books,
    handle(Self#client{books = Books ++ [Book]});

borrow(Self, _) -> handle(Self).

random_return(Client) ->
    case length(Client#client.books) of
        0 ->
            Client;
        _ ->
            Books = Client#client.books,
            Book = lists:nth(rand:uniform(length(Books)), Books), 
            New_books = lists:delete(Book, Books),
            io:format("Client ~w is trying to return book: ~p~n", [Client#client.name,Book#book.name]),
            gen_server_book:return(Book#book.name),
            io:format("Client ~w returned book: ~p~n", [Client#client.name,Book#book.name]),
            UpdatedClient = Client#client{books = New_books},
            UpdatedClient
    end.

random_borrow(Client, LibraryBooks) ->
    Book = lists:nth(rand:uniform(length(LibraryBooks)), LibraryBooks), 
    io:format("Client ~w is trying to borrow book: ~p~n", [Client#client.name,Book#book.name]),
    Borrowed_book = gen_server_book:borrow(Book#book.name),
    case is_record(Borrowed_book,book) of
        true ->
            io:format("Client ~w borrowed book: ~p~n", [Client#client.name,Book#book.name]),
            Books = Client#client.books,
            Client#client{books = Books ++ [Borrowed_book]};
        false -> 
            io:format("Client ~w didn't borrow book: ~p~n", [Client#client.name,Book#book.name]),
            Client   
    end.



   
