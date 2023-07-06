-module(elevador).
-behaviour(gen_statem).
-compile(export_all).

-record(state, {
    current_floor :: non_neg_integer()
}).

-export([start/0, stop/0, select_floor/1, ver_piso/0]).

start() ->
    gen_statem:start({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_statem:stop(?MODULE).

select_floor(Floor) ->
    gen_statem:cast(?MODULE, {select_floor, Floor}).

ver_piso() ->
    gen_statem:call(?MODULE, ver_piso, infinity).

callback_mode() ->
    handle_event_function.

init([]) ->
    {ok, floor_1, #state{current_floor = 1}, [{state_timeout, 2000, read_floor}]}.

handle_event(_, {select_floor, Floor}, StateName, StateData) ->
    io:format("Selected floor: ~B~n", [Floor]),
    {next_state, StateName, StateData};

handle_event(_, read_floor, StateName, StateData) ->
    FloorFile = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
    {ok, Floor} = file:read_file(FloorFile),
    ParsedFloor = list_to_integer(binary_to_list(Floor)),
    io:format("Read floor from file: ~B~n", [ParsedFloor]),
    {next_state, StateName, StateData#state{current_floor = ParsedFloor}, [{state_timeout, 2000, read_floor}]};

% handle_event(_, Event, StateName, StateData) ->
%     io:format("Unexpected event: ~p~n", [Event]),
%     {next_state, StateName, StateData}
handle_event({call,From},ver_piso,StateName,_StateData) ->
    {keep_state_and_data,[{reply,From, StateName}]}.

handle_info(_, StateName, StateData) ->
    io:format("Current state: ~p~n", [StateName]),
    {next_state, StateName, StateData}.

% handle_call(ver_piso, _From, StateName, _StateData) ->
%     {reply, StateName, StateName}.

terminate(_Reason, _StateName, _StateData) ->
    ok.

code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.
