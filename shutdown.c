#include <unistd.h>

int main() {
    setuid( 0 );
    system( "systemctl poweroff" );

    return 0;
}

