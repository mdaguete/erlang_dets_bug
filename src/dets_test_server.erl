%% Copyright
-module(dets_test_server).
-author("mdaguete").

-behaviour(gen_server).

%% API
-export([start_link/0]).
-export([save/1]).
-export([read/0]).

%% gen_server callbacks
-record(state, {queue}).


%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

%% API
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

save(Item) ->
  gen_server:call(?MODULE,{save,Item},infinity).

read() ->
  gen_server:call(?MODULE,{read},infinity).



init(_Args) ->
  {ok,Name} = dqueue:open("dets_test.q"),
  {ok, #state{queue=Name}}.

handle_call({save,Item},_From,#state{queue=Q} = State) ->
  NQ = dqueue:in(Item,Q),
  {reply,ok,State#state{queue=NQ}};
handle_call({read},_From, #state{queue=Q} = State) ->
  {Elem,NQ} = dqueue:out(Q),
  {reply,Elem,State#state{queue=NQ}};

handle_call(_Request, _From, State) ->
  {noreply, State}.



handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
