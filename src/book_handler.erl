-module(book_handler).
-compile([export_all]).

-record(book, {name, author, state = available}).


init(Name, Author) ->
    io:format("Adding ~n ~p ~p", [Name,Author]),
    #book{name = Name, author = Author}.

borrow_book(Self) ->
    Self#book{state = borrowed}.

return_book(Self) ->
    Self#book{state = available}.


print(Book) ->
    io:format("~p ~p ~n ", [Book#book.name,Book#book.author]),