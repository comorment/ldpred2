all: ldpred2.sif  # additional .sif files may be listed here for corresponding dockerfiles

%.sif: dockerfiles/%/Dockerfile
	docker build -t $* -f dockerfiles/$*/Dockerfile . && \
	scripts/convert_docker_image_to_singularity.sh $* && \
	scripts/move_singularity_file.sh $*

# Example commands executed by this make file
# 
# Run "make ldpred2.sif" will trigger this:
# docker build -t ldpred2 -f dockerfiles/ldpred2/Dockerfile . && \  # build docker container
#     scripts/convert_docker_image_to_singularity.sh ldpred2 && \         # produces ldpred2.sif
#     scripts/scripts/move_singularity_file.sh.sh ldpred2        # moves ldpred2.sif to ../singularity/.
#  
# Run "make all" will build all singularity containers in this project
