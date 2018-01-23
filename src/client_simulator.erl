-module(client_simulator).
-compile([export_all]).


start(Number) ->
    Names = [jan,ula,kacper,radek,mirek,grzesiu,gocha,daniel],
    Pids = add(Number,Names),
    startWork(Pids).
    % Clients = lists:seq(1,Number),
    % Pids = lists:map(fun(X) -> [client:start(X)] end, Clients),
    % io:format("~p", [Pids]),
    % lists:foreach(fun(X) -> X ! work end, Pids).

add(0,Names) -> [];
add(N,Names) -> [client:start(lists:nth(random:uniform(length(Names)),Names))] ++ add(N-1,Names).

startWork([]) -> io:format("wszystkie done");
startWork([H|T]) -> H ! work,
                startWork(T).



    % Cl1 = client:start(chuj),
    % Cl1 ! work.
    