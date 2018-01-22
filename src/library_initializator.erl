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
    P=spawn_link(fun loop/0),
    register(?MODULE,P),
    add_books(),
    {ok,P}.

add_books() -> 
    gen_server_book:add("1","author"),
    gen_server_book:add("2","author"),
    gen_server_book:add("3","author"),
    gen_server_book:add("4","author"),
    gen_server_book:add("5","author"),
    gen_server_book:add("6","author"),
    gen_server_book:add("7","author"),
    gen_server_book:add("8","author"),
    gen_server_book:add("9","author"),
    gen_server_book:add("10","author").

loop() ->
    receive 
        _ -> io:format("s;s;")
        
    end.

%%====================================================================
%% Internal functions
%%====================================================================
