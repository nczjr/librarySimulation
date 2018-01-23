-module(client).

-compile([export_all]).

-record(client, {name, books = []}).
-record(book, {name, author, state = available}).

start(Name) ->
    spawn_link(fun() -> init(Name) end).

init(Name) ->
    io:format("Create client: ~s~n", [Name]),
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
            end
    end.
    
    
borrow(Self, Book) when is_record(Book, book) ->
    io:format("Client ~s borrowed book: ~s~n", [Self#client.name, Book#book.name]),
    Books = Self#client.books,
    handle(Self#client{books = Books ++ [Book]});

borrow(Self, _) -> handle(Self).

% handle_call({work}, _From, Self) -> 
%     Book = book_handler:init(rand:uniform(10), "author"), 
%     case rand:uniform(2) of 
%         1 -> 
%             gen_server:call(?MODULE, {return_book, Book}); 
%         _ -> 
%             gen_server:call(?MODULE, {borrow_book, Book}) 
%     end, 
%     {reply, ok, Self}; 
