#include <unistd.h>

int main() {
    setuid( 0 );
    system( "cp -r /home/http/website-control/* /srv/http/" );
    system( "chown -R root:root /srv/http/" );
    system( "chmod -R 755 /srv/http" );

    return 0;
}
