%% Copyright
-module(dets_test).


%% API
-export([test/1]).
-export([writer/1]).
-export([empty/0]).


test(N) ->
  application:start(dets_test),
  %Now Write 1 object with 500 KB size
  writer(N),
  %Print info about dets file.
  dets_info(dets_test,N),
  %Now empty
  empty(),
  %info
  dets_info(dets_test,"emptied"),
  %Now  reload again
  writer(N),
  %Info
  dets_info(dets_test,"reloaded"),
  empty(),
  dets_info(dets_test,"last emptied").






dets_info(Tab,State) ->
  io:format("DETS info for ~p after ~p:\n",[Tab,State]),
  io:format("\tFile Size: ~p~n",[dets:info(Tab,file_size)]),
  io:format("\tNumber Objects Stored: ~p~n",[dets:info(Tab,no_objects)]),
  ok.


writer(Number) ->
  Data = generate_data(),
  lists:map(
    fun(_) ->
      dets_test_server:save(Data)
    end,
    lists:seq(1,Number)
  ).



empty() ->
  empty(dets_test_server:read()).


empty(empty) ->
  empty;
empty({value,_}) ->
  empty().

generate_data() ->
  {ok,Bin} = file:read_file("test_file"),
  Bin.

