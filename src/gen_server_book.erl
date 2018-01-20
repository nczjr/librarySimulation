-module(gen_server_book).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, start/0, add/2, borrow/1, get/1, print/0, check/2]).
-define(SERVER, ?MODULE).
-record(book, {name, author, state = available}).


start() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add(Book, Who) -> gen_server:call(?MODULE, {add, Book, Who}).
borrow(Book) -> gen_server:call(?MODULE, {borrow, Book}).
get(Book) -> gen_server:call(?MODULE, {get, Book}).
check(Book, Who) -> gen_server:call(?MODULE, {check, Book, Who}).
print() -> gen_server:call(?MODULE, {print}).


init([]) ->
    io:format("Server Start~n"),
    Library = [],
    {ok, Library}.


display(Book) ->
    io:format("Book name  is ~p~n",[Book#book.name]),
    io:format("Book status  is ~p~n",[Book#book.state]).


handle_call({print}, _From, Library) ->
    lists:foreach(fun display/1, Library),
     {reply, ok  , Library};


handle_call({add, Book, Who}, _From, Library) ->
    NewBook = book_handler:init(Book, Who),
    NewLibrary = lists:append(Library,[NewBook]),
    {reply, ok, NewLibrary};

    

handle_call({borrow, Book}, _From, Library) ->
    
    Response = case lists:any(fun(X) -> X#book.name == Book end,Library) of
 		true ->
 			% NewLibrary = lists:delete(Book, Library),
            BookToBorrow = lists:keyfind(Book, #book.name,Library),
            io:format("Poszukiwana ksiazka ~p ~n", [BookToBorrow]),
            NewLibrary =lists:keystore(Book,#book.name,Library,book_handler:borrow_book(BookToBorrow));

 		false ->
            NewLibrary = Library,
 			io:format("Nie mamy ksiazki o tytule ~p ~n", [Book])
 	end,
    
    {reply, ok, NewLibrary};

handle_call({get, Book}, _From, Library) ->
    {reply, lists:any(fun(X) -> X#book.name == Book#book.name end,Library), Library};

handle_call({check, Book, Who}, _From, Library) ->
	{reply, lists:member(Who, dict:fetch(Book, Library)), Library}.

handle_cast(_Message, Library) -> {noreply, Library}.
handle_info(_Message, Library) -> {noreply, Library}.
terminate(_Reason, _Library) -> ok.
code_change(_OldVersion, Library, _Extra) -> {ok, Library}.
