type role = [ `Chair | `Co_chair ]

let role_to_string = function `Chair -> "chair" | `Co_chair -> "co-chair"

let role_of_string = function
  | "chair" -> `Chair
  | "co-chair" -> `Co_chair
  | _ -> raise (Invalid_argument "Unknown role type")

type important_date = { date : string; info : string }

type committee_member = {
  name : string;
  role : string option;
  affiliation : string option;
}

type presentation = {
  title : string;
  authors : string list;
  link : string option;
  video : string option;
  slides : string option;
  additional_links : string list option;
}

type t = {
  title : string;
  location : string option;
  date : string;
  online : bool;
  important_dates : important_date list;
  presentations : presentation list;
  program_committee : committee_member list;
  organising_committee : committee_member list;
}
