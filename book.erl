-module(book).
-compile([export_all]).

-record(book, {name, author, state = available}).

init(Name, Author) ->
    #book{name = Name, author = Author}.

borrow_book(Self) ->
    Self#book{state = borrowed}.

return_book(Self) ->
    Self#book{state = available}.
