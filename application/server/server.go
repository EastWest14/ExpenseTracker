package server

import (
	"fmt"
	"github.com/gorilla/mux"
	"net/http"
)

type Server struct {
	router *mux.Router
}

func NewServer() *Server {
	server := &Server{}
	return server
}

func (s *Server) Start() error {
	router := mux.NewRouter()
	router.HandleFunc("/", defaultHandler)
	router.HandleFunc("/poems", otherHandler)
	http.Handle("/", router)
	s.router = router
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		return err
	}
	return nil
}

func defaultHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "TraTaTa")
}

func otherHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "---")
}
