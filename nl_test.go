package nlink

import (
	"net"
	"syscall"
	"testing"
	"unsafe"

	"github.com/hkwi/nlgo"
)

func BenchmarkNetlink(b *testing.B) {
	var hub *nlgo.RtHub
	var err error
	if hub, err = nlgo.NewRtHub(); err != nil {
		//fmt.Println(os.NewSyscallError("netlinkrib", err))
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
		//fmt.Println(err)
	} else {

		b.ResetTimer()
		for z := 0; z < b.N; z++ {
		loop:
			for _, r := range res {
				switch r.Header.Type {
				case syscall.RTM_NEWLINK:
					msg := nlgo.IfInfoMessage(r)
					if msg.IfInfo().Index != int32(2) {
						//pass
					}
					attrs, _ := msg.Attrs()
					switch attrs.(type) {
					case nlgo.AttrMap:
						stat := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_STATS64).(nlgo.Binary)
						_ = (*nlgo.RtnlLinkStats64)(unsafe.Pointer(&stat[0]))

						_ = string(attrs.(nlgo.AttrMap).Get(nlgo.IFLA_IFNAME).(nlgo.NulString))
						_ = (net.HardwareAddr)([]byte(attrs.(nlgo.AttrMap).Get(nlgo.IFLA_ADDRESS).(nlgo.Binary)))
						//fmt.Println(i, mac, s)

						linkinfo := attrs.(nlgo.AttrMap).Get(nlgo.IFLA_LINKINFO)
						var linki nlgo.AttrMap
						switch linkinfo.(type) {
						case nlgo.AttrMap:
							linki = linkinfo.(nlgo.AttrMap)
							_ = string(linki.Get(nlgo.IFLA_INFO_KIND).(nlgo.NulString))
						}
					}
				case syscall.NLMSG_DONE:
					break loop
				}
			}
			//time.Sleep(time.Second * 5)
		}
	}
}
