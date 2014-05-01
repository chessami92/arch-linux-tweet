#include <unistd.h>

int main() {
    setuid( 0 );
    system( "echo '14' > /sys/class/gpio/export" );
    system( "echo 'out' > /sys/class/gpio/gpio14/direction" );
    system( "echo '0' > /sys/class/gpio/gpio14/value" );
    system( "systemctl stop g-code-interpreter cnc-driver" );
    system( "dd if=/home/cnc/gcode iflag=nonblock of=/dev/null" );
    system( "dd if=/home/cnc/serial-data iflag=nonblock of=/dev/null" );
    system( "sleep 3" );
    system( "echo '1' > /sys/class/gpio/gpio14/value" );
    system( "systemctl start g-code-interpreter cnc-driver" );

    return 0;
}

