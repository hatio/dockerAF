
# This script assumes that you have navigated to the project directory.
# Type the following to double check.
echo $PWD


# In the code below, note the flag `--cpuset-cpus 0-1`, this tells the container to use between zero to one cores on your computer to avoid over utilization of resources. Please the maximum according to the resources available on your computer.



# Reference mapping
docker run \
    -v ${PWD}:/project \
    -w /project \
    --cpuset-cpus 0-1 \
    -ti afviro/afscov2-css
# You will be prompted for an output name.
# Name it whatever you like to reflect the project you are working on.





# Check consensus sequences to identify ones that have ambiguous bases.







# Genome-guided assembly
docker run \
    -v ${PWD}:/project \
    -w /project \
    --cpuset-cpus 0-1 \
    -ti afviro/assembly \
    Genome_guiding.sh


# Update the consensus sequences to replace those ambiguous bases with
# results from genome-guided assembly (if possible).


