-module(client_simulator).
-compile([export_all]).


start(Number) ->
    Names = [jan,ula,kacper,radek,mirek,grzesiu,marek,daniel,gosia,anka,julka],
    Clients = lists:seq(1,Number),
    Pids = lists:map(fun(X) -> 
                    client:start(   
                        lists:nth(random:uniform(length(Names)),Names)
                        ) end, Clients),
    lists:foreach(fun(X) -> X ! work end, Pids).

