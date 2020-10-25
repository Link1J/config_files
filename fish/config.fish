set -g fish_prompt_pwd_dir_length 1

set -gx PATH "/home/link1j/.gem/ruby/2.6.0/bin" $PATH
set -gx PATH "/usr/lib/emscripten" $PATH
set -gx PATH "/home/link1j/.local/bin" $PATH

set -gx EDITOR /usr/bin/vim

# Currently required because of https://github.com/emscripten-core/emscripten/issues/11415
set -g EM_IGNORE_SANITY true

abbr -a ll 'ls -l'
abbr -a la 'ls -a'
abbr -a lla 'ls -la'

abbr -a suedit 'sudo -e'
