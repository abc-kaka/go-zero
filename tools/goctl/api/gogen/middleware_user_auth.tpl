package middleware

import (
	"common/tool"
	"common/util/xctx"
	"common/util/xerrors"
	"common/util/xhttp"
	"errors"
	"fmt"
	"net/http"
	"proto/user"
)

type UserAuthInterceptorMiddleware struct {
}

func NewUserAuthInterceptorMiddleware() *UserAuthInterceptorMiddleware {
	return &UserAuthInterceptorMiddleware{}
}

func (m *UserAuthInterceptorMiddleware) Handle(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if err := recover(); err != nil {
				err = xerrors.New(r.Context(), errors.New(fmt.Sprintf("%v", err)))
				xhttp.Json(r.Context(), w, nil, errors.New("系统异常：用户鉴权失败！"))
				return
			}
		}()
		userId := xctx.UserId(r.Context())
		res, err := tool.GetTool().Rpc.User.User.VerifyPermission(r.Context(), &user.VerifyPermissionReq{
			UserId: userId,
			Url:    r.URL.Path,
		})
		if err != nil {
			xhttp.Json(r.Context(), w, nil, err)
			return
		}
		if !res.Access {
			xhttp.Json(r.Context(), w, nil, errors.New(fmt.Sprintf("权限不足：%s", res.Name)))
			return
		}
		next(w, r)
	}
}
