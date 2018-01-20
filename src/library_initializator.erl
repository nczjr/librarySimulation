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
    gen_server_book:add("1","cos"),
    gen_server_book:add("2","cos"),
    gen_server_book:add("3","cos"),
    gen_server_book:add("4","cos"),
    gen_server_book:add("5","cos"),
    gen_server_book:add("6","cos"),
    gen_server_book:print(),
    gen_server_book:borrow("1"),
    gen_server_book:print(),
    gen_server_book:return("1"),
    gen_server_book:print(),
    gen_server_book:delete("1"),
    gen_server_book:print().


getBook() ->
    gen_server_book:delete(book_handler:init("1","cos")).
%%====================================================================
%% Internal functions
%%====================================================================
