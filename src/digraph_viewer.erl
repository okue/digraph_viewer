-module(digraph_viewer).

-export([register/1, register/2, graph_data/0]).

register(G) ->
  do_register(G, null).
register(G, Name) ->
  do_register(G, Name).

graph_data() ->
  Graphs = call_server({list}),
  lists:map(fun({Uuid, G, Name}) -> 
    Id = uuid:uuid_to_string(Uuid, binary_standard),
    Info = digraph:info(G),
    Vertices = collect_vertices(G),
    Edges = collect_edges(G),
    {[{id, Id}, {name, Name}] ++ Info ++ [{vertices, Vertices}, {edges, Edges}]}
  end, Graphs).

call_server(Request) ->
   gen_server:call(graph_tracker, Request).   
   
collect_vertices(G) ->
  Vertices = digraph:vertices(G),
  lists:map(fun(Id) -> 
    IdStr = format_term(Id),
    {[{id, IdStr}]} end, Vertices).

collect_edges(G) ->
  Edges = digraph:edges(G),
  lists:map(fun(E) ->
    {_E, Source, Target, B} = digraph:edge(G, E),
    Id = format_term(B),
    Src = format_term(Source),
    Trgt = format_term(Target),
    {[{id, Id}, {source, Src}, {target, Trgt}]}
  end, Edges).

do_register(G, Name) ->
  gen_server:cast(graph_tracker, {register, G, Name}).

format_term(Term) ->
  R = io_lib:format("~p",[Term]),
  L = lists:flatten(R),
  iolist_to_binary(L).
