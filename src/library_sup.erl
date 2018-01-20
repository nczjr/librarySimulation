%%%-------------------------------------------------------------------
%% @doc library top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(library_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
  Server = {gen_server_book, {gen_server_book, start, []},
        permanent, 2000, worker, [gen_server_book]},
  Initializator = {library_initializator, {library_initializator, start,[]},
        permanent, 2000, worker, [library_initializator]},
  Children = [Server, Initializator],
  RestartStrategy = {one_for_one, 0, 1},
  {ok, {RestartStrategy, Children}}.

%%====================================================================
%% Internal functions
%%====================================================================
