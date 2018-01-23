-module(book_handler).
-compile([export_all]).

-record(book, {name, author, state = available}).

init(Name, Author) ->
    io:format("Adding ~p by ~p ~n", [Name,Author]),
    #book{name = Name, author = Author}.

borrow_book(Self) ->
    Self#book{state = borrowed}.

return_book(Self) ->
    Self#book{state = available}.

print() ->
    gen_server_book:print().