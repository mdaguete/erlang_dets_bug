ERL			?= erl
ERL			= erlc
EBIN_DIRS		:= $(wildcard deps/*/ebin)

.PHONY: rel deps

all: compile

clean_queue: 
	@rm -f *.q		

clean_code: 
	@rm -f ebin/*beam
compile:
	@erl -make


test: clean_queue clean_code compile
	@erl -pa ebin  -eval 'io:format("OTP Version ~p\n",[erlang:system_info(otp_release)]), dets_test:test(10,dets_test_server),halt().' -noshell
	@rm -f *.q

test2: clean_queue clean_code compile
	@erl -pa ebin  -eval 'io:format("OTP Version ~p\n",[erlang:system_info(otp_release)]), dets_test:test(10,dets_test_server2),halt().' -noshell
	@rm -f *.q

	
traverse_test: clean_queue clean_code compile
	@erl -pa ebin  -eval 'io:format("OTP Version ~p\n",[erlang:system_info(otp_release)]), dets_test:traverse_test(10),halt().' -noshell	
	@rm -f *.q

	
no_traverse_test: clean_queue clean_code compile
	@erl -pa ebin  -eval 'io:format("OTP Version ~p\n",[erlang:system_info(otp_release)]), dets_test:no_traverse_test(10),halt().' -noshell	
	@rm -f *.q
