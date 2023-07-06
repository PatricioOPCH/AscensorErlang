-module(file_handler).
-behavior(cowboy_handler).
-export([handle/2]).
-export([init/2]).
-export([content_types_provided/2]).
-export([hello_to_json/2]).

-import(file, [read_file/1]).

init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

content_types_provided(Req, State) ->
    {[
        {<<"application/json">>,hello_to_json}
    ], Req, State}.

handle(Req, _Opts) ->
    %{ok, QueryParams, _Body} = cowboy_req:parse_qs(Req),
    %Datos = proplists:get_value(<<"datos">>, QueryParams, <<>>),
    %io:format("Datos recibidos: ~s~n", [Datos]),
    {ok, Req, []}.

hello_to_json(Req, State) ->
    Qs = cowboy_req:qs(Req),
    %Datos = proplists:get_value(<<"datos">>, Qs, undefined),
    io:format("Valor del parámetro 'datos': ~p~n", [Qs]),

    % Sobrescribir el archivo de texto en una ruta
    File = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt",
    ok = file:write_file(File, Qs),

    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req),
    Body = <<"{\"piso\":\" uno \"}">>,
    io:format("Contenido del cuerpo de respuesta: ~s~n", [binary_to_list(Body)]),
    {Body, Req1, State}.
