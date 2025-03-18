package main

import (
	"flag"
	"fmt"

	{{.imports}}

    "common/tool"
	"common/util/xconfig"
	"github.com/zeromicro/go-zero/core/service"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

// var configFile = flag.String("f", "etc/{{.serviceName}}.yaml", "the config file")
var configFile = flag.String("f", "", "the config file")

func main() {
	flag.Parse()

	var c config.Config
	xconfig.Load(&c, *configFile)
	tool.RpcRegisterTool(c.RPCConfig)
	ctx := svc.NewServiceContext(c)

	s := zrpc.MustNewServer(c.RpcServerConf, func(grpcServer *grpc.Server) {
{{range .serviceNames}}       {{.Pkg}}.Register{{.GRPCService}}Server(grpcServer, {{.ServerPkg}}.New{{.Service}}Server(ctx))
{{end}}
		if c.Mode == service.DevMode || c.Mode == service.TestMode {
			reflection.Register(grpcServer)
		}
	})
	defer s.Stop()

	fmt.Printf("Starting rpc server at %s...\n", c.ListenOn)
	s.Start()
}
