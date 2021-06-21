type role =
  [ `Chair
  | `Co_chair
  ]
[@@deriving yaml]

type important_date = Ood.Workshop.important_date =
  { date : string
  ; info : string
  }
[@@deriving yaml]

type committee_member = Ood.Workshop.committee_member =
  { name : string
  ; role : string option
  ; affiliation : string option
  }
[@@deriving yaml]

type presentation = Ood.Workshop.presentation =
  { title : string
  ; authors : string list
  ; link : string option
  ; video : string option
  ; slides : string option
  ; additional_links : string list option
  }
[@@deriving yaml]

type metadata = Ood.Workshop.t =
  { title : string
  ; location : string option
  ; date : string
  ; online : bool
  ; important_dates : important_date list
  ; presentations : presentation list
  ; program_committee : committee_member list
  ; organising_committee : committee_member list
  }
[@@deriving yaml]

type t =
  { title : string
  ; location : string option
  ; date : string
  ; online : bool
  ; important_dates : important_date list
  ; presentations : presentation list
  ; program_committee : committee_member list
  ; organising_committee : committee_member list
  ; body : string
  }

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      let body = Omd.of_string body |> Omd.to_html in
      { title = metadata.title
      ; location = metadata.location
      ; date = metadata.date
      ; online = metadata.online
      ; important_dates = metadata.important_dates
      ; presentations = metadata.presentations
      ; program_committee = metadata.program_committee
      ; organising_committee = metadata.organising_committee
      ; body
      })
    "workshops/en"

let slug (t : t) = Utils.slugify t.title

let get_by_slug id = all () |> List.find_opt (fun t -> slug t = id)
