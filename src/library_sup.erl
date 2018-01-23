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

%   Client1 = {client1, {client, start, [client1]},
%         permanent, 2000, worker, [client]},
%   Client2 = {client2, {client, start, [client2]},
%         permanent, 2000, worker, [client]},
%   Client3 = {client3, {client, start, [client3]},
%         permanent, 2000, worker, [client]},
%   Client4 = {client4, {client, start, [client4]},
%         permanent, 2000, worker, [client]},
 Children = [Server],
%   Children = [Server,Client1,Client2,Client3,Client4],
  RestartStrategy = {one_for_one, 0, 1},
  {ok, {RestartStrategy, Children}}.

%%====================================================================
%% Internal functions
%%====================================================================
