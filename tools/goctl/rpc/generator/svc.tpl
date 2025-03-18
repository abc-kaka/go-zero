package svc

import {{.imports}}

type ServiceContext struct {
	Config config.Config
	Model  ModelContext
}

func NewServiceContext(c config.Config) *ServiceContext {
	return &ServiceContext{
		Config:c,
		Model:NewModelContext(),
	}
}
