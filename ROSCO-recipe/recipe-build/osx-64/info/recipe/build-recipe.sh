# This script builds the conda package and uploads the new versions to conda-forge
# 
# Notes: 
#  - This must be run from the rosco-conda environment (or change CONDA_BUILDDIR accordingly)
#  - This must be run from the same folder that the meta.yaml lives
#  - You should run this from the rosco-conda environment, making sure the following packages are 
#    installed in the active environment:
#       - conda-build
#       - twine (pip install twine)

export BUILDDIR="${HOME}/Documents/WindEnergyToolbox/conda-recipes/ROSCO-recipe/recipe-build"
export CONDA_BUILDDIR="${HOME}/opt/anaconda3/envs/rosco-conda/conda-bld/osx-64"

# Remove old conda packages
echo "Removing old conda packages ..."
rm -rf ${CONDA_BUILDDIR}*
rm -rf ${CONDA_BUILDDIR}.cache

# Build conda package 
echo "Building conda package ..."
conda build .

# Cleanup old buidls
platforms=( osx-64 linux-32 linux-64 win-32 win-64 )
for platform in "${platforms[@]}"
do
    if [ ! -d ${BUILDDIR}/${platform} ]; then # Make directory if does not exist
        mkdir -p ${BUILDDIR}/${platform}
    else
        rm ${BUILDDIR}/${platform}/* # remove old builds
    fi
done

# Convert package to other common platforms
echo "Converting conda package ..."
find $CONDA_BUILDDIR -name *.tar.bz2 | while read file
do
    echo $file
    for platform in "${platforms[@]}"
    do
        conda-convert $file -p $platform -o $BUILDDIR
        echo "Package converted to $platform"
    done    
    cp $file ${BUILDDIR}/osx-64
done

# # upload packages to conda
# find $BUILDDIR -name *.tar.bz2 | while read file
# do
#     echo "Uploading $file to conda"
#     anaconda upload --force $file
# done
