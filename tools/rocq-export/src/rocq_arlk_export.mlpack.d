src/rocq_arlk_export_MLPACK_DEPENDENCIES:=src/arlk_export_main src/arlk_export
src/arlk_export_main.cmx : FOR_PACK=-for-pack Rocq_arlk_export
src/arlk_export.cmx : FOR_PACK=-for-pack Rocq_arlk_export
src/rocq_arlk_export.cmo:$(addsuffix .cmo,$(src/rocq_arlk_export_MLPACK_DEPENDENCIES))
src/rocq_arlk_export.cmx:$(addsuffix .cmx,$(src/rocq_arlk_export_MLPACK_DEPENDENCIES))
