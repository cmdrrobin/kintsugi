if [[ ! -z $OMARCHY_PATH ]]; then
    for f in aliases envs functions; do
        source $OMARCHY_PATH/default/bash/$f
    done
fi

source $ZSH/omarchy/init
