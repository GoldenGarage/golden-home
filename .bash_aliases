# .bash_aliases
#
# last-modified: <2014-07-09 18:13:04 golden@golden-garage.net>
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# em {file}
#    connect the tty to an emacs-server

function em()
{
    emacsclient --alternate-editor="" --tty $@
}

# ---------------------------------------------------------------------------------------------------------------------
# sem {file}
#    connect the tty to an emacs-server with root privileges

function sem()
{
    sudo bash -c "emacsclient --alternate-editor='' --tty $@"
}

# ---------------------------------------------------------------------------------------------------------------------
# ipaddr {interface}
#    display ipaddress of specified interface (eth0)

function ipaddr()
{
    ifconfig | awk "BEGIN         { s=0; }

                    /^${1:-eth0}/ { s++; } 

                    { switch ( s )
                      {
                        case 1:                        s++;     break;
                        case 2: { print substr(\$2,6); s++; };  break;
                      }
                    }"
}

# ---------------------------------------------------------------------------------------------------------------------
# Local Variables:
# mode: sh
# End:
