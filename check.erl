#!/usr/bin/env escript
%% -*- erlang -*-

main(Args) ->
  Dependencies = gather_all(Args, dep),
  Sources = gather_all(Args, src),
  io:format("Dependencies: ~p~n", [Dependencies]),
  io:format("Sources: ~p~n", [Sources]),

  BehaviorToSpecMethods = lists:foldl(fun(Filename, Collector) -> Collector ++ gather(Filename) end, [], Dependencies),

  {Exported, MissingSpec} = lists:foldl(fun(Filename, {X, Y}) ->
    {XX, YY} = parse(Filename, BehaviorToSpecMethods),
    {X + XX, Y + YY}
                                        end, {0, 0}, Sources),

  io:format("Exported: ~p~n", [Exported]),
  io:format("Missing spec: ~p~n", [MissingSpec]).


gather_all([], _Mod) -> [];
gather_all([H | T], Mod) ->
  io:format("~p~n", [H]),
  {ok, Ts, _} = erl_scan:string(H),
  {ok, Arg} = erl_parse:parse_term(Ts),
  case Arg of
    {Mod, Dep} -> [Dep] ++ gather_all(T, Mod);
    {_, _} -> gather_all(T, Mod)
  end.


gather(DirOrFile) ->
  case filelib:is_dir(DirOrFile) of
    false -> [gather_single_file(DirOrFile)];
    _ -> gather_folder(DirOrFile)
  end.

gather_folder(Dir) ->
  case filename:basename(Dir) of
    "_build" -> [];
    "_checkouts" -> [];
    ".git" -> [];
    _ ->
      {ok, Filenames} = file:list_dir(Dir),
      lists:foldl(fun(Filename, Collector) ->
        Collector ++ gather(filename:join(Dir, Filename))
                  end, [], Filenames)
  end.

gather_single_file(File) ->
  Methods = case filename:extension(File) of
    ".erl" ->
      {ok, Forms} = epp:parse_file(File, []),
      get_behavior_methods(Forms);
    _ -> []
  end,
  Name = list_to_atom(filename:basename(filename:rootname(File))),
  {Name, Methods}.

get_behavior_methods([]) -> [];
get_behavior_methods([ {attribute, _, callback, Exported} | Rest]) ->
  {Fun, _Opts} = Exported,
  [Fun] ++ get_behavior_methods(Rest);
get_behavior_methods([_H | T]) ->
  get_behavior_methods(T).



parse(DirOrFile, BehaviorToSpecMethods) ->
  case filelib:is_dir(DirOrFile) of
    false -> parse_single_file(DirOrFile, BehaviorToSpecMethods);
    _ -> parse_folder(DirOrFile, BehaviorToSpecMethods)
  end.


parse_single_file(File, BehaviorToSpecMethods) ->
  case filename:extension(File) of
    ".erl" ->
      {ok, Forms} = epp:parse_file(File, []),
      ImplementedBehaviors = get_behaviors(Forms),
      Exported = get_exported(Forms),
      Specced = get_specced(Forms),
      Unspecced = filter_unspec(Exported, Specced, ImplementedBehaviors, BehaviorToSpecMethods),
      case Unspecced of
        [] -> ok;
        _ ->
         io:format("Unspecced in ~p:~n",[File]),
          lists:foreach(fun({FunName, FunArity}) -> io:format("  * [ ] ~p/~p~n", [FunName, FunArity]) end, Unspecced)
      end,
      {length(Exported), length(Unspecced)};
    _ -> {0, 0}
  end.

parse_folder(Dir, BehaviorToSpecMethods) ->
  case filename:basename(Dir) of
    "_build" -> {0,0};
    "_checkouts" -> {0,0};
    ".git" -> {0,0};
    _ -> 
      {ok, Filenames} = file:list_dir(Dir),
      lists:foldl(fun(Filename, {Exp, Missing}) ->
                      {X, Y} = parse(filename:join(Dir, Filename), BehaviorToSpecMethods),
                      {Exp + X, Missing + Y}
                end, {0, 0}, Filenames)
  end.


get_exported([]) -> [];
get_exported([ {attribute, _, export, Exported} | Rest]) ->
  Exported ++ get_exported(Rest);
get_exported([_H | T]) -> get_exported(T).

get_specced([]) -> [];
get_specced([ {attribute, _, spec, {Func, _}} | Rest]) ->
  [Func] ++ get_specced(Rest);
get_specced([_H | T]) -> get_specced(T).

get_behaviors([]) -> [];
get_behaviors([ {attribute, _, behavior, Behavior} | Rest]) ->
  [Behavior] ++ get_behaviors(Rest);
get_behaviors([ {attribute, _, behaviour, Behavior} | Rest]) ->
  [Behavior] ++ get_behaviors(Rest);
get_behaviors([_H | T]) ->
  get_behaviors(T).

filter_unspec(Exported, Specced, ImplementedBehaviors, BehaviorToSpecMethods) ->
  UnspeccedRaw = lists:filter(fun(ExportedFun) -> not lists:member(ExportedFun, Specced) end, Exported),

  lists:filter(fun(UnspeccedMethod) ->
    MergedMethods = lists:foldl(fun({Behavior, Methods}, AllMethods) ->
      case lists:member(Behavior, ImplementedBehaviors) of
        true -> Methods ++ AllMethods;
        _ -> AllMethods
      end
                                end, [], BehaviorToSpecMethods),
    not lists:member(UnspeccedMethod, MergedMethods)
               end, UnspeccedRaw).
