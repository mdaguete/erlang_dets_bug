%% Copyright
-module(dets_test_server2).
-author("mdaguete").

-behaviour(gen_server).

%% API
-export([start_link/0]).
-export([save/1]).
-export([read/1]).
-export([delete_all/0]).
-export([info/1]).

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

read(K) ->
  gen_server:call(?MODULE,{read,K},infinity).

info(Text) ->
  gen_server:call(?MODULE,{info,Text},infinity).


delete_all() ->
  gen_server:call(?MODULE,{delete_all},infinity).

init(_Args) ->
  {ok,Name} = dets:open_file(test2,[{file,"dets_test2.q"},{repair,force},{type,set}]),
  {ok, #state{queue=Name}}.

handle_call({delete_all},_From,#state{queue=Q} = State) ->
  dets:delete_all_objects(Q),
  {reply,ok,State};
handle_call({save,{K,V}},_From,#state{queue=Q} = State) ->
  dets:insert(Q,{K,0,V}),
  {reply,ok,State};
handle_call({read,K},_From, #state{queue=Q} = State) ->
  ok = dets:delete(Q,K),
  {reply,ok,State};
handle_call({info,Text},_From, #state{queue=Tab} = State) ->
  io:format("DETS info for ~p after ~p:\n",[Tab,Text]),
  io:format("\tFile Size: ~p~n",[dets:info(Tab,file_size)]),
  io:format("\tNumber Objects Stored: ~p~n",[dets:info(Tab,no_objects)]),
  {reply,ok,State};
handle_call(_Request, _From, State) ->
  {noreply, State}.



handle_cast({info,Text}, #state{queue={_,_,Tab}} = State) ->
  io:format("DETS info for ~p after ~p:\n",[Tab,Text]),
  io:format("\tFile Size: ~p~n",[dets:info(Tab,file_size)]),
  io:format("\tNumber Objects Stored: ~p~n",[dets:info(Tab,no_objects)]),
  {noreply, State}.


handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

