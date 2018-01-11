-module(book_handler).
-compile([export_all]).

-record(book, {name, author, state = available}).

start() ->
    io:format("Book Start~n"),
    P=spawn_link(fun handle/0),
    {ok,P}.


handle() ->
  receive
    {From, {add,Name, Author}} -> From ! init(Name,Author);
    {From, {borrow_book, Book}}-> From ! borrow_book(Book);
    {From, {return_book, Book}} -> From ! return_book(Book)
  end,
  handle().




init(Name, Author) ->
    io:format("Adding ~w by ~w ", Name,Author),
    #book{name = Name, author = Author}.

borrow_book(Self) ->
    Self#book{state = borrowed}.

return_book(Self) ->
    Self#book{state = available}.
