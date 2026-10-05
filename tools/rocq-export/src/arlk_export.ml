
# 3 "src/arlk_export.mlg"
 
open Stdarg

# 7 "src/arlk_export.ml"

let () = Vernacextend.static_vernac_extend ~plugin:(Some "rocq-arlk-export.plugin") ~command:"ArlkExport" ~classifier:(fun ~atts:_ _ -> Vernacextend.classify_as_query) ~ignore_kw:false ?entry:None 
         [(Vernacextend.TyML
         (false,
          Vernacextend.TyTerminal
          ("Arlk",
           Vernacextend.TyTerminal
           ("Export",
            Vernacextend.TyNonTerminal (Extend.TUentry (Genarg.get_arg_tag wit_string),
            Vernacextend.TyNonTerminal (Extend.TUlist1 (Extend.TUentry (Genarg.get_arg_tag wit_reference)),
            Vernacextend.TyNil)))),
          (let coqpp_body file rs () =
            Vernactypes.vtopaqueaccess (fun ~opaque_access -> (
# 9 "src/arlk_export.mlg"
    fun ~opaque_access -> Arlk_export_main.run opaque_access file rs 
# 23 "src/arlk_export.ml"
)
            ~opaque_access) in fun file rs ?loc ~atts () ->
            coqpp_body file rs (Attributes.unsupported_attributes atts)),
          None))]

