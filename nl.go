package main

import (
	"fmt"
	"net"
	"unsafe"
	//"net"
	"os"
	"syscall"

	"github.com/davecgh/go-spew/spew"
	"github.com/hkwi/nlgo"
)

func main() {
	//tab, err := syscall.NetlinkRIB(syscall.RTM_GETLINK, syscall.NLM_F_DUMP)
	var hub *nlgo.RtHub
	var err error
	if hub, err = nlgo.NewRtHub(); err != nil {
		fmt.Println(os.NewSyscallError("netlinkrib", err))
	}
	defer hub.Close()
	req := syscall.NetlinkMessage{
		Header: syscall.NlMsghdr{
			Type:  syscall.RTM_GETLINK,
			Flags: syscall.NLM_F_DUMP,
		},
	}
	(*nlgo.IfInfoMessage)(&req).Set(
		syscall.IfInfomsg{
			Index: int32(1),
		},
		nlgo.AttrSlice{
			nlgo.Attr{
				Header: syscall.NlAttr{
					Type: syscall.IFLA_IFNAME,
				},
				Value: nlgo.NulString("em1"),
			},
		},
	)
	//for {
	if res, err := hub.Sync(req); err != nil {
		fmt.Println(err)
	} else {
	loop:
		for _, r := range res {
			switch r.Header.Type {
			case syscall.RTM_NEWLINK:
				msg := nlgo.IfInfoMessage(r)
				if msg.IfInfo().Index != int32(2) {
					//pass
				}
				attrs, _ := msg.Attrs()
				//spew.Dump(attrs)
				switch attrs.(type) {
				case nlgo.AttrMap:
					stat := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_STATS64).(nlgo.Binary)
					//stat := []byte(a.(nlgo.Binary))
					s := (*nlgo.RtnlLinkStats64)(unsafe.Pointer(&stat[0]))

					i := string(attrs.(nlgo.AttrMap).Get(nlgo.IFLA_IFNAME).(nlgo.NulString))
					spew.Dump(i)
					mac := []byte(attrs.(nlgo.AttrMap).Get(nlgo.IFLA_ADDRESS).(nlgo.Binary))
					spew.Dump((net.HardwareAddr)(mac))
					spew.Dump(s)

					linkinfo := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_LINKINFO)
					var linki nlgo.AttrMap
					switch linkinfo.(type) {
					case nlgo.AttrMap:
						linki = linkinfo.(nlgo.AttrMap)
						spew.Dump(string(linki.Get(nlgo.IFLA_INFO_KIND).(nlgo.NulString)))
					}
				}

				//spew.Dump(&m.Data[0])
				//ifinfo := (*syscall.IfInfomsg)(unsafe.Pointer(&m.Data[0]))
				//if attrs, err := nlgo.RouteLinkPolicy.Parse(m.Data[nlgo.NLA_ALIGN(syscall.SizeofIfInfomsg):]); err != nil {
				//panic(err)
				//} else {
				//i := string(attrs.(nlgo.AttrMap).Get(nlgo.IFLA_IFNAME).(nlgo.NulString))
				//if i != "em1" {
				//continue
				//}
				//addr := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_ADDRESS)
				//mtu := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_MTU)
				//brdcst := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_BROADCAST)
				//linkinfo := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_LINKINFO)
				//var linki nlgo.AttrMap
				//switch linkinfo.(type) {
				//case nlgo.AttrMap:
				//linki = linkinfo.(nlgo.AttrMap)
				//spew.Dump(string(linki.Get(nlgo.IFLA_INFO_KIND).(nlgo.NulString)))
				//}

				////linkmode := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_LINKMODE)
				////link := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_LINK)
				////spew.Dump(addr, mtu, brdcst, link, linkmode, linkinfo)
				//a := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_STATS64)
				//stat := []byte(a.(nlgo.Binary))
				//s := (*nlgo.RtnlLinkStats64)(unsafe.Pointer(&stat[0]))
				//spew.Dump(i)
				//spew.Dump(s)
				//time.Sleep(time.Second * 5)
				//s = (*nlgo.RtnlLinkStats64)(unsafe.Pointer(&stat[0]))
				//spew.Dump(s)
				//}
			case syscall.NLMSG_DONE:
				break loop
			}
		}
		//time.Sleep(time.Second * 5)
		//}
	}
}
