#include <unistd.h>

int main() {
    setuid( 0 );
    system( "systemctl stop g-code-interpreter cnc-driver" );
    system( "echo '8' > /sys/class/gpio/export" );
    system( "echo 'out' > /sys/class/gpio/gpio8/direction" );
    system( "echo '1' > /sys/class/gpio/gpio8/value" );
    system( "sleep 1" );
    system( "systemctl start g-code-interpreter cnc-driver" );

    return 0;
}

