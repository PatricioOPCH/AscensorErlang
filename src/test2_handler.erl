-module(test2_handler).

-behavior(cowboy_handler).

-import(file, [read_file/1]).

-export([init/2]).
-export([content_types_provided/2]).
-export([hello_to_html/2]).
-export([hello_to_text/2]).
-export([options/2]).

options(Req0, State) ->
    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"GET, OPTIONS">>, Req0),
    Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
    Req3 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"authorization">>, Req2),
    {ok, Req3, State}.

init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

content_types_provided(Req, State) ->
    {[{<<"text/html">>, hello_to_html}], Req, State}.

hello_to_html(Req, State) ->
    {ok, Binary} = file:read_file("/home/patricio/Documentos/Cowboy/ascensor/src/tmp/ascensor.html"),
    Body = binary_to_list(Binary),
    {Body, Req, State}.

hello_to_text(Req, State) ->
    {<<"REST HELLO WORD">>, Req, State}.




% -module(test2_handler).
% -behavior(cowboy_handler).

% -import(file, [read_file/1]).
% -import(timer, [apply_interval/4]).

% -export([init/2]).
% -export([content_types_provided/2]).
% -export([hello_to_html/2]).
% -export([hello_to_json/2]).
% -export([hello_to_text/2]).
% -export([options/2]).

% -define(INTERVAL, 3000).

% options(Req0, State) ->
%     Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"GET, OPTIONS">>, Req0),
%     Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
%     Req3 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"authorization">>, Req2),
%     {ok, Req3, State}.

% init(Req, _Opts) ->
%     {ok, Req, undefined}.

% content_types_provided(Req, State) ->
%     {[
%         {<<"application/json">>, hello_to_json}
%     ], Req, State}.

% hello_to_html(Req, State) ->
%     {ok, Binary} = file:read_file("/home/patricio/Documentos/Cowboy/ascensor/src/tmp/ascensor.html"),
%     Body = binary_to_list(Binary),
%     {Body, Req, State}.

% hello_to_json(Req, State) ->
%     {ok, Binary} = file:read_file("/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt"),
%     Color = binary_to_list(Binary),
%     io:format("Contenido del archivo: ~s~n", [Color]),
%     Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req),
%     Body = "{\"color\":\"" ++ Color ++ "\"}",
    
%     case Color of
%         "3" ->
%             NewBody = string:replace(Body, "gray", "30%", [global]),
%             io:format("Valor del JSON: 3~n"),
%             {NewBody, Req1, State};
%         _ ->
%             io:format("Valor del JSON: No es 3~n"),
%             {Body, Req1, State}
%     end.

% hello_to_text(Req, State) ->
%     {<<"REST HELLO WORD">>, Req, State}.
