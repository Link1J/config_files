term_size() {
    printf "Columns: %d\n" $(tput cols )
    printf "Rows   : %d\n" $(tput lines)
}
