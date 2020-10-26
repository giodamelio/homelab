# einsteinium

Machine: Dell Poweredge R710
OS: CentOS 8
Purpose: VM Host, Ovirt Host and Engine

## Creation Notes

### RAID Card not supported drivers

Since the drivers for the raid card were dropped starting in CentOS 8, we need to install the drivers from [ELRepo](http://elrepo.org).

    # rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    # dnf install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
    # yum --enablerepo=elrepo* install kmod-megaraid_sas

### Cockpit

We need a couple of extra Cockpit plugins:

    yum install cockpit-dashboard cockpit-storaged cockpit-machines