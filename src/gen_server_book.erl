-module(gen_server_book).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, start/0, add/2, delete/1, get/1, check/2]).
-define(SERVER, ?MODULE).
-record(book, {name, author, state = available}).


start() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add(Book, Who) -> gen_server:call(?MODULE, {add, Book, Who}).
delete(Book) -> gen_server:call(?MODULE, {delete, Book}).
get(Book) -> gen_server:call(?MODULE, {get, Book}).
check(Book, Who) -> gen_server:call(?MODULE, {check, Book, Who}).


init([]) ->
    io:format("Server Start~n"),
    Library = [],
    {ok, Library}.

handle_call({add, Book, Who}, _From, Library) ->
    NewLibrary = lists:append(Library,[book_handler:init(Book, Who)]),
    {reply, ok, NewLibrary};

handle_call({delete, Book}, _From, Library) when record(Book,book) ->
    NewLibrary = lists:delete(Book, Library),
    {reply, ok, NewLibrary};

handle_call({get, Book}, _From, Library) ->
    {reply, lists:any(fun(X) -> X#book.name == Book#book.name end,Library), Library};

handle_call({check, Book, Who}, _From, Library) ->
	{reply, lists:member(Who, dict:fetch(Book, Library)), Library}.

handle_cast(_Message, Library) -> {noreply, Library}.
handle_info(_Message, Library) -> {noreply, Library}.
terminate(_Reason, _Library) -> ok.
code_change(_OldVersion, Library, _Extra) -> {ok, Library}.
