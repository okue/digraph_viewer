-module(graph_tracker).

-behaviour(gen_server).

-export([
  start_link/0,
  init/1,
  handle_call/3,
  handle_cast/2
]).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  quickrand:seed(),
  {ok, []}.

handle_call({list}, _From, State) ->
  {reply, State, State};
handle_call(_Request, _From, State) ->
  {reply, [], State}.

handle_cast({register, G, Name}, State) ->
  Uuid = uuid:get_v4_urandom(),
  NewState = [{Uuid, G, Name} | State],
  {noreply, NewState};
handle_cast(_Request, State) ->
  {noreply, State}.