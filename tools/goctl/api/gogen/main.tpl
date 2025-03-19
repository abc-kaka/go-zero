package main

import (
    "common/tool"
	"common/util/xconfig"
	"flag"
	"fmt"

	{{.importPackages}}
)

// var configFile = flag.String("f", "etc/{{.serviceName}}.yaml", "the config file")
var configFile = flag.String("f", "", "the config file")

func main() {
	flag.Parse()

	var c config.Config
	xconfig.Load(&c, *configFile)
	tool.ApiRegisterTool(&c.APIConfig)

	server := rest.MustNewServer(c.RestConf)
	defer server.Stop()

	ctx := svc.NewServiceContext(c)
	handler.RegisterHandlers(server, ctx)

	fmt.Printf("Starting server at %s:%d...\n", c.Host, c.Port)
	server.Start()
}
