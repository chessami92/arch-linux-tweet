#include <unistd.h>

int main() {
    setuid( 0 );
    system( "echo '14' > /sys/class/gpio/export" );
    system( "echo 'out' > /sys/class/gpio/gpio14/direction" );
    system( "echo '0' > /sys/class/gpio/gpio14/value" );
    system( "sleep 1" );
    system( "echo '1' > /sys/class/gpio/gpio14/value" );
    system( "systemctl restart g-code-interpreter cnc-driver bootload" );

    return 0;
}

