%%%-------------------------------------------------------------------
%% @doc library public API
%% @end
%%%-------------------------------------------------------------------

-module(library_initializator).

%% Application callbacks
-export([start/0]).

%%====================================================================
%% API
%%====================================================================

start() ->
    io:format("Initializator Start~n"),
    P=spawn_link(fun addBooks/0),
    register(?MODULE,P),
    {ok,P}.


addBooks() ->
    {_,_,NewBook,_} = gen_server_book:add("1","cos"),
    gen_server_book:add("2","cos"),
    gen_server_book:add("3","cos"),
    gen_server_book:add("4","cos"),
    gen_server_book:add("5","cos"),
    gen_server_book:add("6","cos"),
    getBook(NewBook).



getBook(Book) ->
    gen_server_book:delete(Book).
%%====================================================================
%% Internal functions
%%====================================================================
