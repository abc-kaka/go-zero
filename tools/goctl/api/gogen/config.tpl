package config

import (
    "common/config"
    {{.authImport}}
)
type Config struct {
    config.APIConfig
	{{.auth}}
	{{.jwtTrans}}
}
