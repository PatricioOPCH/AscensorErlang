%%%-------------------------------------------------------------------
%% @doc ascensor public API
%% @end
%%%-------------------------------------------------------------------

-module(ascensor_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
            {'_', [{"/", ascensor_handler, []},
            {"/second", test_handler, []},
            {"/ascensor", test2_handler, []},
            {"/file/[...]", file_handler, []}
            %{"/file/[...]", {ascensor_app, handle_request}, []}

        ]}
        ]),
    
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
        ),    

    ascensor_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
