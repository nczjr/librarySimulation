-module(client_simulator).
-compile([export_all]).


start(Name) ->
     PID = client:start(Name),
     gen_server_book:add_client(PID),
     P=spawn_link(?MODULE, loop, []),
     register(?MODULE,P),
     work(PID),
     {ok, PID}.

work(PID) ->
    client:borrow_book("1"),
    client:borrow_book("2"),
    client:return_book("1").



    loop() ->
    receive 
        _ -> io:format("s;s;")
        
    end.