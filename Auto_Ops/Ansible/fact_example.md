

```yaml
{
    "_ansible_facts_gathered": true, 
    "ansible_all_ipv4_addresses": [
        "192.168.31.101"
    ], 
    "ansible_all_ipv6_addresses": [
        "fe80::bc41:2de3:ff63:3af4"
    ], 
    "ansible_apparmor": {
        "status": "disabled"
    }, 
    "ansible_architecture": "x86_64", 
    "ansible_bios_date": "05/19/2017", 
    "ansible_bios_version": "6.00", 
    "ansible_cmdline": {
        "BOOT_IMAGE": "/vmlinuz-3.10.0-1062.el7.x86_64", 
        "LANG": "en_US.UTF-8", 
        "crashkernel": "auto", 
        "quiet": true, 
        "rhgb": true, 
        "ro": true, 
        "root": "UUID=bc077b4e-3b49-4181-a916-732d581240be"
    }, 
    "ansible_date_time": {
        "date": "2019-08-20", 
        "day": "20", 
        "epoch": "1566269558", 
        "hour": "10", 
        "iso8601": "2019-08-20T02:52:38Z", 
        "iso8601_basic": "20190820T105238091763", 
        "iso8601_basic_short": "20190820T105238", 
        "iso8601_micro": "2019-08-20T02:52:38.091958Z", 
        "minute": "52", 
        "month": "08", 
        "second": "38", 
        "time": "10:52:38", 
        "tz": "CST", 
        "tz_offset": "+0800", 
        "weekday": "Tuesday", 
        "weekday_number": "2", 
        "weeknumber": "33", 
        "year": "2019"
    }, 
    "ansible_default_ipv4": {
        "address": "192.168.31.101", 
        "alias": "ens33", 
        "broadcast": "192.168.31.255", 
        "gateway": "192.168.31.1", 
        "interface": "ens33", 
        "macaddress": "00:0c:29:40:34:4e", 
        "mtu": 1500, 
        "netmask": "255.255.255.0", 
        "network": "192.168.31.0", 
        "type": "ether"
    }, 
    "ansible_default_ipv6": {}, 
    "ansible_device_links": {
        "ids": {
            "dm-0": [
                "dm-name-vg01-lv01", 
                "dm-uuid-LVM-YfYXqDQjL5fnZT2aHRWInhFfIZqig2cd1a8lYbvvlk6mTJSFAQg5dpjP9EdL9w3P"
            ], 
            "sdb1": [
                "lvm-pv-uuid-z63nAX-Luaa-7iLR-8rnF-INqZ-xIAb-SUvk0m"
            ]
        }, 
        "labels": {}, 
        "masters": {
            "sdb1": [
                "dm-0"
            ]
        }, 
        "uuids": {
            "dm-0": [
                "fe7e0d59-6127-4d78-94ac-b69b02dfdce8"
            ], 
            "sda1": [
                "f2ab0ef9-5691-4716-9048-c12621d7bfba"
            ], 
            "sda2": [
                "a911b1c8-a20a-49fd-9d0a-77a868b8ec3b"
            ], 
            "sda3": [
                "bc077b4e-3b49-4181-a916-732d581240be"
            ]
        }
    }, 
    "ansible_devices": {
        "dm-0": {
            "holders": [], 
            "host": "", 
            "links": {
                "ids": [
                    "dm-name-vg01-lv01", 
                    "dm-uuid-LVM-YfYXqDQjL5fnZT2aHRWInhFfIZqig2cd1a8lYbvvlk6mTJSFAQg5dpjP9EdL9w3P"
                ], 
                "labels": [], 
                "masters": [], 
                "uuids": [
                    "fe7e0d59-6127-4d78-94ac-b69b02dfdce8"
                ]
            }, 
            "model": null, 
            "partitions": {}, 
            "removable": "0", 
            "rotational": "1", 
            "sas_address": null, 
            "sas_device_handle": null, 
            "scheduler_mode": "", 
            "sectors": "838852608", 
            "sectorsize": "512", 
            "size": "400.00 GB", 
            "support_discard": "0", 
            "vendor": null, 
            "virtual": 1
        }, 
        "sda": {
            "holders": [], 
            "host": "SCSI storage controller: Broadcom / LSI 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 01)", 
            "links": {
                "ids": [], 
                "labels": [], 
                "masters": [], 
                "uuids": []
            }, 
            "model": "VMware Virtual S", 
            "partitions": {
                "sda1": {
                    "holders": [], 
                    "links": {
                        "ids": [], 
                        "labels": [], 
                        "masters": [], 
                        "uuids": [
                            "f2ab0ef9-5691-4716-9048-c12621d7bfba"
                        ]
                    }, 
                    "sectors": "614400", 
                    "sectorsize": 512, 
                    "size": "300.00 MB", 
                    "start": "2048", 
                    "uuid": "f2ab0ef9-5691-4716-9048-c12621d7bfba"
                }, 
                "sda2": {
                    "holders": [], 
                    "links": {
                        "ids": [], 
                        "labels": [], 
                        "masters": [], 
                        "uuids": [
                            "a911b1c8-a20a-49fd-9d0a-77a868b8ec3b"
                        ]
                    }, 
                    "sectors": "8128512", 
                    "sectorsize": 512, 
                    "size": "3.88 GB", 
                    "start": "616448", 
                    "uuid": "a911b1c8-a20a-49fd-9d0a-77a868b8ec3b"
                }, 
                "sda3": {
                    "holders": [], 
                    "links": {
                        "ids": [], 
                        "labels": [], 
                        "masters": [], 
                        "uuids": [
                            "bc077b4e-3b49-4181-a916-732d581240be"
                        ]
                    }, 
                    "sectors": "200970240", 
                    "sectorsize": 512, 
                    "size": "95.83 GB", 
                    "start": "8744960", 
                    "uuid": "bc077b4e-3b49-4181-a916-732d581240be"
                }
            }, 
            "removable": "0", 
            "rotational": "1", 
            "sas_address": null, 
            "sas_device_handle": null, 
            "scheduler_mode": "deadline", 
            "sectors": "209715200", 
            "sectorsize": "512", 
            "size": "100.00 GB", 
            "support_discard": "0", 
            "vendor": "VMware,", 
            "virtual": 1
        }, 
        "sdb": {
            "holders": [], 
            "host": "SCSI storage controller: Broadcom / LSI 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 01)", 
            "links": {
                "ids": [], 
                "labels": [], 
                "masters": [], 
                "uuids": []
            }, 
            "model": "VMware Virtual S", 
            "partitions": {
                "sdb1": {
                    "holders": [
                        "vg01-lv01"
                    ], 
                    "links": {
                        "ids": [
                            "lvm-pv-uuid-z63nAX-Luaa-7iLR-8rnF-INqZ-xIAb-SUvk0m"
                        ], 
                        "labels": [], 
                        "masters": [
                            "dm-0"
                        ], 
                        "uuids": []
                    }, 
                    "sectors": "838858752", 
                    "sectorsize": 512, 
                    "size": "400.00 GB", 
                    "start": "2048", 
                    "uuid": null
                }
            }, 
            "removable": "0", 
            "rotational": "1", 
            "sas_address": null, 
            "sas_device_handle": null, 
            "scheduler_mode": "deadline", 
            "sectors": "838860800", 
            "sectorsize": "512", 
            "size": "400.00 GB", 
            "support_discard": "0", 
            "vendor": "VMware,", 
            "virtual": 1
        }
    }, 
    "ansible_distribution": "RedHat", 
    "ansible_distribution_file_parsed": true, 
    "ansible_distribution_file_path": "/etc/redhat-release", 
    "ansible_distribution_file_search_string": "Red Hat", 
    "ansible_distribution_file_variety": "RedHat", 
    "ansible_distribution_major_version": "7", 
    "ansible_distribution_release": "Maipo", 
    "ansible_distribution_version": "7.7", 
    "ansible_dns": {
        "nameservers": [
            "192.168.31.1"
        ]
    }, 
    "ansible_domain": "", 
    "ansible_effective_group_id": 0, 
    "ansible_effective_user_id": 0, 
    "ansible_ens33": {
        "active": true, 
        "device": "ens33", 
        "features": {
            "busy_poll": "off [fixed]", 
            "fcoe_mtu": "off [fixed]", 
            "generic_receive_offload": "on", 
            "generic_segmentation_offload": "on", 
            "highdma": "off [fixed]", 
            "hw_tc_offload": "off [fixed]", 
            "l2_fwd_offload": "off [fixed]", 
            "large_receive_offload": "off [fixed]", 
            "loopback": "off [fixed]", 
            "netns_local": "off [fixed]", 
            "ntuple_filters": "off [fixed]", 
            "receive_hashing": "off [fixed]", 
            "rx_all": "off", 
            "rx_checksumming": "off", 
            "rx_fcs": "off", 
            "rx_gro_hw": "off [fixed]", 
            "rx_udp_tunnel_port_offload": "off [fixed]", 
            "rx_vlan_filter": "on [fixed]", 
            "rx_vlan_offload": "on", 
            "rx_vlan_stag_filter": "off [fixed]", 
            "rx_vlan_stag_hw_parse": "off [fixed]", 
            "scatter_gather": "on", 
            "tcp_segmentation_offload": "on", 
            "tx_checksum_fcoe_crc": "off [fixed]", 
            "tx_checksum_ip_generic": "on", 
            "tx_checksum_ipv4": "off [fixed]", 
            "tx_checksum_ipv6": "off [fixed]", 
            "tx_checksum_sctp": "off [fixed]", 
            "tx_checksumming": "on", 
            "tx_fcoe_segmentation": "off [fixed]", 
            "tx_gre_csum_segmentation": "off [fixed]", 
            "tx_gre_segmentation": "off [fixed]", 
            "tx_gso_partial": "off [fixed]", 
            "tx_gso_robust": "off [fixed]", 
            "tx_ipip_segmentation": "off [fixed]", 
            "tx_lockless": "off [fixed]", 
            "tx_nocache_copy": "off", 
            "tx_scatter_gather": "on", 
            "tx_scatter_gather_fraglist": "off [fixed]", 
            "tx_sctp_segmentation": "off [fixed]", 
            "tx_sit_segmentation": "off [fixed]", 
            "tx_tcp6_segmentation": "off [fixed]", 
            "tx_tcp_ecn_segmentation": "off [fixed]", 
            "tx_tcp_mangleid_segmentation": "off", 
            "tx_tcp_segmentation": "on", 
            "tx_udp_tnl_csum_segmentation": "off [fixed]", 
            "tx_udp_tnl_segmentation": "off [fixed]", 
            "tx_vlan_offload": "on [fixed]", 
            "tx_vlan_stag_hw_insert": "off [fixed]", 
            "udp_fragmentation_offload": "off [fixed]", 
            "vlan_challenged": "off [fixed]"
        }, 
        "hw_timestamp_filters": [], 
        "ipv4": {
            "address": "192.168.31.101", 
            "broadcast": "192.168.31.255", 
            "netmask": "255.255.255.0", 
            "network": "192.168.31.0"
        }, 
        "ipv6": [
            {
                "address": "fe80::bc41:2de3:ff63:3af4", 
                "prefix": "64", 
                "scope": "link"
            }
        ], 
        "macaddress": "00:0c:29:40:34:4e", 
        "module": "e1000", 
        "mtu": 1500, 
        "pciid": "0000:02:01.0", 
        "promisc": false, 
        "speed": 1000, 
        "timestamping": [
            "tx_software", 
            "rx_software", 
            "software"
        ], 
        "type": "ether"
    }, 
    "ansible_env": {
        "HISTCONTROL": "ignoredups", 
        "HISTSIZE": "1000", 
        "HOME": "/root", 
        "HOSTNAME": "server", 
        "LANG": "en_US.UTF-8", 
        "LESSOPEN": "||/usr/bin/lesspipe.sh %s", 
        "LOGNAME": "root", 
        "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:", 
        "MAIL": "/var/spool/mail/root", 
        "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin", 
        "PWD": "/playbook/ansible_cmdb", 
        "SHELL": "/bin/bash", 
        "SHLVL": "3", 
        "SSH_CLIENT": "192.168.31.5 52614 22", 
        "SSH_CONNECTION": "192.168.31.5 52614 192.168.31.101 22", 
        "SSH_TTY": "/dev/pts/0", 
        "TERM": "linux", 
        "USER": "root", 
        "XDG_RUNTIME_DIR": "/run/user/0", 
        "XDG_SESSION_ID": "1", 
        "_": "/usr/bin/python"
    }, 
    "ansible_fibre_channel_wwn": [], 
    "ansible_fips": false, 
    "ansible_form_factor": "Other", 
    "ansible_fqdn": "server", 
    "ansible_hostname": "server", 
    "ansible_hostnqn": "", 
    "ansible_interfaces": [
        "lo", 
        "ens33"
    ], 
    "ansible_is_chroot": false, 
    "ansible_iscsi_iqn": "", 
    "ansible_kernel": "3.10.0-1062.el7.x86_64", 
    "ansible_lo": {
        "active": true, 
        "device": "lo", 
        "features": {
            "busy_poll": "off [fixed]", 
            "fcoe_mtu": "off [fixed]", 
            "generic_receive_offload": "on", 
            "generic_segmentation_offload": "on", 
            "highdma": "on [fixed]", 
            "hw_tc_offload": "off [fixed]", 
            "l2_fwd_offload": "off [fixed]", 
            "large_receive_offload": "off [fixed]", 
            "loopback": "on [fixed]", 
            "netns_local": "on [fixed]", 
            "ntuple_filters": "off [fixed]", 
            "receive_hashing": "off [fixed]", 
            "rx_all": "off [fixed]", 
            "rx_checksumming": "on [fixed]", 
            "rx_fcs": "off [fixed]", 
            "rx_gro_hw": "off [fixed]", 
            "rx_udp_tunnel_port_offload": "off [fixed]", 
            "rx_vlan_filter": "off [fixed]", 
            "rx_vlan_offload": "off [fixed]", 
            "rx_vlan_stag_filter": "off [fixed]", 
            "rx_vlan_stag_hw_parse": "off [fixed]", 
            "scatter_gather": "on", 
            "tcp_segmentation_offload": "on", 
            "tx_checksum_fcoe_crc": "off [fixed]", 
            "tx_checksum_ip_generic": "on [fixed]", 
            "tx_checksum_ipv4": "off [fixed]", 
            "tx_checksum_ipv6": "off [fixed]", 
            "tx_checksum_sctp": "on [fixed]", 
            "tx_checksumming": "on", 
            "tx_fcoe_segmentation": "off [fixed]", 
            "tx_gre_csum_segmentation": "off [fixed]", 
            "tx_gre_segmentation": "off [fixed]", 
            "tx_gso_partial": "off [fixed]", 
            "tx_gso_robust": "off [fixed]", 
            "tx_ipip_segmentation": "off [fixed]", 
            "tx_lockless": "on [fixed]", 
            "tx_nocache_copy": "off [fixed]", 
            "tx_scatter_gather": "on [fixed]", 
            "tx_scatter_gather_fraglist": "on [fixed]", 
            "tx_sctp_segmentation": "on", 
            "tx_sit_segmentation": "off [fixed]", 
            "tx_tcp6_segmentation": "on", 
            "tx_tcp_ecn_segmentation": "on", 
            "tx_tcp_mangleid_segmentation": "on", 
            "tx_tcp_segmentation": "on", 
            "tx_udp_tnl_csum_segmentation": "off [fixed]", 
            "tx_udp_tnl_segmentation": "off [fixed]", 
            "tx_vlan_offload": "off [fixed]", 
            "tx_vlan_stag_hw_insert": "off [fixed]", 
            "udp_fragmentation_offload": "on", 
            "vlan_challenged": "on [fixed]"
        }, 
        "hw_timestamp_filters": [], 
        "ipv4": {
            "address": "127.0.0.1", 
            "broadcast": "host", 
            "netmask": "255.0.0.0", 
            "network": "127.0.0.0"
        }, 
        "ipv6": [
            {
                "address": "::1", 
                "prefix": "128", 
                "scope": "host"
            }
        ], 
        "mtu": 65536, 
        "promisc": false, 
        "timestamping": [
            "rx_software", 
            "software"
        ], 
        "type": "loopback"
    }, 
    "ansible_local": {}, 
    "ansible_lsb": {}, 
    "ansible_lvm": {
        "lvs": {
            "lv01": {
                "size_g": "400.00", 
                "vg": "vg01"
            }
        }, 
        "pvs": {
            "/dev/sdb1": {
                "free_g": "0", 
                "size_g": "400.00", 
                "vg": "vg01"
            }
        }, 
        "vgs": {
            "vg01": {
                "free_g": "0", 
                "num_lvs": "1", 
                "num_pvs": "1", 
                "size_g": "400.00"
            }
        }
    }, 
    "ansible_machine": "x86_64", 
    "ansible_machine_id": "0bc66c47eba34e0a9a0f4f637df3e688", 
    "ansible_memfree_mb": 84, 
    "ansible_memory_mb": {
        "nocache": {
            "free": 1505, 
            "used": 314
        }, 
        "real": {
            "free": 84, 
            "total": 1819, 
            "used": 1735
        }, 
        "swap": {
            "cached": 0, 
            "free": 3968, 
            "total": 3968, 
            "used": 0
        }
    }, 
    "ansible_memtotal_mb": 1819, 
    "ansible_mounts": [
        {
            "block_available": 42573, 
            "block_size": 4096, 
            "block_total": 75945, 
            "block_used": 33372, 
            "device": "/dev/sda1", 
            "fstype": "xfs", 
            "inode_available": 153275, 
            "inode_total": 153600, 
            "inode_used": 325, 
            "mount": "/boot", 
            "options": "rw,relatime,attr2,inode64,noquota", 
            "size_available": 174379008, 
            "size_total": 311070720, 
            "uuid": "f2ab0ef9-5691-4716-9048-c12621d7bfba"
        }, 
        {
            "block_available": 98487987, 
            "block_size": 4096, 
            "block_total": 104805377, 
            "block_used": 6317390, 
            "device": "/dev/mapper/vg01-lv01", 
            "fstype": "xfs", 
            "inode_available": 209690175, 
            "inode_total": 209713152, 
            "inode_used": 22977, 
            "mount": "/mnt/File_Storage", 
            "options": "rw,relatime,attr2,inode64,noquota", 
            "size_available": 403406794752, 
            "size_total": 429282824192, 
            "uuid": "fe7e0d59-6127-4d78-94ac-b69b02dfdce8"
        }, 
        {
            "block_available": 18797407, 
            "block_size": 4096, 
            "block_total": 25109014, 
            "block_used": 6311607, 
            "device": "/dev/sda3", 
            "fstype": "xfs", 
            "inode_available": 50160485, 
            "inode_total": 50242560, 
            "inode_used": 82075, 
            "mount": "/", 
            "options": "rw,relatime,attr2,inode64,noquota", 
            "size_available": 76994179072, 
            "size_total": 102846521344, 
            "uuid": "bc077b4e-3b49-4181-a916-732d581240be"
        }
    ], 
    "ansible_nodename": "server", 
    "ansible_os_family": "RedHat", 
    "ansible_pkg_mgr": "yum", 
    "ansible_proc_cmdline": {
        "BOOT_IMAGE": "/vmlinuz-3.10.0-1062.el7.x86_64", 
        "LANG": "en_US.UTF-8", 
        "crashkernel": "auto", 
        "quiet": true, 
        "rhgb": true, 
        "ro": true, 
        "root": "UUID=bc077b4e-3b49-4181-a916-732d581240be"
    }, 
    "ansible_processor": [
        "0", 
        "GenuineIntel", 
        "Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz", 
        "1", 
        "GenuineIntel", 
        "Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz"
    ], 
    "ansible_processor_cores": 1, 
    "ansible_processor_count": 2, 
    "ansible_processor_threads_per_core": 1, 
    "ansible_processor_vcpus": 2, 
    "ansible_product_name": "VMware Virtual Platform", 
    "ansible_product_serial": "VMware-56 4d 78 de 5b 28 a8 ac-a0 84 a1 aa 31 40 34 4e", 
    "ansible_product_uuid": "DE784D56-285B-ACA8-A084-A1AA3140344E", 
    "ansible_product_version": "None", 
    "ansible_python": {
        "executable": "/usr/bin/python", 
        "has_sslcontext": true, 
        "type": "CPython", 
        "version": {
            "major": 2, 
            "micro": 5, 
            "minor": 7, 
            "releaselevel": "final", 
            "serial": 0
        }, 
        "version_info": [
            2, 
            7, 
            5, 
            "final", 
            0
        ]
    }, 
    "ansible_python_version": "2.7.5", 
    "ansible_real_group_id": 0, 
    "ansible_real_user_id": 0, 
    "ansible_selinux": {
        "status": "disabled"
    }, 
    "ansible_selinux_python_present": true, 
    "ansible_service_mgr": "systemd", 
    "ansible_ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCABh/vq0j+lotmvJU463jIPBom8VHXk7rsOD8yeucMBkibW6s4U6yhL6clVUZ/qRhH5zQG+RVd1uPAZLawXrrs=", 
    "ansible_ssh_host_key_ed25519_public": "AAAAC3NzaC1lZDI1NTE5AAAAIENt89mlig+TRRuUu83e78hiwo1W9MTH/pixzul27I3U", 
    "ansible_ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDRhVQ1/XusbbBrrv3Ffp36Fhbv0eOnHWYv1ldPgrT57Cz/TWq8228BXHhE4jxYwmrXoyPIhyJRctFEzr7Fo0u0oGtscOZDufPD1qrtXrdXoY/bbDc3GZ3lwVfh48ioagwOpmchoFHauN4iRp72Gtfc3nzMrOn3KavsGHUjuFBOJZd+zuI9K0RAHsRJvrxRinRDm3TDojAIbrg+/sP7ahA3V0VSuC6qJykm0nGjQfaWiBM7wGr59csj7rD2qan3Nw3HFBwNUxA60lX0+YLg4Nl/5NP2iGeACBNlkQxz7AuxQk4DOqN2VnQ9Rn2GMBtltuixDALdLcXWp9/qRpN91PrH", 
    "ansible_swapfree_mb": 3968, 
    "ansible_swaptotal_mb": 3968, 
    "ansible_system": "Linux", 
    "ansible_system_capabilities": [
        "cap_chown", 
        "cap_dac_override", 
        "cap_dac_read_search", 
        "cap_fowner", 
        "cap_fsetid", 
        "cap_kill", 
        "cap_setgid", 
        "cap_setuid", 
        "cap_setpcap", 
        "cap_linux_immutable", 
        "cap_net_bind_service", 
        "cap_net_broadcast", 
        "cap_net_admin", 
        "cap_net_raw", 
        "cap_ipc_lock", 
        "cap_ipc_owner", 
        "cap_sys_module", 
        "cap_sys_rawio", 
        "cap_sys_chroot", 
        "cap_sys_ptrace", 
        "cap_sys_pacct", 
        "cap_sys_admin", 
        "cap_sys_boot", 
        "cap_sys_nice", 
        "cap_sys_resource", 
        "cap_sys_time", 
        "cap_sys_tty_config", 
        "cap_mknod", 
        "cap_lease", 
        "cap_audit_write", 
        "cap_audit_control", 
        "cap_setfcap", 
        "cap_mac_override", 
        "cap_mac_admin", 
        "cap_syslog", 
        "35", 
        "36+ep"
    ], 
    "ansible_system_capabilities_enforced": "True", 
    "ansible_system_vendor": "VMware, Inc.", 
    "ansible_uptime_seconds": 90007, 
    "ansible_user_dir": "/root", 
    "ansible_user_gecos": "root", 
    "ansible_user_gid": 0, 
    "ansible_user_id": "root", 
    "ansible_user_shell": "/bin/bash", 
    "ansible_user_uid": 0, 
    "ansible_userspace_architecture": "x86_64", 
    "ansible_userspace_bits": "64", 
    "ansible_virtualization_role": "guest", 
    "ansible_virtualization_type": "VMware", 
    "discovered_interpreter_python": "/usr/bin/python", 
    "gather_subset": [
        "all"
    ], 
    "module_setup": true
}
```

