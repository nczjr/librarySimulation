-module(client).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, start/1, get_books/0, borrow_book/1, return_book/1, work/0]).
-define(SERVER, ?MODULE).
-define(DELAY, 1000).

-record(client, {name, books = []}).
-record(book, {name, author, state = available}).

start(Name) -> gen_server:start_link(?MODULE, Name, []).

get_books() -> gen_server:call(?MODULE, {get_books}).
borrow_book(Book) -> gen_server:call(?MODULE, {borrow_book, Book}).
return_book(Book) -> gen_server:call(?MODULE, {return_book, Book}).
work() -> gen_server:call(?MODULE, {work}).

init(Name) ->
    io:format("Create client: ~s~n", [Name]),
    {ok, #client{name = Name}}.

handle_call({get_books}, _From, Self) ->
    Books = Self#client.books,
    io:format("Client ~s has: ~s~n", [Self#client.name, Books]),
    {reply, Books, Self};

handle_call({borrow_book, Book}, _From, Self) ->
    Borrowed_book = gen_server_book:borrow(Book),
    borrow(Self, Borrowed_book);

handle_call({work}, _From, Self) ->
    Book = book_handler:init(rand:uniform(10), "author"),
    case rand:uniform(2) of
        1 ->
            gen_server:call(?MODULE, {return_book, Book});
        _ ->
            gen_server:call(?MODULE, {borrow_book, Book})
    end,
    {reply, ok, Self};

handle_call({return_book, Book}, _From, Self) ->
    Books = Self#client.books, 
    case lists:member(Book, Books) of
        true ->
            io:format("Client returned book: ~s~n", [Book#book.name]),
            New_books = lists:delete(Book, Books),
            gen_server_book:return(Book),
            {reply, ok, Self#client{books = New_books}};
        false ->
            io:format("Client didn't borrow book: ~s~n", [Book#book.name]),
            {reply, ok, Self}
        end.
    
borrow(Self, Book) when is_record(Book, book) ->
    io:format("Client ~s borrowed book: ~s~n", [Self#client.name, Book#book.name]),
    Books = Self#client.books,
    {reply, ok, Self#client{books = Books ++ [Book]}};

borrow(Self, _) -> {reply, ok, Self}.

handle_cast(_Message, Library) -> {noreply, Library}.
handle_info(_Message, Library) -> {noreply, Library}.
terminate(_Reason, _Library) -> ok.
code_change(_OldVersion, Library, _Extra) -> {ok, Library}.
