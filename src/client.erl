-module(client).

-compile([export_all]).

-record(client, {name, books = []}).
-record(book, {name, author, state = available}).

start(Name) ->
    spawn_link(fun() -> init(Name) end).

init(Name) ->
    io:format("Create client: ~s~n", [Name]),
    LibraryBooks =  [book_handler:init("1","author"),
    book_handler:init("2","author"),
    book_handler:init("3","author"),
    book_handler:init("4","author"),
    book_handler:init("5","author"),
    book_handler:init("6","author"),
    book_handler:init("7","author"),
    book_handler:init("8","author"),
    book_handler:init("9","author"),
    book_handler:init("10","author")],
    handle(#client{name = Name}).

handle(Self) ->
    receive 
        get_books ->
            Books = Self#client.books,
            io:format("Client ~s has: ~s~n", [Self#client.name, Books]),
            handle(Self);
        {borrow_book, Book} ->
            Borrowed_book = gen_server_book:borrow(Book),
            borrow(Self, Borrowed_book);
        {return_book, Book} -> 
            Books = Self#client.books, 
            case lists:member(Book, Books) of
                true ->
                    io:format("Client returned book: ~s~n", [Book#book.name]),
                    New_books = lists:delete(Book, Books),
                    gen_server_book:return(Book),
                    handle(Self#client{books = New_books});
                false ->
                    io:format("Client didn't borrow book: ~s~n", [Book#book.name]),
                    handle(Self)
            end;
        work ->
                case rand:uniform(3) of 
                    1 -> 
                        Book = lists:nth(rand:uniform(length(Self#client.books)), Self#client.books), 
                        gen_server:call(?MODULE, {return_book, Book}); 
                    _ -> 
                        Book = lists:nth(rand:uniform(length(LibraryBooks)), LibraryBooks), 
                        gen_server:call(?MODULE, {borrow_book, Book}) 
                end, 
                self() ! work

    end.
    
    
borrow(Self, Book) when is_record(Book, book) ->
    io:format("Client ~s borrowed book: ~s~n", [Self#client.name, Book#book.name]),
    Books = Self#client.books,
    handle(Self#client{books = Books ++ [Book]});

borrow(Self, _) -> handle(Self).

   
