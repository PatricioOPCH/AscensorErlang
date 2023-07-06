-module(ascensor).
-behaviour(gen_statem).
-compile(export_all).
%%-export([start/2,stop/0,ver_semaforo/0]).

-define(TIEMPO_EN_AMARILLO, 3000). %% tiempo en 2 segundos

-record(state, {
    tiempo_verde :: pos_integer(),
    tiempo_rojo :: pos_integer()
}).

start() ->
    TiempoVerde = 3000,
    TiempoRojo = 3000,
    gen_statem:start({local, ?MODULE}, ?MODULE, [TiempoVerde, TiempoRojo], []).

stop() ->
    gen_statem:stop(?MODULE).

callback_mode() ->
    handle_event_function.

init([TiempoRojo, TiempoVerde]) ->
    io:format("Estoy en el primer piso ~n", []),
    {ok, piso_uno, #state{
        tiempo_verde = TiempoVerde,
        tiempo_rojo = TiempoRojo
    }, [{state_timeout, TiempoRojo, {subir, piso}}]}.

ver_piso() ->
    gen_statem:call(?MODULE, ver_piso).

% handle_event(state_timeout, {subir, piso}, piso_uno, State) ->
%     Piso = 1,
%     File = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt",

%     case file:read_file(File) of
%         {ok, <<"3">>} -> % Si el contenido del archivo es "3"
%             io:format("Contenido del archivo es '3'. Cambia a piso_uno ~n", []),
%             Numero = ver_piso_decimal(),
%             io:format("Cambia a piso_dos ~n", [Numero]),
%             {next_state, piso_dos, State, [{state_timeout, State#state.tiempo_verde,{subir, piso}}]};
%         {ok, _} -> % Si el contenido del archivo no es "3"
%             io:format("Contenido del archivo no es '3'. Cambia a piso_dos ~n", []),
%             io:format("Cambia a piso_cuatro ~n", []),
%             {next_state, piso_cuatro, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]}
%     end;

handle_event(state_timeout, {subir, piso}, piso_uno, State) ->
    Piso = 1,
    File = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt",

    case file:read_file(File) of
        {ok, Contenido} ->
            case verify_content(Contenido, Piso) of
                true ->
                    Cambio = "2",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    %io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es mayor a ~w. Cambia a piso_dos ~n", [Piso]),
                    {next_state, piso_dos, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]};
                false ->
                    io:format("Contenido del archivo no es mayor a ~w. Se mantiene el el piso uno ~n", [Piso]),
                    {next_state, piso_uno, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]}
            end;
        _ ->
            io:format("Error al leer el archivo. ~n", []),
            {next_state, piso_uno, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]}
    end;


handle_event(state_timeout, {subir, piso}, piso_dos, State) ->
    % Piso = 2,
    % io:format("Cambia a piso_tres ~n", []),
    % {next_state, piso_tres, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]};
    Piso = 2,
    File = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt",

    case file:read_file(File) of
        {ok, Contenido} ->
            case verify_content1(Contenido, Piso)of
                "mayor"->
                    Cambio = "3",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es mayor a ~w. Cambia subiendo a piso_tres ~n", [Piso]),
                    {next_state, piso_tres, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]};
                "menor" ->
                    Cambio = "1",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es menor a ~w. Cambia bajando a piso_tres ~n", [Piso]),
                    {next_state, piso_uno, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]};
                "igual" ->
                    io:format("Contenido del archivo es igual a ~w. Se mantiene el el piso dos ~n", [Piso]),
                    {next_state, piso_dos, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]}
            end;
        _ ->
            io:format("Error al leer el archivo. ~n", []),
            {next_state, piso_dos, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]}
    end;




handle_event(state_timeout, {subir, piso}, piso_tres, State) ->
    % io:format("Cambia a piso_cuatro ~n", []),
    % {next_state, piso_cuatro, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]};
    Piso = 3,
    File = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt",

    case file:read_file(File) of
        {ok, Contenido} ->
            case verify_content1(Contenido, Piso) of
                "mayor" ->
                    Cambio = "4",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es mayor a ~w. Cambia a piso_cuatro ~n", [Piso]),
                    {next_state, piso_cuatro, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]};
                "menor" ->
                    Cambio = "2",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es menor a ~w. Cambia bajando a piso_dos ~n", [Piso]),
                    {next_state, piso_dos, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]};
                "igual" ->
                    io:format("Contenido del archivo es igual a ~w. Se mantiene el el piso tres ~n", [Piso]),
                    {next_state, piso_tres, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]}
            end;
        _ ->
            io:format("Error al leer el archivo. ~n", []),
            {next_state, piso_tres, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]}
    end;

handle_event(state_timeout,{bajar, piso}, piso_cuatro, State) ->
    % io:format("Cambia a piso_tres~n", []),
    % {next_state, piso_tres, State, [{state_timeout, State#state.tiempo_verde,{bajar, piso}}]};
    Piso = 4,
    File = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt",

    case file:read_file(File) of
        {ok, Contenido} ->
            case verify_content_Bajada(Contenido, Piso) of
                true ->
                    Cambio = "3",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es menor a ~w. Cambia a piso_tres.. ~n", [Piso]),
                    {next_state, piso_tres, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]};
                false ->
                    io:format("Contenido del archivo no es mayor a ~w. Se mantiene el el piso cuatro ~n", [Piso]),
                    {next_state, piso_cuatro, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]}
            end;
        _ ->
            io:format("Error al leer el archivo. ~n", []),
            {next_state, piso_cuatro, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]}
    end;

handle_event(state_timeout, {bajar, piso}, piso_tres, State) ->
    % io:format("Cambia a piso_dos ~n", []),
    % {next_state, piso_dos, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]};
    Piso = 3,
    File = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt",

    case file:read_file(File) of
        {ok, Contenido} ->
            case verify_content1(Contenido, Piso) of
                "mayor" ->
                    Cambio = "4",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es mayor a ~w. Cambia subiendo a piso_cuatro.. ~n", [Piso]),
                    {next_state, piso_cuatro, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]};
                "menor" ->
                    Cambio = "2",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es menor a ~w. Cambia a piso_dos.. ~n", [Piso]),
                    {next_state, piso_dos, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]};
                "igual" ->
                    io:format("Contenido del archivo no es mayor a ~w. Se mantiene el el piso tres ~n", [Piso]),
                    {next_state, piso_tres, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]}
            end;
        _ ->
            io:format("Error al leer el archivo. ~n", []),
            {next_state, piso_tres, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]}
    end;

handle_event(state_timeout, {bajar, piso},piso_dos, State) ->
    % io:format("Cambia a piso_uno ~n", []),
    % {next_state, piso_uno, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]};
    Piso = 2,
    File = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/data.txt",

    case file:read_file(File) of
        {ok, Contenido} ->
            case verify_content1(Contenido, Piso) of
                "mayor" ->
                    Cambio = "3",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es menor a ~w. Cambia subiendo a piso_tres... ~n", [Piso]),
                    {next_state, piso_uno, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]};
                "menor" ->
                    Cambio = "1",
                    File2 = "/home/patricio/Documentos/Cowboy/ascensor/src/tmp/planta.txt",
                    ok = file:write_file(File2, Cambio),
                    io:format("Planta: ~s~n", [Cambio]),
                    io:format("Contenido del archivo es menor a ~w. Cambia a piso_uno... ~n", [Piso]),
                    {next_state, piso_uno, State, [{state_timeout, State#state.tiempo_verde, {subir, piso}}]};
                "igual" ->
                    io:format("Contenido del archivo no es mayor a ~w. Se mantiene el el piso dos ~n", [Piso]),
                    {next_state, piso_dos, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]}
            end;
        _ ->
            io:format("Error al leer el archivo. ~n", []),
            {next_state, piso_dos, State, [{state_timeout, State#state.tiempo_verde, {bajar, piso}}]}
    end;

handle_event({call,From},ver_piso,StateName,_StateData) ->
    {keep_state_and_data,[{reply,From, StateName}]}.

ver_piso_decimal() ->
    Piso = ver_piso(),
    case Piso of
        "piso_uno" -> 1;
        "piso_dos" -> 2;
        "piso_tres" -> 3;
        "piso_cuatro" -> 4
    end.

verify_content(Contenido, Piso) when is_binary(Contenido) ->
    case list_to_integer(binary_to_list(Contenido)) > Piso of
        true -> true;
        false -> false
    end.

verify_content_Bajada(Contenido, Piso) when is_binary(Contenido) ->
    case list_to_integer(binary_to_list(Contenido)) < Piso of
        true -> true;
        false -> false
    end.

verify_content1(Contenido, Piso) when is_binary(Contenido) ->
    case list_to_integer(binary_to_list(Contenido)) of
        C when C > Piso -> "mayor";
        C when C < Piso -> "menor";
        _ -> "igual"
    end.
