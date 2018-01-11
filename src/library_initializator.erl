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
  io:format("Initializator Start"),
    P=spawn_link(fun addBooks/0),
    register(?MODULE,P),
    {ok,P}.


addBooks() ->
    gen_server_book:add("1","cos"),
    gen_server_book:add("2","cos"),
    gen_server_book:add("2","cos"),
    gen_server_book:add("2","cos"),
    gen_server_book:add("2","cos"),
    gen_server_book:add("2","cos").
%%====================================================================
%% Internal functions
%%====================================================================
