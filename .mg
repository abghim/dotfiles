set-tab-width 4
auto-execute "*.c" c-mode
auto-execute "*.java" c-mode
auto-execute "*.rs" c-mode
auto-execute "*.json" c-mode
auto-execute "*.cpp" c-mode
auto-execute "*.py" auto-indent-mode

define-key c ")" self-insert-command
define-key c "]" self-insert-command
define-key c "}" self-insert-command

define-key indent ")" self-insert-command
define-key indent "]" self-insert-command
define-key indent "}" self-insert-command


