
# This directory contains SNES example programs for solving systems of
# nonlinear equations.  

#CPPFLAGS	 = -I/PETSc3/geodynamics/PetscSimulationsViewers/src
CFLAGS           =
FFLAGS		 =
CPPFLAGS         =
FPPFLAGS         =
LOCDIR		 = src/snes/examples/tutorials/
MANSEC           = SNES
EXAMPLESC	 = ex1.c ex2.c ex3.c ex4.c ex4tu.c ex5.c ex5s.c ex6.c ex7.c ex8.c \
                ex10.c ex12.c ex14.c ex18.c ex19.c ex19tu.c ex20.c ex21.c ex22.c \
                ex23.c ex24.c ex25.c ex26.c ex27.c ex28.c ex29.c ex30.c ex31.c \
                ex32.c ex38.c ex42.c ex43.c ex44.c ex45.c ex46.c ex48.c ex49.c \
                ex50.c ex51.c ex52.c ex53.c ex54.c ex55.c ex58.c ex59.c ex60.c \
                ex61.c ex61gen.c ex61view.c ex63.c ex64.c ex65.c
EXAMPLESF	 = ex1f.F ex5f.F ex5f90.F ex5f90t.F ex5fs.F ex39f90.F ex40f90.F
EXAMPLESCH	 = ex43-44.h
EXAMPLESFH       = ex5f.h
EXAMPLESMATLAB   = ex5m.m ex29view.m ex61genm.m ex61m.m
DIRS		 = ex10d

include variables
include rules

makeall: ex1 ex1f ex2 ex3 ex4 ex4tu ex5 ex5f ex5f90 ex6 ex7 ex8 ex10 \
         ex14 ex18 ex19 ex19tu ex20 ex21 ex22 ex23 ex24 ex25 \
         ex26 ex27 ex28 ex29 ex30 ex31 ex32 \
         ex38 ex39f90 ex40f90 ex42 ex43 ex44 ex45 ex46 ex47cu \
         ex48 ex49 ex50 ex51 ex52 ex53 ex54 ex55 ex58 \
         ex59 ex60 ex61 ex61gen ex61view ex63 ex64 ex65

runall: runex1 runex1f runex2 runex2_2 runex2_3 runex3 runex3_2 \
runex3_3 runex3_4 runex5 runex5_2 runex5_3 runex5_4  \
runex5_6 \
runex5f runex5f_2 runex5f_3 runex5f_5 runex5f90 runex5f90_2 \
runex5f90_3 runex5f90_4 runex5f90_5 runex6 runex6_2 \
runex14 runex14_2 runex50 \
runex50_4 runex50_5 runex19 runex19_2 runex19_3 runex19_4 runex19_5  \
runex19_6 runex19_fieldsplit_2 runex19_fieldsplit_3 runex19_fieldsplit_4 \
runex19_fieldsplit_mumps runex19_fieldsplit_hypre runex19_fieldsplit_redundant \
runex19_composite_fieldsplit runex19_composite_fieldsplit_bjacobi runex19_composite_fieldsplit_bjacobi_2 \
runex19_7 runex19_8 runex19_9 runex19_10 runex19_11 runex19_12  \
runex19_13 runex19_14 runex19_15 runex19_15a runex19_16 runex19_16a \
runex19_superlu runex19_superlu_equil runex19_superlu_dist runex19_superlu_dist_2 \
runex19_cusp runex21 runex22 runex23 runex25 runex25_2 runex27 \
runex27_p runex27_li runex28_0 runex28_1 runex28_2 runex28_3 \
runex32 runex32_2 runex32_3 runex32_4 runex42 runex44 runex44_2 \
runex45 runex45_2 runex45_3 runex47cu runex48 runex48_2 runex48_3 runex48_4

ex1: ex1.o  
	-${CLINKER} -o ex1 ex1.o ${PETSC_SNES_LIB}
ex1f: ex1f.o  
	-${FLINKER} -o ex1f ex1f.o ${PETSC_SNES_LIB}
ex1f90: ex1f90.o  
	-${FLINKER} -o ex1f90 ex1f90.o ${PETSC_SNES_LIB}
ex2: ex2.o  
	-${CLINKER} -o ex2 ex2.o ${PETSC_SNES_LIB}
ex3: ex3.o  
	-${CLINKER} -o ex3 ex3.o ${PETSC_SNES_LIB}
ex4: ex4.o  
	-${CLINKER} -o ex4 ex4.o ${PETSC_SNES_LIB}
ex4tu: ex4tu.o  
	-${CLINKER} -o ex4tu ex4tu.o ${PETSC_SNES_LIB}
ex5: ex5.o 
	-${CLINKER} -o ex5 ex5.o ${PETSC_SNES_LIB}
ex5f: ex5f.o  
	-${FLINKER} -o ex5f ex5f.o ${PETSC_SNES_LIB}
#
#  The SGI parallelizing compiler generates incorrect code by treating 
#  the math functions (such as sqrt and exp) as local variables. The 
#  sed below patches this.
#
ex5s: 
	@if [ "${PETSC_ARCH}" != "IRIX64" ]; then echo "Only for PETSC_ARCH of IRIX64"; false ; fi
	-${CC} -pca keep  -WK,-lo=l ${FCONF} ${CFLAGS} -c ex5s.c
	sed "s/, sqrt/ /g"   ex5s.M | sed "s/, exp/ /g"  > ex5s_tmp.c
	-${CC} -mp ${PCC_FLAGS} ${CFLAGS} ${CCPPFLAGS} -c ex5s_tmp.c
	-${FC} -pfa keep -mp -64 ${FC_FLAGS} ${FFLAGS} ${FCPPFLAGS} -c ex5fs.F
	-${CLINKER} -mp -o ex5s ex5s_tmp.o ex5fs.o ${PETSC_SNES_LIB}
ex5f90: ex5f90.o  
	-${FLINKER} -o ex5f90 ex5f90.o ${PETSC_SNES_LIB}
ex5f90t: ex5f90t.o  
	-${FLINKER} -o ex5f90t ex5f90t.o ${PETSC_SNES_LIB}
ex6: ex6.o  
	-${CLINKER} -o ex6 ex6.o ${PETSC_SNES_LIB}
ex7: ex7.o  
	-${CLINKER} -o ex7 ex7.o -lsimviewers ${PETSC_SNES_LIB}
ex8: ex8.o 
	-${CLINKER} -o ex8 ex8.o -lsimviewers ${PETSC_SNES_LIB}
ex9: ex9.o 
	-${CLINKER} -o ex9 ex9.o ${PETSC_SNES_LIB}
ex10: ex10.o 
	-${CLINKER} -o ex10 ex10.o ${PETSC_SNES_LIB}
ex12: ex12.o 
	-${CLINKER} -o ex12 ex12.o ${PETSC_SNES_LIB}
ex13: ex13.o 
	-${CLINKER} -o ex13 ex13.o ${PETSC_SNES_LIB}
ex14: ex14.o 
	-${CLINKER} -o ex14 ex14.o ${PETSC_SNES_LIB}
ex15: ex15.o 
	-${CLINKER} -o ex15 ex15.o ${PETSC_SNES_LIB}
ex16: ex16.o 
	-${CLINKER} -o ex16 ex16.o ${PETSC_SNES_LIB}
ex17: ex17.o 
	-${CLINKER} -o ex17 ex17.o ${PETSC_SNES_LIB}
ex18: ex18.o 
	-${CLINKER} -o ex18 ex18.o ${PETSC_SNES_LIB}
ex19:  ex19.o 
	-${CLINKER} -o ex19  ex19.o ${PETSC_SNES_LIB}
ex19tu:  ex19tu.o 
	-${CLINKER} -o ex19tu  ex19tu.o ${PETSC_SNES_LIB}
ex20: ex20.o 
	-${CLINKER} -o ex20 ex20.o ${PETSC_SNES_LIB}
ex21: ex21.o 
	-${CLINKER} -o ex21 ex21.o ${PETSC_SNES_LIB}
ex22: ex22.o 
	-${CLINKER} -o ex22 ex22.o ${PETSC_SNES_LIB}
ex23: ex23.o 
	-${CLINKER} -o ex23 ex23.o ${PETSC_SNES_LIB}
ex24: ex24.o 
	-${CLINKER} -o ex24 ex24.o ${PETSC_SNES_LIB}
ex25: ex25.o 
	-${CLINKER} -o ex25 ex25.o ${PETSC_SNES_LIB}
ex26: ex26.o 
	-${CLINKER} -o ex26 ex26.o ${PETSC_SNES_LIB}
ex27: ex27.o 
	-${CLINKER} -o ex27 ex27.o ${PETSC_SNES_LIB}
ex28: ex28.o 
	-${CLINKER} -o ex28 ex28.o ${PETSC_SNES_LIB}
ex29: ex29.o 
	-${CLINKER} -o ex29 ex29.o ${PETSC_SNES_LIB}
ex30: ex30.o 
	-${CLINKER} -o ex30 ex30.o ${PETSC_SNES_LIB}
ex31: ex31.o 
	-${CLINKER} -o ex31 ex31.o ${PETSC_SNES_LIB}
ex32: ex32.o 
	-${CLINKER} -o ex32 ex32.o ${PETSC_SNES_LIB}
ex38: ex38.o  
	-${CLINKER} -o ex38 ex38.o ${PETSC_SNES_LIB}
ex39f90: ex39f90.o  
	-${FLINKER} -o ex39f90 ex39f90.o ${PETSC_SNES_LIB}
ex40f90: ex40f90.o  
	-${FLINKER} -o ex40f90 ex40f90.o ${PETSC_SNES_LIB}
ex41: ex41.o  
	-${CLINKER} -o ex41 ex41.o ${PETSC_SNES_LIB}
ex42: ex42.o  
	-${CLINKER} -o ex42 ex42.o ${PETSC_SNES_LIB}
ex43: ex43.o  
	-${CLINKER} -o ex43 ex43.o ${PETSC_SNES_LIB}
ex44: ex44.o  
	-${CLINKER} -o ex44 ex44.o ${PETSC_SNES_LIB}
ex45: ex45.o  
	-${CLINKER} -o ex45 ex45.o ${PETSC_SNES_LIB}
ex46: ex46.o  
	-${CLINKER} -o ex46 ex46.o ${PETSC_SNES_LIB}
ex47cu: ex47cu.o  
	-${CLINKER} -o ex47cu ex47cu.o ${PETSC_SNES_LIB}
ex48: ex48.o  
	-${CLINKER} -o ex48 ex48.o ${PETSC_SNES_LIB}
ex49: ex49.o  
	-${CLINKER} -o ex49 ex49.o ${PETSC_SNES_LIB}
ex50: ex50.o  
	-${CLINKER} -o ex50 ex50.o ${PETSC_SNES_LIB}
ex51: ex51.o  
	-${CLINKER} -o ex51 ex51.o ${PETSC_SNES_LIB}
ex52: ex52.o  
	-${CLINKER} -o ex52 ex52.o ${PETSC_SNES_SINGLE_LIB}
ex53: ex53.o  
	-${CLINKER} -o ex53 ex53.o ${PETSC_SNES_LIB}
ex54: ex54.o  
	-${CLINKER} -o ex54 ex54.o ${PETSC_SNES_LIB}
ex55: ex55.o  
	-${CLINKER} -o ex55 ex55.o ${PETSC_SNES_LIB}
ex56: ex56.o  
	-${CLINKER} -o ex56 ex56.o ${PETSC_SNES_LIB}
ex57: ex57.o  
	-${CLINKER} -o ex57 ex57.o ${PETSC_SNES_LIB}
ex58: ex58.o  
	-${CLINKER} -o ex58 ex58.o ${PETSC_SNES_LIB}
ex59: ex59.o  
	-${CLINKER} -o ex59 ex59.o ${PETSC_SNES_LIB}
ex60: ex60.o  
	-${CLINKER} -o ex60 ex60.o ${PETSC_SNES_LIB}
ex61: ex61.o  
	-${CLINKER} -o ex61 ex61.o ${PETSC_SNES_LIB}
ex61gen: ex61gen.o  
	-${CLINKER} -o ex61gen ex61gen.o ${PETSC_SNES_LIB}
ex61view: ex61view.o  
	-${CLINKER} -o ex61view ex61view.o ${PETSC_SNES_LIB}
ex62: ex62.o  
	-${CLINKER} -o ex62 ex62.o ${PETSC_SNES_LIB}
ex63: ex63.o  
	-${CLINKER} -o ex63 ex63.o ${PETSC_SNES_LIB}
ex64: ex64.o  
	-${CLINKER} -o ex64 ex64.o ${PETSC_SNES_LIB}
ex65: ex65.o  
	-${CLINKER} -o ex65 ex65.o ${PETSC_SNES_LIB}
#--------------------------------------------------------------------------
runex1:
	-@${MPIEXEC} -n 1 ./ex1 -ksp_gmres_cgs_refinement_type refine_always -snes_monitor_short > ex1_1.tmp 2>&1;   \
	   if (${DIFF} output/ex1_1.out ex1_1.tmp) then true; \
	   else echo "Possible problem with ex1_1, diffs above"; fi
runex1f:
	-@${MPIEXEC} -n 1 ./ex1f -ksp_gmres_cgs_refinement_type refine_always -snes_monitor_short > ex1f_1.tmp 2>&1;   \
	   if (${DIFF} output/ex1f_1.out ex1f_1.tmp) then true; \
	   else echo "Possible problem with ex1f_1, diffs above"; fi
runex2:
	-@${MPIEXEC} -n 1 ./ex2 -nox -snes_monitor_cancel -snes_monitor_short \
		 -snes_view -pc_type jacobi -ksp_gmres_cgs_refinement_type refine_always >ex2_1.tmp 2>&1;	\
	   if (${DIFF} output/ex2_1.out ex2_1.tmp) then true; \
	   else echo "Possible problem with ex2_1, diffs above"; fi
runex2_2:
	-@${MPIEXEC} -n 1 ./ex2 -nox -snes_monitor_cancel -snes_monitor_short \
		-snes_type tr -snes_view \
		-pc_type jacobi -ksp_gmres_cgs_refinement_type refine_always > ex2_2.tmp 2>&1; \
	   if (${DIFF} output/ex2_2.out ex2_2.tmp) then true; \
	   else echo "Possible problem with ex2_2, diffs above"; fi
runex2_3:
	-@${MPIEXEC} -n 1 ./ex2 -nox -snes_monitor_cancel -snes_monitor_short -malloc no \
		 -snes_view -pc_type jacobi -ksp_gmres_cgs_refinement_type refine_always >ex2_3.tmp 2>&1;	\
	   if (${DIFF} output/ex2_1.out ex2_3.tmp) then true; \
	   else echo "Possible problem with ex2_3, diffs above"; fi
runex3:
	-@${MPIEXEC} -n 1 ./ex3 -nox -snes_monitor_cancel -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex3_1.tmp 2>&1;	  \
	   if (${DIFF} output/ex3_1.out ex3_1.tmp) then true; \
	   else echo "Possible problem with ex3_1, diffs above"; fi
runex3_2:
	-@${MPIEXEC} -n 3 ./ex3 -nox -pc_type asm -mat_type mpiaij  \
	   -snes_monitor_cancel -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex3_2.tmp 2>&1; \
	   if (${DIFF} output/ex3_2.out ex3_2.tmp) then true; \
	   else echo "Possible problem with ex3_2, diffs above"; fi
runex3_3:
	-@${MPIEXEC} -n 2 ./ex3 -nox -snes_monitor_cancel -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex3_3.tmp 2>&1; \
	   if (${DIFF} output/ex3_3.out ex3_3.tmp) then true; \
	   else echo "Possible problem with ex3_3, diffs above"; fi
runex3_4:
	-@${MPIEXEC} -n 1 ./ex3 -nox -pre_check_iterates -post_check_iterates > ex3_4.tmp 2>&1; \
	   if (${DIFF} output/ex3_4.out ex3_4.tmp) then true; \
	   else echo "Possible problem with ex3_4, diffs above"; fi
runex5:
	-@${MPIEXEC} -n 1 ./ex5 -pc_type mg -ksp_monitor_short  -snes_view -pc_mg_levels 3 -pc_mg_galerkin -da_grid_x 17 -da_grid_y 17 \
                    -mg_levels_ksp_monitor_short -snes_monitor_short -mg_levels_pc_type sor -pc_mg_type full  > ex5_1.tmp 2>&1; \
	   if (${DIFF} output/ex5_1.out ex5_1.tmp) then true; \
	   else echo "Possible problem with ex5, diffs above"; fi
runex5_2:
	-@${MPIEXEC} -n 1 ./ex5   -pc_type mg -ksp_monitor_short  -snes_view -pc_mg_galerkin -snes_grid_sequence 3 \
                           -mg_levels_ksp_monitor_short -snes_monitor_short -mg_levels_pc_type sor -pc_mg_type full  > ex5_2.tmp 2>&1; \
	   if (${DIFF} output/ex5_2.out ex5_2.tmp) then true; \
	   else echo "Possible problem with ex5_2, diffs above"; fi
runex5_3:
	-@${MPIEXEC} -n 2 ./ex5 -snes_grid_sequence 2 -snes_monitor_short -ksp_monitor_short -snes_mf_operator -ksp_converged_reason \
           -snes_converged_reason -snes_view -pc_type mg    > ex5_3.tmp 2>&1; \
	   if (${DIFF} output/ex5_3.out ex5_3.tmp) then true; \
	   else echo "Possible problem with ex5_3, diffs above"; fi
runex5_4:
	-@${MPIEXEC} -n 2 ./ex5 -snes_grid_sequence 2 -snes_monitor_short -ksp_monitor_short -ksp_converged_reason \
           -snes_converged_reason -snes_view -pc_type mg    > ex5_4.tmp 2>&1; \
	   if (${DIFF} output/ex5_4.out ex5_4.tmp) then true; \
	   else echo "Possible problem with ex5_4, diffs above"; fi

runex5_5_ngmres:
	-@${MPIEXEC} -n 2 ./ex5 -da_grid_x 20 -da_grid_y 20 \
	-snes_type ngmres -npc_snes_picard_alpha 0.1 -npc_snes_picard quadratic -snes_monitor_short -snes_max_it 1000	 \
	-npc_snes_type picard -npc_snes_max_it 1 -snes_ngmres_m 30 -snes_ngmres_restart 1000 -snes_ngmres_debug 0 	\
	-par 6.0
runex5_5_picard:
	-@${MPIEXEC} -n 2 ./ex5 -da_grid_x 20 -da_grid_y 20 \
	-snes_type picard -snes_picard_alpha 0.1 -snes_picard quadratic -snes_monitor_short -snes_max_it 10000 \
	-par 6.0 
runex5_5_sorqn:
	-@${MPIEXEC} -n 2 ./ex5 -da_grid_x 10 -da_grid_y 10 \
	-snes_type sorqn -snes_sorqn_jacobian_start 0 -snes_sorqn_restart 10 -snes_sorqn_alpha 0.25 -snes_monitor -snes_max_it 10000 \
	-par 6.0 

runex5_5_ngmres_sorqn:
	-@${MPIEXEC} -n 2 ./ex5 -da_grid_x 20 -da_grid_y 20 \
	-snes_type ngmres -snes_ngmres_m 30 -snes_ngmres_restart 1000 -snes_monitor_short -snes_max_it 1000	 \
	-npc_snes_type sorqn -npc_snes_sorqn_jacobian_start 0 -npc_snes_max_it 3 -npc_snes_sorqn_alpha 0.25 -npc_snes_monitor_short \
	-par 6.0

runex5_6:
	-@${MPIEXEC} -n 4 ./ex5 -snes_monitor_short -ksp_monitor_short -da_grid_x 129 -da_grid_y 129  -pc_type mg -pc_mg_levels 8 -mg_levels_ksp_type chebychev -mg_levels_ksp_chebychev_estimate_eigenvalues 0,0.5,0,1.1 -mg_levels_ksp_max_it 2 > ex5_6.tmp 2>&1; \
	   ${DIFF} output/ex5_6.out ex5_6.tmp || echo "Possible problem with ex5_6, diffs above"

runex5f:
	-@${MPIEXEC} -n 4 ./ex5f -snes_mf -da_processors_x 4 -da_processors_y 1 -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f_1.tmp 2>&1; \
	   if (${DIFF} output/ex5f_1.out ex5f_1.tmp) then true; \
	   else echo "Possible problem with ex5f_1, diffs above"; fi
runex5f_2:
	-@${MPIEXEC} -n 4 ./ex5f  -da_processors_x 2 -da_processors_y 2 -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f_2.tmp 2>&1; \
	   if (${DIFF} output/ex5f_2.out ex5f_2.tmp) then true; \
	   else echo "Possible problem with ex5f_2, diffs above"; fi
runex5f_3:
	-@${MPIEXEC} -n 3 ./ex5f -snes_fd  -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f_3.tmp 2>&1;\
	   if (${DIFF} output/ex5f_3.out ex5f_3.tmp) then true; \
	   else echo "Possible problem with ex5f_3, diffs above"; fi
runex5f_4:
	-@${MPIEXEC} -n 2 ./ex5f -adifor_jacobian -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f_4.tmp 2>&1;\
	   if (${DIFF} output/ex5f_4.out ex5f_4.tmp) then true; \
	   else echo "Possible problem with ex5f_4, diffs above"; fi
runex5f_5:
	-@${MPIEXEC} -n 2 ./ex5f -adiformf_jacobian  -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f_5.tmp 2>&1;\
	   if (${DIFF} output/ex5f_5.out ex5f_5.tmp) then true; \
	   else echo "Possible problem with ex5f_5, diffs above"; fi
testex5f: ex5f.PETSc
	@if [ "${PETSC_WITH_BATCH}" != "" ]; then \
           echo "Running with batch filesystem; to test run src/snes/examples/tutorials/ex5f with" ; \
           echo "your systems batch system"; \
        elif [ "${MPIEXEC}" = "/bin/false" ]; then \
           echo "*mpiexec not found*. Please run src/snes/examples/tutorials/ex5f manually"; \
        elif [ -f ex5f ]; then \
	   ${MPIEXEC} -n 1 ./ex5f > ex5f_1.tmp 2>&1; \
	   if (${DIFF} output/ex5f_1.testout ex5f_1.tmp > /dev/null 2>&1) then \
           echo "Fortran example src/snes/examples/tutorials/ex5f run successfully with 1 MPI process"; \
	   else echo "Possible error running Fortran example src/snes/examples/tutorials/ex5f with 1 MPI process"; \
           echo "See http://www.mcs.anl.gov/petsc/petsc-as/documentation/faq.html";\
           cat ex5f_1.tmp; fi;  \
         ${MAKE} PETSC_ARCH=${PETSC_ARCH} PETSC_DIR=${PETSC_DIR} ; fi
runex5f90:
	-@${MPIEXEC} -n 4 ./ex5f90 -snes_mf -da_processors_x 4 -da_processors_y 1 -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f90_1.tmp 2>&1; \
	   if (${DIFF} output/ex5f90_1.out ex5f90_1.tmp) then true; \
	   else echo "Possible problem with ex5f90_1, diffs above"; fi
runex5f90_2:
	-@${MPIEXEC} -n 4 ./ex5f90 -da_processors_x 2 -da_processors_y 2 -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f90_2.tmp 2>&1; \
	   if (${DIFF} output/ex5f90_2.out ex5f90_2.tmp) then true; \
	   else echo "Possible problem with ex5f90_2, diffs above"; fi
runex5f90_3:
	-@${MPIEXEC} -n 3 ./ex5f90 -snes_fd  -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f90_3.tmp 2>&1;\
	   if (${DIFF} output/ex5f90_3.out ex5f90_3.tmp) then true; \
	   else echo "Possible problem with ex5f90_3, diffs above"; fi
runex5f90_4:
	-@${MPIEXEC} -n 3 ./ex5f90 -snes_mf_operator  -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f90_4.tmp 2>&1;\
	   if (${DIFF} output/ex5f90_4.out ex5f90_4.tmp) then true; \
	   else echo "Possible problem with ex5f90_4, diffs above"; fi
runex5f90_5:
	-@${MPIEXEC} -n 1 ./ex5f90 -test_appctx > ex5f90_5.tmp 2>&1;\
	   if (${DIFF} output/ex5f90_5.out ex5f90_5.tmp) then true; \
	   else echo "Possible problem with ex5f90_5, diffs above"; fi
runex5f90t:
	-@${MPIEXEC} -n 4 ./ex5f90t -snes_mf -da_processors_x 4 -da_processors_y 1 -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex5f90t_1.tmp 2>&1; \
	   if (${DIFF} output/ex5f90_1.out ex5f90t_1.tmp) then true; \
	   else echo "Possible problem with ex5f90t_1, diffs above"; fi
runex6:
	-@${MPIEXEC} -n 1 ./ex6 -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex6_1.tmp 2>&1;   \
	   if (${DIFF} output/ex6_1.out ex6_1.tmp) then true; \
	   else echo "Possible problem with ex6_1, diffs above"; fi
runex6_2:
	-@${MPIEXEC} -n 1 ./ex6 -snes_mf -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex6_2.tmp 2>&1;   \
	   if (${DIFF} output/ex6_2.out ex6_2.tmp) then true; \
	   else echo "Possible problem with ex6_2, diffs above"; fi
runex8:
	-@${MPIEXEC} -n 2 ./ex8  -mx 16 -my 16 -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always \
                    -lidvelocity 0. -grashof 1000. > ex8_1.tmp 2>&1; \
           if (${DIFF} output/ex8_1.out ex8_1.tmp) then true; \
           else echo "Possible problem with ex8_1, diffs above"; fi
runex8_2:
	-@${MPIEXEC} -n 2 ./ex8 -snes_monitor_solution -ksp_gmres_cgs_refinement_type refine_always > /dev/null 2>&1 
runex8_3:
	-@${MPIEXEC} -n 2 ./ex8 -is_coloring_view > ex8_3.tmp 2>&1;\
           if (${DIFF} output/ex8_3.out ex8_3.tmp) then true; \
           else echo "Possible problem with ex8_3, diffs above"; fi
runex14:
	-@${MPIEXEC} -n 4 ./ex14 -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always > ex14_1.tmp 2>&1; \
	   if (${DIFF} output/ex14_1.out ex14_1.tmp) then true; \
	   else echo "Possible problem with ex14_1, diffs above"; fi
runex14_2:
	-@${MPIEXEC} -n 4 ./ex14 -snes_monitor_short -ksp_gmres_cgs_refinement_type refine_always  > ex14_2.tmp 2>&1; \
	   if (${DIFF} output/ex14_2.out ex14_2.tmp) then true; \
	   else echo "Possible problem with ex14_2, diffs above"; fi
runex50:
	-@${MPIEXEC} -n 2 ./ex50 -da_refine 3 -snes_monitor_short -pc_type mg -ksp_type fgmres -pc_mg_type full > ex19_1.tmp 2>&1; \
	   if (${DIFF} output/ex19_1.out ex19_1.tmp) then true; \
	   else echo "Possible problem with ex50, diffs above"; fi
runex50_3: #test pc_redundant
	-@${MPIEXEC} -n 4 ./ex50 -da_refine 3 -snes_monitor_short -pc_type redundant -mat_type mpiaij -redundant_ksp_type preonly -redundant_pc_factor_mat_solver_package mumps -pc_redundant_number 2 > ex19_3.tmp 2>&1; \
	   if (${DIFF} output/ex19_3.out ex19_3.tmp) then true; \
	   else echo "Possible problem with ex50_3, diffs above"; fi
runex50_4: #test pc_redundant
	-@${MPIEXEC} -n 12 ./ex50 -da_refine 3 -snes_monitor_short -pc_type redundant -mat_type mpiaij -redundant_ksp_type preonly -redundant_pc_factor_mat_solver_package mumps -pc_redundant_number 5 > ex19_4.tmp 2>&1; \
	   if (${DIFF} output/ex19_3.out ex19_4.tmp) then true; \
	   else echo "Possible problem with ex50_4, diffs above"; fi
runex50_5: #test different scatters
	-@for A in " " -vecscatter_rsend -vecscatter_ssend -vecscatter_alltoall "-vecscatter_alltoall -vecscatter_nopack" -vecscatter_window; do \
           for B in " " -vecscatter_merge ; do \
             ${MPIEXEC} -n 4 ./ex50 -da_refine 3 -ksp_type fgmres -pc_type mg -pc_mg_type full -snes_monitor_short $$A $$B > ex19_5.tmp 2>&1; \
	     if (${DIFF} output/ex19_5.out ex19_5.tmp) then true; \
	     else echo "Possible problem with ex50_5 " $$A $$B " diffs above"; fi; \
           done;\
         done
runex19:
	-@${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 4 -snes_monitor_short  > ex19_1.tmp 2>&1; \
	   if (${DIFF} output/ex19_1.out ex19_1.tmp) then true; \
	   else echo "Possible problem with ex19, diffs above"; fi
runex19_2:
	-@${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -dmmg_jacobian_fd -dmmg_iscoloring_type ghosted > ex19_2.tmp 2>&1; \
	   if (${DIFF} output/ex19_1.out ex19_2.tmp) then true; \
	   else echo "Possible problem with ex19_2, diffs above"; fi
runex19_3: #test pc_redundant
	-@${MPIEXEC} -n 4 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -pc_type redundant -mat_type mpiaij -redundant_ksp_type preonly -redundant_pc_factor_mat_solver_package mumps -pc_redundant_number 2 > ex19_3.tmp 2>&1; \
	   if (${DIFF} output/ex19_3.out ex19_3.tmp) then true; \
	   else echo "Possible problem with ex19_3, diffs above"; fi
runex19_4: #test pc_redundant
	-@${MPIEXEC} -n 12 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -pc_type redundant -mat_type mpiaij -redundant_ksp_type preonly -redundant_pc_factor_mat_solver_package mumps -pc_redundant_number 5 > ex19_4.tmp 2>&1; \
	   if (${DIFF} output/ex19_3.out ex19_4.tmp) then true; \
	   else echo "Possible problem with ex19_4, diffs above"; fi
runex19_5: #test different scatters
	-@for A in " " -vecscatter_rsend -vecscatter_ssend -vecscatter_alltoall "-vecscatter_alltoall -vecscatter_nopack" -vecscatter_window; do \
           for B in " " -vecscatter_merge ; do \
             ${MPIEXEC} -n 4 ./ex19 -dmmg_nlevels 4 -snes_monitor_short $$A $$B > ex19_5.tmp 2>&1; \
	     if (${DIFF} output/ex19_5.out ex19_5.tmp) then true; \
	     else echo "Possible problem with ex19_5 " $$A $$B " diffs above"; fi \
           done;\
         done

# fieldsplit preconditioner tests
runex19_6: 
	-@${MPIEXEC} -n 1 ./ex19 -snes_monitor_short -ksp_monitor_short -pc_type fieldsplit -snes_view  -preload off > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_6.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_6, diffs above"; fi

runex19_fieldsplit_2:
	-@${MPIEXEC} -n 1 ./ex19 -dmmg_nlevels 1 -pc_type fieldsplit -pc_fieldsplit_block_size 4 -pc_fieldsplit_type additive -pc_fieldsplit_0_fields 0,1,2 -pc_fieldsplit_1_fields 3 -snes_monitor_short -ksp_monitor_short -preload off > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_fieldsplit_2.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_fieldsplit_2, diffs above"; fi

runex19_fieldsplit_3:
	-@${MPIEXEC} -n 1 ./ex19 -dmmg_nlevels 1 -pc_type fieldsplit -pc_fieldsplit_block_size 4 -pc_fieldsplit_type additive -pc_fieldsplit_0_fields 0,1,2 -pc_fieldsplit_1_fields 3 -fieldsplit_0_pc_type lu -fieldsplit_1_pc_type lu -snes_monitor_short -ksp_monitor_short -preload off > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_fieldsplit_3.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_fieldsplit_3, diffs above"; fi

runex19_fieldsplit_4:
	-@${MPIEXEC} -n 1 ./ex19 -dmmg_nlevels 1 -pc_type fieldsplit -pc_fieldsplit_block_size 4 -pc_fieldsplit_type SCHUR -pc_fieldsplit_0_fields 0,1,2 -pc_fieldsplit_1_fields 3 -fieldsplit_0_pc_type lu -fieldsplit_1_pc_type lu -snes_monitor_short -ksp_monitor_short -preload off > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_fieldsplit_4.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_fieldsplit_4, diffs above"; fi

runex19_fieldsplit_mumps:
	-@${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 1 -pc_type fieldsplit -pc_fieldsplit_block_size 4 -pc_fieldsplit_type SCHUR -pc_fieldsplit_0_fields 0,1,2 -pc_fieldsplit_1_fields 3 -fieldsplit_0_pc_type lu -fieldsplit_1_pc_type lu -snes_monitor_short -ksp_monitor_short -preload off -fieldsplit_0_pc_factor_mat_solver_package mumps -fieldsplit_1_pc_factor_mat_solver_package mumps > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_fieldsplit_5.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_fieldsplit_5, diffs above"; fi

runex19_fieldsplit_hypre:
	-@${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 1 -pc_type fieldsplit -pc_fieldsplit_block_size 4 -pc_fieldsplit_type SCHUR -pc_fieldsplit_0_fields 0,1,2 -pc_fieldsplit_1_fields 3 -fieldsplit_0_pc_type lu -fieldsplit_0_pc_factor_mat_solver_package mumps -fieldsplit_1_pc_type hypre -fieldsplit_1_pc_hypre_type boomeramg -snes_monitor_short -ksp_monitor_short -preload off > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_fieldsplit_hypre.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_fieldsplit_hypre, diffs above"; fi

runex19_fieldsplit_redundant:
	-@${MPIEXEC} -n 4 ./ex19 -dmmg_nlevels 1 -pc_type fieldsplit -pc_fieldsplit_block_size 4 -pc_fieldsplit_type SCHUR -pc_fieldsplit_0_fields 0,1,2 -pc_fieldsplit_1_fields 3 -fieldsplit_0_pc_type lu -fieldsplit_0_pc_factor_mat_solver_package mumps -fieldsplit_1_pc_type redundant -fieldsplit_1_pc_redundant_number 2 -fieldsplit_1_redundant_ksp_type preonly -fieldsplit_1_redundant_pc_factor_mat_solver_package mumps -snes_monitor_short -ksp_monitor_short -preload off > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_fieldsplit_redundant.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_fieldsplit_redundant, diffs above"; fi

runex19_composite_fieldsplit: #similar to runex19_fieldsplit_2
	-@${MPIEXEC} -n 1 ./ex19 -dmmg_nlevels 1 -pc_type composite -pc_composite_type MULTIPLICATIVE -pc_composite_pcs fieldsplit,none -sub_0_pc_fieldsplit_block_size 4 -sub_0_pc_fieldsplit_type additive -sub_0_pc_fieldsplit_0_fields 0,1,2 -sub_0_pc_fieldsplit_1_fields 3 -snes_monitor_short -ksp_monitor_short -preload off > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_composite_fieldsplit.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_composite_fieldsplit, diffs above"; fi

runex19_composite_fieldsplit_bjacobi:
	-@${MPIEXEC} -n 1 ./ex19 -dmmg_nlevels 1 -pc_type composite -pc_composite_type MULTIPLICATIVE -pc_composite_pcs fieldsplit,bjacobi -sub_0_pc_fieldsplit_block_size 4 -sub_0_pc_fieldsplit_type additive -sub_0_pc_fieldsplit_0_fields 0,1,2 -sub_0_pc_fieldsplit_1_fields 3 -sub_1_pc_bjacobi_blocks 16 -sub_1_sub_pc_type lu -snes_monitor_short -ksp_monitor_short -preload off > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_composite_fieldsplit_bjacobi.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_composite_fieldsplit_bjacobi, diffs above"; fi

runex19_composite_fieldsplit_bjacobi_2:
	-@${MPIEXEC} -n 4 ./ex19 -dmmg_nlevels 1 -pc_type composite -pc_composite_type MULTIPLICATIVE -pc_composite_pcs fieldsplit,bjacobi -sub_0_pc_fieldsplit_block_size 4 -sub_0_pc_fieldsplit_type additive -sub_0_pc_fieldsplit_0_fields 0,1,2 -sub_0_pc_fieldsplit_1_fields 3 -sub_1_pc_bjacobi_blocks 16 -sub_1_sub_pc_type lu -snes_monitor_short -ksp_monitor_short -preload off > ex19_6.tmp 2>&1; \
	   if (${DIFF} output/ex19_composite_fieldsplit_bjacobi_2.out ex19_6.tmp) then true; \
	   else echo "Possible problem with ex19_composite_fieldsplit_bjacobi_2, diffs above"; fi

runex19_7: 
	-@${MPIEXEC} -n 3 ./ex19 -snes_monitor_short -ksp_monitor_short -pc_type fieldsplit -snes_view  -preload off > ex19_7.tmp 2>&1; \
	   if (${DIFF} output/ex19_7.out ex19_7.tmp) then true; \
	   else echo "Possible problem with ex19_7, diffs above"; fi
runex19_8: 
	-@${MPIEXEC} -n 1 ./ex19 -snes_monitor_short -ksp_monitor_short -pc_type fieldsplit -pc_fieldsplit_block_size 2 -pc_fieldsplit_0_fields 0,1 -pc_fieldsplit_1_fields 0,1 -pc_fieldsplit_type multiplicative -snes_view  -preload off -fieldsplit_pc_type lu > ex19_8.tmp 2>&1; \
	   if (${DIFF} output/ex19_8.out ex19_8.tmp) then true; \
	   else echo "Possible problem with ex19_8, diffs above"; fi
runex19_9: 
	-@${MPIEXEC} -n 3 ./ex19 -snes_monitor_short -ksp_monitor_short -pc_type fieldsplit -pc_fieldsplit_type multiplicative -snes_view  -preload off > ex19_9.tmp 2>&1; \
	   if (${DIFF} output/ex19_9.out ex19_9.tmp) then true; \
	   else echo "Possible problem with ex19_9, diffs above"; fi
runex19_10: 
	-@${MPIEXEC} -n 3 ./ex19 -snes_monitor_short -ksp_monitor_short -pc_type fieldsplit -pc_fieldsplit_type symmetric_multiplicative -snes_view  -preload off > ex19_10.tmp 2>&1; \
	   if (${DIFF} output/ex19_10.out ex19_10.tmp) then true; \
	   else echo "Possible problem with ex19_10, diffs above"; fi
runex19_11: #test pc_redundant
	-@${MPIEXEC} -n 4 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -pc_type redundant -mat_type mpiaij -redundant_pc_factor_mat_solver_package pastix -pc_redundant_number 2 -preload off > ex19_11.tmp 2>&1
	   if (${DIFF} output/ex19_11.out ex19_11.tmp) then true; \
	   else echo "Possible problem with ex19_11, diffs above"; fi
runex19_12: #test pc_redundant
	-@${MPIEXEC} -n 12 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -pc_type redundant -mat_type mpiaij -redundant_pc_factor_mat_solver_package pastix -pc_redundant_number 5 -preload off > ex19_12.tmp 2>&1; \
	   if (${DIFF} output/ex19_12.out ex19_12.tmp) then true; \
	   else echo "Possible problem with ex19_12, diffs above"; fi
runex19_13: #test pc_fieldsplit with -snes_mf_operator
	-@${MPIEXEC} -n 3 ./ex19 -snes_monitor_short -ksp_monitor_short -pc_type fieldsplit -pc_fieldsplit_type multiplicative -snes_view  -preload off -snes_mf_operator > ex19_13.tmp 2>&1
	   if (${DIFF} output/ex19_13.out ex19_13.tmp) then true; \
	   else echo "Possible problem with ex19_13, diffs above"; fi


testex19: ex19.PETSc
	-@if [ "${PETSC_WITH_BATCH}" != "" ]; then \
           echo "Running with batch filesystem; to test run src/snes/examples/tutorials/ex19 with" ; \
           echo "your systems batch system"; \
        elif [ "${MPIEXEC}" = "/bin/false" ]; then \
           echo "*mpiexec not found*. Please run src/snes/examples/tutorials/ex19 manually"; \
	elif [ -f ex19 ]; then \
           ${MPIEXEC} -n 1 ./ex19 -dmmg_nlevels 4  > ex19_1.tmp 2>&1; \
	   if (${DIFF} output/ex19_1.testout ex19_1.tmp > /dev/null 2>&1) then \
           echo "C/C++ example src/snes/examples/tutorials/ex19 run successfully with 1 MPI process"; \
	   else echo "Possible error running C/C++ src/snes/examples/tutorials/ex19 with 1 MPI process"; \
           echo "See http://www.mcs.anl.gov/petsc/petsc-as/documentation/faq.html";\
           cat ex19_1.tmp; fi; \
	if [ "${MPIEXEC}" != "${PETSC_DIR}/bin/mpiexec.uni" ]; then \
           ${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 4   > ex19_1.tmp 2>&1; \
	   if (${DIFF} output/ex19_1.testout ex19_1.tmp > /dev/null 2>&1) then \
           echo "C/C++ example src/snes/examples/tutorials/ex19 run successfully with 2 MPI processes"; \
	   else echo "Possible error running C/C++ src/snes/examples/tutorials/ex19 with 2 MPI processes"; \
           echo "See http://www.mcs.anl.gov/petsc/petsc-as/documentation/faq.html";\
           cat ex19_1.tmp; fi; fi; \
        ${MAKE} PETSC_ARCH=${PETSC_ARCH} PETSC_DIR=${PETSC_DIR}  ; fi

testx11ex19: ex19.PETSc
	-@if [ "${PETSC_WITH_BATCH}" != "" ]; then \
           echo "Running with batch filesystem; to test run src/snes/examples/tutorials/ex19 with" ; \
           echo "your systems batch system"; \
        elif [ "${MPIEXEC}" = "/bin/false" ]; then \
           echo "*mpiexec not found*. Please run src/snes/examples/tutorials/ex19 manually"; \
	elif [ -f ex19 ]; then \
          D2=`grep "#define PETSC_HAVE_X11 1" ${PETSC_DIR}/${PETSC_ARCH}/include/petscconf.h`; \
          if [ "$$?" = 0 ]; then \
             ${MPIEXEC} -n 1 ./ex19 -dmmg_nlevels 4 -snes_monitor_draw  > ex19_1.tmp 2>&1; \
	     if (${DIFF} output/ex19_1.testout ex19_1.tmp > /dev/null 2>&1) then \
             echo "Graphics example src/snes/examples/tutorials/ex19 run successfully with 1 MPI process"; \
	     else echo "Possible error running Graphics examples src/snes/examples/tutorials/ex19 1 MPI process"; \
             echo "See http://www.mcs.anl.gov/petsc/petsc-as/documentation/faq.html";\
             cat ex19_1.tmp; fi; \
	  else echo "PETSc installed without X11. Not running src/snes/examples/tutorials/ex19"; fi; \
        ${MAKE} PETSC_ARCH=${PETSC_ARCH} PETSC_DIR=${PETSC_DIR}  ; fi
runex19_14:
	-@${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -dmmg_mat_type baij -mg_coarse_pc_type bjacobi > ex19_14.tmp 2>&1; \
	   if (${DIFF} output/ex19_14.out ex19_14.tmp) then true; \
	   else echo "Possible problem with ex19_14, diffs above"; fi
runex19_15:
	-@${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -dmmg_mat_type baij -mg_coarse_pc_type bjacobi -dmmg_iscoloring_type global > ex19_15.tmp 2>&1; \
	   if (${DIFF} output/ex19_15.out ex19_15.tmp) then true; \
	   else echo "Possible problem with ex19_15, diffs above"; fi
runex19_15a:
	-@${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -dmmg_mat_type baij -mg_coarse_pc_type bjacobi -dmmg_iscoloring_type global -dmmg_coloring_from_mat > ex19_15a.tmp 2>&1; \
	   if (${DIFF} output/ex19_15a.out ex19_15a.tmp) then true; \
	   else echo "Possible problem with ex19_15a, diffs above"; fi
runex19_16:
	-@${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -dmmg_mat_type aij -mg_coarse_pc_type bjacobi -dmmg_iscoloring_type global > ex19_16.tmp 2>&1; \
	   if (${DIFF} output/ex19_16.out ex19_16.tmp) then true; \
	   else echo "Possible problem with ex19_16, diffs above"; fi
runex19_16a:
	-@${MPIEXEC} -n 2 ./ex19 -dmmg_nlevels 4 -snes_monitor_short -dmmg_mat_type aij -mg_coarse_pc_type bjacobi -dmmg_iscoloring_type global -dmmg_coloring_from_mat > ex19_16a.tmp 2>&1; \
	   if (${DIFF} output/ex19_16a.out ex19_16a.tmp) then true; \
	   else echo "Possible problem with ex19_16a, diffs above"; fi
runex19_superlu:
	-@${MPIEXEC} -n 1 ./ex19 -nlevels 1 -da_grid_x 20 -da_grid_y 20 -pc_type lu -pc_factor_mat_solver_package superlu > ex19.tmp 2>&1; \
	   if (${DIFF} output/ex19_superlu.out ex19.tmp) then true; \
	   else echo "Possible problem with ex19_superlu, diffs above"; fi
runex19_superlu_equil: #This test fails - I'll check it. Hong
	-@${MPIEXEC} -n 1 ./ex19 -nlevels 1 -da_grid_x 20 -da_grid_y 20 -{snes,ksp}_monitor_short -pc_type lu -pc_factor_mat_solver_package superlu -mat_superlu_equil > ex19.tmp 2>&1; \
	   if (${DIFF} output/ex19_superlu_equil.out ex19.tmp) then true; \
	   else echo "Possible problem with ex19_superlu_equil, diffs above"; fi
runex19_superlu_dist:
	-@${MPIEXEC} -n 1 ./ex19 -nlevels 1 -da_grid_x 20 -da_grid_y 20 -pc_type lu -pc_factor_mat_solver_package superlu_dist > ex19.tmp 2>&1; \
	   if (${DIFF} output/ex19_superlu.out ex19.tmp) then true; \
	   else echo "Possible problem with ex19_superlu_dist, diffs above"; fi
runex19_superlu_dist_2:
	-@${MPIEXEC} -n 2 ./ex19 -nlevels 1 -da_grid_x 20 -da_grid_y 20 -pc_type lu -pc_factor_mat_solver_package superlu_dist > ex19.tmp 2>&1; \
	   if (${DIFF} output/ex19_superlu.out ex19.tmp) then true; \
	   else echo "Possible problem with ex19_superlu_dist, diffs above"; fi
runex19_cusp:
	-@${MPIEXEC} -n 1 ./ex19 -da_vec_type cusp -da_mat_type aijcusp -pc_type none -dmmg_nlevels 1 -snes_monitor_short -snes_rtol 1.e-5 > ex19.tmp 2>&1; \
	   if (${DIFF} output/ex19_cusp.out ex19.tmp) then true; \
	   else echo "Possible problem with ex19_cusp, diffs above"; fi
runex21:
	-@${MPIEXEC} -n 4 ./ex21  -snes_mf -snes_monitor_short -nox > ex21_1.tmp 2>&1; \
	   if (${DIFF} output/ex21_1.out ex21_1.tmp) then true; \
	   else echo "Possible problem with ex21_1, diffs above"; fi
runex22:
	-@${MPIEXEC} -n 1 ./ex22 -da_grid_x 10 > ex22_1.tmp 2>&1; \
	   if (${DIFF} output/ex22_1.out ex22_1.tmp) then true; \
	   else echo "Possible problem with ex22_1, diffs above"; fi
runex23:
	-@${MPIEXEC} -n 2 ./ex23 -snes_monitor_short -dmmg_jacobian_mf_fd -mat_mffd_type wp -mat_mffd_compute_normu no > ex23_1.tmp 2>&1; \
	   if (${DIFF} output/ex23_1.out ex23_1.tmp) then true; \
	   else echo "Possible problem with ex23_1, diffs above"; fi

runex25:
	-@${MPIEXEC} -n 1 ./ex25 -preload off > ex25_1.tmp 2>&1;	  \
	   if (${DIFF} output/ex25_1.out ex25_1.tmp) then true; \
	   else echo "Possible problem with ex25_1, diffs above"; fi

runex25_2:
	-@${MPIEXEC} -n 2 ./ex25 -preload off > ex25_2.tmp 2>&1;	  \
	   if (${DIFF} output/ex25_2.out ex25_2.tmp) then true; \
	   else echo "Possible problem with ex25_2, diffs above"; fi
runex27:
	-@${MPIEXEC} -n 1 ./ex27 -lidvelocity 100 -da_grid_x 16 -da_grid_y 16 -print -snes_monitor -grashof 1.e5 -cfl_ini 1.0e-1 -snes_rtol 1.0e-3
runex27_p:
	-@${MPIEXEC} -n 1 ./ex27 -lidvelocity 100 -da_grid_x 16 -da_grid_y 16 -print -snes_monitor -grashof 1.e5 -cfl_ini 1.0e-1 -snes_rtol 1.0e-3 -use_parabolic
runex27_li:              # This algorithm, using a linearly implicit step, is the one described in the paper
	-@${MPIEXEC} -n 1 ./ex27 -lidvelocity 100 -da_grid_x 16 -da_grid_y 16 -print -snes_type ksponly -grashof 1.e5 -cfl_ini 1.0e-1 -snes_rtol 1.0e-3

runex28_0:
	-@${MPIEXEC} -n 3 ./ex28 -da_grid_x 20 -snes_converged_reason -snes_monitor_short -problem_type 0 > ex28_0.tmp 2>&1
runex28_1:
	-@${MPIEXEC} -n 3 ./ex28 -da_grid_x 20 -snes_converged_reason -snes_monitor_short -problem_type 1 > ex28_1.tmp 2>&1
runex28_2:
	-@${MPIEXEC} -n 3 ./ex28 -da_grid_x 20 -snes_converged_reason -snes_monitor_short -problem_type 2 > ex28_2.tmp 2>&1
runex28_3:
	-@for mtype in aij nest; do \
	    ${MPIEXEC} -n 3 ./ex28 -da_grid_x 20 -snes_converged_reason -snes_monitor_short -ksp_monitor_short -problem_type 2 -snes_mf_operator \
	    -pack_dm_mat_type $$mtype -pc_type fieldsplit -pc_fieldsplit_type additive -fieldsplit_u_ksp_type gmres -fieldsplit_k_pc_type jacobi > ex28_3.tmp 2>&1; \
	  done

runex32:
	-@${MPIEXEC} -n 1 ./ex32 -snes_monitor -dmmg_jacobian_mf_fd_operator -da_grid_x 10 -da_grid_y 10
runex32_2:
	-@${MPIEXEC} -n 1 ./ex32 -snes_monitor -dmmg_jacobian_mf_fd -da_grid_x 10 -da_grid_y 10
runex32_3:
	-@${MPIEXEC} -n 3 ./ex32 -snes_monitor -dmmg_jacobian_mf_fd_operator -da_grid_x 10 -da_grid_y 10
runex32_4:
	-@${MPIEXEC} -n 3 ./ex32 -snes_monitor -dmmg_jacobian_mf_fd -da_grid_x 10 -da_grid_y 10

runex42:
	-@${MPIEXEC} -n 1 ./ex42 -snes_monitor_short -snes_max_it 1000 -snes_rtol 1.e-14  > ex42_1.tmp 2>&1;	  \
	   if (${DIFF} output/ex42_1.out ex42_1.tmp) then true; \
	   else echo "Possible problem with ex42_1, diffs above"; fi

runex44:
	-@${MPIEXEC} -n 1 ./ex44 -n 10 -snes_mf -user_precond > ex44.tmp 2>&1; \
	   if (${DIFF} output/ex44.out ex44.tmp) then true; \
	   else echo "Possible problem with ex44, diffs above"; fi
runex44_2:
	-@${MPIEXEC} -n 1 ./ex44 -n 10 -snes_mf > ex44.tmp 2>&1; \
	   if (${DIFF} output/ex44.out ex44.tmp) then true; \
	   else echo "Possible problem with ex44_2, diffs above"; fi

runex45:
	-@${MPIEXEC} -n 1 ./ex45 -n 10 > ex45.tmp 2>&1; \
	   if (${DIFF} output/ex44.out ex45.tmp) then true; \
	   else echo "Possible problem with ex45, diffs above"; fi
runex45_2:
	-@${MPIEXEC} -n 1 ./ex45 -n 10 -snes_jacobian_default -pc_type jacobi > ex45.tmp 2>&1; \
	   if (${DIFF} output/ex44.out ex45.tmp) then true; \
	   else echo "Possible problem with ex45_2, diffs above"; fi
runex45_3:
	-@${MPIEXEC} -n 1 ./ex45 -n 10 -snes_jacobian_default -fd_jacobian_coloring -my_jacobian_struct > ex45.tmp 2>&1; \
	   if (${DIFF} output/ex44.out ex45.tmp) then true; \
	   else echo "Possible problem with ex45_3, diffs above"; fi

runex47cu:
	-@${MPIEXEC} -n 1 ./ex47cu -snes_monitor_short -da_vec_type cusp  > ex47cu_1.tmp 2>&1;	  \
	   if (${DIFF} output/ex47cu_1.out ex47cu_1.tmp) then true; \
	   else echo "Possible problem with ex47cu_1, diffs above"; fi

runex48:
	-@${MPIEXEC} -n 1 ./ex48 -M 6 -P 4 -thi_nlevels 2 -snes_monitor_short -snes_converged_reason -ksp_monitor_short -ksp_converged_reason -thi_mat_type sbaij > ex48.tmp 2>&1; \
	   ${DIFF} output/ex48_1.out ex48.tmp || echo "Possible problem with ex48_1, diffs above"
runex48_2:
	-@${MPIEXEC} -n 2 ./ex48 -M 6 -P 4 -thi_hom z -thi_nlevels 2 -snes_monitor_short -snes_converged_reason -ksp_monitor_short -ksp_converged_reason -thi_mat_type sbaij -mg_levels_pc_type asm -mg_levels_pc_asm_blocks 6 -mg_levels_0_pc_type redundant -dmmg_grid_sequence -thi_mat_partitioning_type current > ex48.tmp 2>&1; \
	   ${DIFF} output/ex48_2.out ex48.tmp || echo "Possible problem with ex48_2, diffs above"
runex48_3:
	-@${MPIEXEC} -n 3 ./ex48 -M 7 -P 4 -thi_hom z -thi_nlevels 2 -snes_monitor_short -snes_converged_reason -ksp_monitor_short -ksp_converged_reason -thi_mat_type baij -mg_levels_pc_type asm -mg_levels_pc_asm_blocks 9 -thi_mat_partitioning_type current > ex48.tmp 2>&1; \
	   ${DIFF} output/ex48_3.out ex48.tmp || echo "Possible problem with ex48_3, diffs above"
runex48_4:
	-@${MPIEXEC} -n 6 ./ex48 -M 4 -P 2 -da_refine_hierarchy_x 1,1,3 -da_refine_hierarchy_y 2,2,1 -da_refine_hierarchy_z 2,2,1 -dmmg_grid_sequence 1 -dmmg_view -ksp_converged_reason -ksp_monitor_short -ksp_rtol 1e-2 -mg_levels_1_sub_pc_type cholesky -pc_mg_type multiplicative -snes_converged_reason -snes_monitor_short -snes_stol 1e-12 -thi_L 80e3 -thi_alpha 0.05 -thi_friction_m 1 -thi_hom x -thi_nlevels 4 > ex48.tmp 2>&1; \
	   ${DIFF} output/ex48_4.out ex48.tmp || echo "Possible problem with ex48_4, diffs above"

testex50: ex50.PETSc
	-@if [ "${PETSC_WITH_BATCH}" != "" ]; then \
           echo "Running with batch filesystem; to test run src/snes/examples/tutorials/ex50 with" ; \
           echo "your systems batch system"; \
        elif [ "${MPIEXEC}" = "/bin/false" ]; then \
           echo "*mpiexec not found*. Please run src/snes/examples/tutorials/ex50 manually"; \
	elif [ -f ex50 ]; then \
           ${MPIEXEC} -n 1 ./ex50 -da_refine 3  > ex50_1.tmp 2>&1; \
	   if (${DIFF} output/ex19_1.testout ex50_1.tmp > /dev/null 2>&1) then \
           echo "C/C++ example src/snes/examples/tutorials/ex50 run successfully with 1 MPI process"; \
	   else echo "Possible error running C/C++ src/snes/examples/tutorials/ex50 with 1 MPI process"; \
           echo "See http://www.mcs.anl.gov/petsc/petsc-as/documentation/faq.html";\
           cat ex50_1.tmp; fi; \
	if [ "${MPIEXEC}" != "${PETSC_DIR}/bin/mpiexec.uni" ]; then \
           ${MPIEXEC} -n 2 ./ex50 -da_refine 3   > ex50_1.tmp 2>&1; \
	   if (${DIFF} output/ex19_1.testout ex50_1.tmp > /dev/null 2>&1) then \
           echo "C/C++ example src/snes/examples/tutorials/ex50 run successfully with 2 MPI processes"; \
	   else echo "Possible error running C/C++ src/snes/examples/tutorials/ex50 with 2 MPI processes"; \
           echo "See http://www.mcs.anl.gov/petsc/petsc-as/documentation/faq.html";\
           cat ex50_1.tmp; fi; fi; \
        ${MAKE} PETSC_ARCH=${PETSC_ARCH} PETSC_DIR=${PETSC_DIR}  ; fi

testx11ex50: ex50.PETSc
	-@if [ "${PETSC_WITH_BATCH}" != "" ]; then \
           echo "Running with batch filesystem; to test run src/snes/examples/tutorials/ex50 with" ; \
           echo "your systems batch system"; \
        elif [ "${MPIEXEC}" = "/bin/false" ]; then \
           echo "*mpiexec not found*. Please run src/snes/examples/tutorials/ex50 manually"; \
	elif [ -f ex50 ]; then \
          D2=`grep "#define PETSC_HAVE_X11 1" ${PETSC_DIR}/${PETSC_ARCH}/include/petscconf.h`; \
          if [ "$$?" = 0 ]; then \
             ${MPIEXEC} -n 1 ./ex50 -da_refine 3 -snes_monitor_draw  > ex50_1.tmp 2>&1; \
	     if (${DIFF} output/ex19_1.testout ex50_1.tmp > /dev/null 2>&1) then \
             echo "Graphics example src/snes/examples/tutorials/ex50 run successfully with 1 MPI process"; \
	     else echo "Possible error running Graphics examples src/snes/examples/tutorials/ex50 1 MPI process"; \
             echo "See http://www.mcs.anl.gov/petsc/petsc-as/documentation/faq.html";\
             cat ex50_1.tmp; fi; \
	  else echo "PETSc installed without X11. Not running src/snes/examples/tutorials/ex50"; fi; \
        ${MAKE} PETSC_ARCH=${PETSC_ARCH} PETSC_DIR=${PETSC_DIR}  ; fi

TESTEXAMPLES_C		       = ex1.PETSc runex1  ex2.PETSc runex2  runex2_3  ex3.PETSc runex3 \
                                 runex3_2 runex3_3 runex3_4  ex5.PETSc runex5 runex5_2 runex5_3 runex5_4 runex5_6 \
                                 ex6.PETSc runex6 runex6_2 \
                                 ex14.PETSc runex14 runex14_2  ex19.PETSc runex19 runex19_2 runex19_5 \
                                 runex19_6 runex19_fieldsplit_2 runex19_fieldsplit_3 runex19_fieldsplit_4 \
                                 runex19_composite_fieldsplit runex19_composite_fieldsplit_bjacobi runex19_composite_fieldsplit_bjacobi_2\
                                 runex19_7 runex19_8 runex19_9 \
                                 runex19_10 runex19_14 runex19_15 runex19_15a runex19_16 runex19_16a  \
                                 ex22.PETSc runex22  ex18.PETSc  ex19.PETSc  ex21.PETSc runex21  \
                                 ex23.PETSc runex23  ex24.PETSc    ex25.PETSc runex25 runex25_2 \
                                  ex28.PETSc runex28_0 runex28_1 runex28_2 runex28_3  ex29.PETSc  \
                                 ex31.PETSc  ex32.PETSc  ex42.PETSc runex42  ex43.PETSc  \
                                 ex44.PETSc runex44 runex44_2  ex45.PETSc runex45 runex45_2 runex45_3  \
                                 ex48.PETSc runex48 runex48_2 runex48_3 runex48_4  \
                                 ex54.PETSc  ex59.PETSc 
TESTEXAMPLES_C_X11	       = 
TESTEXAMPLES_FORTRAN	       = ex1f.PETSc runex1f 
TESTEXAMPLES_C_NOCOMPLEX       = ex26.PETSc  ex30.PETSc 
TESTEXAMPLES_FORTRAN_NOCOMPLEX = ex5f.PETSc runex5f runex5f_3 
TESTEXAMPLES_FORTRAN_MPIUNI    = ex1f.PETSc runex1f 
TESTEXAMPLES_C_X11_MPIUNI      = ex1.PETSc runex1  ex2.PETSc runex2  ex3.PETSc runex3  ex6.PETSc \
                                 runex6 runex6_2   ex14.PETSc  
TESTEXAMPLES_F90	       = ex5f90.PETSc runex5f90 runex5f90_2 runex5f90_3 runex5f90_4 runex5f90_5 
TESTEXAMPLES_13		       = 
TESTEXAMPLES_MATLAB_ENGINE     = 
TESTEXAMPLES_AMS	       = 
TESTEXAMPLES_ADIFOR	       = ex5f.PETSc runex5f_2 
TESTEXAMPLES_MUMPS             = ex19.PETSc runex19_3 runex19_4 runex19_fieldsplit_mumps runex19_fieldsplit_redundant   \
                                 ex50.PETSc runex50_3 runex50_4 runex50_fieldsplit_mumps runex50_fieldsplit_redundant  
TESTEXAMPLES_SUPERLU           = ex19.PETSc runex19_superlu 
TESTEXAMPLES_SUPERLU_DIST      = ex19.PETSc runex19_superlu_dist runex19_superlu_dist_2   ex50.PETSc  
TESTEXAMPLES_PASTIX            = ex19.PETSc runex19_11 runex19_12   ex50.PETSc runex50_11 runex50_12 
TESTEXAMPLES_CUSP              = ex19.PETSc runex19_cusp  ex47cu.PETSc runex47cu 

include test
