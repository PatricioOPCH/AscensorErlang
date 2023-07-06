-module(test_handler).


-behavior(cowboy_handler).

-import(file, [read_file/1]).

-export([init/2]).
-export([content_types_provided/2]).
-export([hello_to_html/2]).
-export([hello_to_json/2]).
-export([hello_to_text/2]).
-export([options/2]).

options(Req0,State) ->
    Req1 = cowboy_req: set_resp_header(<<"access-control-allow-origin">>, <<"GET, OPTIONS">>, Req0),
    Req2 = cowboy_req: set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
    Req3 = cowboy_req: set_resp_header(<<"access-control-allow-origin">>, <<"authorization">>, Req2),
    {ok,Req3,State}.

init(Req, Opts) ->
    {cowboy_rest,Req,Opts}.

content_types_provided(Req,State) ->
    {[
        {<<"application/json">> , hello_to_json}
        ],Req, State}.

hello_to_html(Req, State) ->
    Body = <<"<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">    
    <title>REST HOLLOW WORDD</title>
</head>
<body>
    <p>REST HELLO WORD AS HTML!</p>
</body>
</html>
">>,
    {Body, Req, State}.

hello_to_json(Req, State) ->
    %{ok, S} = file:open("/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt", [read]),
    %{ok, Color} = io:get_line(S, ''),
    {ok, Binary} = file:read_file("/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt"),
    Piso= binary_to_list(Binary),
    io:format("Contenido del archivo: ~s~n", [Piso]),
    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req),
    
    Body = "{\"piso\":\"" ++ Piso ++ "\"}",
    {Body, Req1, State}.
hello_to_text(Req,State) ->
    {<<"REST HELLO WORD">>,Req,State}.