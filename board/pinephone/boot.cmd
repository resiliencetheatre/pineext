setenv bootargs console=ttyS0,115200 quiet loglevel=3 root=/dev/mmcblk0p2 rootwait

fatload mmc 0 $kernel_addr_r Image
fatload mmc 0 $fdt_addr_r sun50i-a64-pinephone-1.2.dtb

booti $kernel_addr_r - $fdt_addr_r
