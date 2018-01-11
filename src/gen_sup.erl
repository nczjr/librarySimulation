-module(gen_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {{one_for_all, 10, 3600}, [
        {some_server,
            {gen_server_book, start, []},
            permanent, brutal_kill, worker, [gen_server_book]}
    ]} }.