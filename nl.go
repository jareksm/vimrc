package main

import (
	"fmt"
	//"net"
	"os"
	"syscall"

	"github.com/davecgh/go-spew/spew"
)

func main() {
	tab, err := syscall.NetlinkRIB(syscall.RTM_GETLINK, syscall.AF_UNSPEC)
	if err != nil {
		fmt.Println(os.NewSyscallError("netlinkrib", err))
	}
	//spew.Dump(tab)
	msgs, err := syscall.ParseNetlinkMessage(tab)
	if err != nil {
		os.NewSyscallError("parsenetlinkmessage", err)
	}
	//spew.Dump(msgs)
	//var ift []net.Interface
	loop:
	for _, m := range msgs {
		switch m.Header.Type {
		case syscall.NLMSG_DONE:
			break loop
		case syscall.RTM_NEWLINK:
			spew.Dump(&m.Data[0])
			//ifim := (*syscall.IfInfomsg)(unsafe.Pointer(&m.Data[0]))
			attrs, _ := syscall.ParseNetlinkRouteAttr(&m)
			spew.Dump(attrs)
			//if err != nil {
				//fmt.Println(os.NewSyscallError("parsenetlinkrouteattr", err))
			//}
		}
	}
}
