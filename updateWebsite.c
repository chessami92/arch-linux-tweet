#include <unistd.h>

int main() {
    setuid( 0 );
    system( "/home/http/updateWebsite.sh" );

    return 0;
}
