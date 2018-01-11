-module(gen_server_book).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, start/0, add/2, delete/1, get/1, check/2]).
-define(SERVER, ?MODULE).

start() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add(Book, Who) -> gen_server:call(?MODULE, {add, Book, Who}).
delete(Book) -> gen_server:call(?MODULE, {delete, Book}).
get(Book) -> gen_server:call(?MODULE, {get, Book}).
check(Book, Who) -> gen_server:call(?MODULE, {check, Book, Who}).


init([]) ->
  io:format("Server Start"),

    Library = dict:new(),
    {ok, Library}.

handle_call({add, Book, Who}, _From, Library) ->
    NewLibrary = dict:append(Book, Who, Library),
    {reply, ok, NewLibrary};

handle_call({delete, Book}, _From, Library) ->
    NewLibrary = dict:erase(Book, Library),
    {reply, ok, NewLibrary};

handle_call({get, Book}, _From, Library) ->
    {reply, dict:find(Book, Library), Library};

handle_call({check, Book, Who}, _From, Library) ->
	Response = case dict:is_key(Book, Library) of
		true ->
			lists:member(Who, dict:fetch(Book, Library));
		false ->
			{noKey, Book}
	end,
	{reply, Response, Library}.

handle_cast(_Message, Library) -> {noreply, Library}.
handle_info(_Message, Library) -> {noreply, Library}.
terminate(_Reason, _Library) -> ok.
code_change(_OldVersion, Library, _Extra) -> {ok, Library}.
