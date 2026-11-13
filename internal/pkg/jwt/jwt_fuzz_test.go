package jwt

import (
	"testing"
	"time"

	"github.com/google/uuid"
	"mentorhub/internal/domain"
)

func FuzzParseToken(f *testing.F) {
	manager := NewManager(
		"test_secret_key_for_fuzzing_123456",
		15*time.Minute,
		7*24*time.Hour,
	)

	validToken, err := manager.GenerateAccessToken(
		uuid.New(),
		domain.RoleMentor,
	)
	if err != nil {
		f.Fatal(err)
	}

	f.Add("")
	f.Add("invalid-token")
	f.Add("header.payload.signature")
	f.Add(validToken)
	f.Add("eyJhbGciOiJub25lIn0.eyJ1aWQiOiIxMjMifQ.")

	f.Fuzz(func(t *testing.T, token string) {
		_, _ = manager.Parse(token)
	})
}
