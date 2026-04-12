tmux send-keys "nvim" Enter
tmux split-window -v -p 15
tmux select-pane -t 1
tmux rename-window "editor"
