ERL			?= erl
ERL			= erlc
EBIN_DIRS		:= $(wildcard deps/*/ebin)

.PHONY: rel deps

all: compile

clean_queue: 
	@rm -f dets_test.q		

clean_code: 
	@rm -f ebin/*beam
compile:
	@erl -make


test: clean_queue clean_code compile
	@erl -pa ebin  -eval 'io:format("OTP Version ~p\n",[erlang:system_info(otp_release)]), dets_test:test(10),halt().' -noshell
	

