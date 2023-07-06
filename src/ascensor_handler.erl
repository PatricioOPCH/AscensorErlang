-module(ascensor_handler).

-behavior(cowboy_handler).

-export([init/2]).

%init(Req0, State) ->
    %% Default body, replace with required behaviour 
    %% See https://ninenines.eu/docs/en/cowboy/2.6/guide/handlers/
%   	Req = cowboy_req:reply(200,
%        #{<<"content-type">> => <<"text/plain">>},
%        <<"Response body - replace me\n">>,
%        Req0),
%    {ok, Req, State}.


init(Req0, State) ->
    Path = cowboy_req:path(Req0),
    case Path of
        <<"/">> ->
            Req = cowboy_req:reply(200,
                #{<<"content-type">> => <<"text/plain">>},
                <<"Response body ppppppppppp\n">>,
                Req0),
            {ok, Req, State};
        <<"/second">> ->
            %{ok,S}=file:open("./tmp/planta.txt", [read]),
            %{ok, File} = file:open("./tmp/planta.txt", [read]),
            %read_lines(File),
            
            %Color= io:get_line(File, ''),
            %file:close(File),
            
             %= file:open("./tmp/planta.txt", [read]),
            
            %Req2 = cowboy_req:reply(200,
            %    #{<<"content-type">> => <<"text/plain">>},
            %    <<"Custom header set\n">>,
            %    Req1),
            %{Body,Req1,State} = mostrar_jason(Req0, State),
            {ok, File} = file:open("./tmp/planta.txt", [write, append]),
            io:fwrite(File, "~s~n", [3]),
            file:close(File),
            Body = "dede",
            file:close(File),
            Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req0),
            Req2 = cowboy_req:reply(200,
                #{<<"content-type">> => <<"application/json">>},
                Body,
                Req1),
            {ok, Req2, State};
        _ ->
            Req = cowboy_req:reply(404,
                #{<<"content-type">> => <<"text/plain">>},
                <<"Not found\n">>,
                Req0),
            {ok, Req, State}
    end.

mostrar_jason(Req, State) ->
    {ok, FilePath} = file:consult("/tmp/planta.txt"),
    {ok, File} = file:open(FilePath, [read, raw]),
    Color = get_first_line(File),
    file:close(File),
    Body = "{\"color\": \""++Color++"\"}",
    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req),
    {Body,Req1,State}.


get_first_line(File) ->
    case file:read_line(File) of
        {ok, Line} -> string:strip(Line, right);
        eof -> ""
    end.