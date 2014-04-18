#include <unistd.h>

int main() {
    setuid( 0 );
    system( "systemctl restart g-code-interpreter" );

    return 0;
}

