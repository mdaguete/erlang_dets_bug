%% Copyright
-module(dets_test).


%% API
-export([test/2]).
-export([no_traverse_test/1]).
-export([traverse_test/1]).
-export([writer/2]).
-export([empty/1]).
-export([empty_all/0]).


test(N,Mod) ->
  application:start(dets_test),
  %Now Write 1 object with 500 KB size
  writer(N,Mod),
  %Print info about dets file.
  dets_info(N,Mod),
  %Now empty
  empty(N,Mod),
  %info
  dets_info("emptied",Mod),
  %Now  reload again
  writer(N,Mod),
  %Info
  dets_info("reloaded",Mod),
  empty(N,Mod),
  dets_info("last emptied",Mod).


traverse_test(N) ->
  {ok,Name} = dets:open_file(traverse,[{file,"dets_traverse.q"},{repair,force},{type,set}]),
  F = fun(X) -> {continue, X} end,
  dets:traverse(Name,F),
  %Now Write 1 object with 500 KB size
  dwriter(Name,N),
  %Print info about dets file.
  ddets_info(Name,N),
  %Now empty
  dempty(Name,N),
  %info
  ddets_info(Name,"emptied"),
  %Now  reload again
  dwriter(Name,N),
  %Info
  ddets_info(Name,"reloaded"),
  dempty(Name,N),
  ddets_info(Name,"last emptied"),
  dets:close(Name).

no_traverse_test(N) ->
  {ok,Name} = dets:open_file(no_traverse,[{file,"dets_no_traverse.q"},{repair,force},{type,set}]),
  %Now Write 1 object with 500 KB size
  dwriter(Name,N),
  %Print info about dets file.
  ddets_info(Name,N),
  %Now empty
  dempty(Name,N),
  %info
  ddets_info(Name,"emptied"),
  %Now  reload again
  dwriter(Name,N),
  %Info
  ddets_info(Name,"reloaded"),
  dempty(Name,N),
  ddets_info(Name,"last emptied"),
  dets:close(Name).


dets_info(Text,Mod) ->
  Mod:info(Text).


ddets_info(Tab,State) ->
  io:format("DETS info for ~p after ~p:\n",[Tab,State]),
  io:format("\tFile Size: ~p~n",[dets:info(Tab,file_size)]),
  io:format("\tNumber Objects Stored: ~p~n",[dets:info(Tab,no_objects)]),
  ok.

dwriter(Name,N) ->
  lists:map(
    fun(E) ->
      dets:insert(Name,[{E, generate_data()}])
    end,
    lists:seq(1,N)
  ).


writer(Number,Server) ->
  Data = generate_data(),
  lists:map(
    fun(E) ->
      Server:save({E,Data})
    end,
    lists:seq(1,Number)
  ).




empty(N,dets_test_server2) ->
  lists:map(
    fun(E) ->
      dets_test_server2:read(E)
    end,
    lists:seq(1,N)
  );
empty(_,_) ->
  empty(dets_test_server:read()).

dempty(Name,N) ->
  lists:map(
    fun(E) ->
      dets:delete(Name,E)
    end,
    lists:seq(1,N)
  ).


empty_all() ->
 dets_test_server:delete_all().

empty(empty) ->
  empty;
empty({value,_}) ->
  empty(dets_test_server:read()).

generate_data() ->
  {ok,Bin} = file:read_file("test_file"),
  Bin.

