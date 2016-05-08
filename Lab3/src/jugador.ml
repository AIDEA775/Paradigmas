open Cartas
open Varios

type jugador = {nombre : string; puntos : int; mano : carta option; mazo : cartas};;

let crear_jugador (n : string) (c : cartas) : jugador * cartas =
  let m = crear_mazo c in
  ({nombre = n ; puntos = 0; mano = None; mazo = m}, (sacar_cartas c m));;

let jugador_puntos (j : jugador) : int = j.puntos;;

let jugador_nombre (j : jugador) : string = j.nombre;;

let jugador_suma_punto (j : jugador) : jugador = {j with puntos = j.puntos + 1};;

let jugador_imprimir_ronda (j : jugador) : unit =
  let open Printf in
  match j.mano with
  | None -> unit
  | Some c -> printf "    %s  %s\n" (j.nombre) (string_of_carta c);;

let rec jugador_juega (j : jugador) (cs : cartas) : jugador * cartas =
  (* imprime por stdout "<Nombre>(<Puntos>): <Cartas disponibles>/n<Pregunta>" *)
  let open Printf in
  printf "\n    %s(%d): %s\n    Que carta vas a jugar %s?\n\n        " (j.nombre) (j.puntos) (carta_to_string j.mazo) (j.nombre);
  let s = leer_palabra() in
  (* sacar carta del mazo cs y guardar en el mazo del jugador
      mazo general -> mazo del jugador -> general * jugador *)
  let robar (cs : cartas) (m : cartas): cartas * cartas =
    let c = primer_carta cs in (* ver carta del mazo general *)
    match c with
    | None -> (cs, m)
    | Some c -> let cs = sacar_cartas cs (mazo c) in (* quitar la carta del mazo genera*)
                let m = poner_cartas m (mazo c) in (* guardarla en el mazo del jugador *)
                (cs, m)
  in
  let jugar_comun (j : jugador) (cs : cartas) (c : carta) : jugador * cartas =
    let m = sacar_cartas j.mazo [c] in (* tirar carta *)
    let cs, m = robar cs m in (* levantar del mazo general *)
    ({j with mano = c; mazo = (Some m)}, cs)
  in
  let c = carta_of_string j.mazo s in
  match c with
  | None -> jugador_juega j cs
  | Some c -> jugar_comun j cs c;;

  (* juega carta especial y luego juega una comun *)
  (*let jugar_especial : jugador * cartas =
    match s with
    | "SID" ->  let m = sacar_cartas j.mazo c in
                let cs, m = robar cs m in
                jugar_comun {j with mazo = m} cs
  in
    | "SWAP" -> jugar_comun {j with mazo = cs} m
    | "SMAX" -> let max = carta_maxima cs in
                let cs = sacar_cartas [max] in
                let m = poner_cartas m [max] in
                jugar_comun {j with mazo = m} cs
    | "SMIN" -> let min = carta_minima m in
    | "STOP" -> expr2
    | "SPAR" -> expr2;*)

let jugador_carta_jugada (j : jugador) : carta option = j.mano;;

let jugador_quedan_cartas (j : jugador) : bool = (cartas_cantidad j.mazo) != 0;;

let jugador_limpiar_carta (j : jugador) : jugador = {j with mano = None};;
