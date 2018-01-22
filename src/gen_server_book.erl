-module(gen_server_book).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, code_change/3, terminate/2, start/0, add/2, add_client/1, borrow/1, return/1, delete/1, print/0]).
-define(SERVER, ?MODULE).
-record(book, {name, author, state = available}).

start() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add(Book, Who) -> gen_server:call(?MODULE, {add, Book, Who}).
add_client(PID) -> gen_server:call(?MODULE, {add_client, PID}).
borrow(Book) -> gen_server:call(?MODULE, {borrow, Book}).
return(Book) -> gen_server:call(?MODULE, {return, Book}).
delete(Book) -> gen_server:call(?MODULE, {delete, Book}).
print() -> gen_server:call(?MODULE, {print}).

init([]) ->
    io:format("Server Start~n"),
    Library = [],
    Clients = [],
    {ok, {Library, Clients}}.


display(Book) ->
    io:format("Book name  is ~p~n",[Book#book.name]),
    io:format("Book status  is ~p~n",[Book#book.state]).


handle_call({print}, _From, {Library, Clients}) ->
    lists:foreach(fun display/1, Library),
     {reply, ok, Library};


handle_call({add, Book, Who}, _From, {Library, Clients}) ->
    NewBook = book_handler:init(Book, Who),
    NewLibrary = lists:append(Library,[NewBook]),
    {reply, ok, {NewLibrary, Clients}};

handle_call({add_client, PID}, _From, {Library, Clients}) ->
    NewClients = lists:append(Clients,[PID]),
    {reply, ok, {Library, NewClients}};

handle_call({borrow, Book}, _From, {Library, Clients}) ->
    case lists:any(fun(X) -> X#book.name == Book end,Library) of
 		true ->
            BookToBorrow = lists:keyfind(Book, #book.name,Library),
            io:format("Borrowed book ~p ~n", [BookToBorrow]),
            NewLibrary =lists:keystore(Book,#book.name,Library,book_handler:borrow_book(BookToBorrow)),
            {reply, BookToBorrow, {NewLibrary, Clients}};
 		false ->
            NewLibrary = Library,
 			io:format("There's no such book in library ~p ~n", [Book]),
            {reply, not_found, {NewLibrary, Clients}}
 	end;

handle_call({return, Book}, _From, {Library, Clients}) ->
     case lists:any(fun(X) -> X#book.name == Book end,Library) of
 		true ->
            BookToReturn = lists:keyfind(Book, #book.name,Library),
            io:format("Returned book ~p ~n", [BookToReturn]),
            NewLibrary =lists:keystore(Book,#book.name,Library,book_handler:return_book(BookToReturn));

 		false ->
            NewLibrary = Library,
 			io:format("There's no such book in library ~p ~n", [Book])
 	end,
    {reply, ok, {NewLibrary, Clients}};

handle_call({delete, Book}, _From, {Library, Clients}) ->
	case lists:any(fun(X) -> X#book.name == Book end,Library) of
 		true ->
            BookToDelete = lists:keyfind(Book, #book.name,Library),
            io:format("Deleted book ~p ~n", [BookToDelete]),
            NewLibrary = lists:delete(BookToDelete,Library);

 		false ->
            NewLibrary = Library,
 			io:format("There's no such book in library ~p ~n", [Book])
 	end,
    {reply, ok, {NewLibrary, Clients}}.

handle_cast(_Message, {Library, Clients}) -> {noreply, {Library, Clients}}.
handle_info(_Message, {Library, Clients}) -> {noreply, {Library, Clients}}.
code_change(_OldVersion, {Library, Clients}, _Extra) -> {ok, {Library, Clients}}.
terminate(_Reason, _State) -> ok.