package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/joho/godotenv"

	cloudevents "github.com/cloudevents/sdk-go/v2"
	cehttp "github.com/cloudevents/sdk-go/v2/protocol/http"
)

var sinkURL string

func main() {
	// .env-Datei laden
	err := godotenv.Load()
	if err != nil {
		log.Println("⚠️  Keine .env-Datei gefunden, verwende Systemvariablen")
	}

	// Sink aus Umgebungsvariable (K_SINK wird von Knative gesetzt)
	sinkURL = os.Getenv("K_SINK")
	if sinkURL == "" {
		log.Fatal("K_SINK environment variable is not set")
	}
	log.Printf("Using sink URL: %s\n", sinkURL)

	http.HandleFunc("/", handleRequest)
	log.Println("Listening on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func handleRequest(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Only POST allowed", http.StatusMethodNotAllowed)
		return
	}

	var payload map[string]interface{}
	err := json.NewDecoder(r.Body).Decode(&payload)
	if err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	// CloudEvent erstellen
	event := cloudevents.NewEvent()
	event.SetID(fmt.Sprintf("id-%d", time.Now().UnixNano()))
	event.SetSource("custom.go.source")
	event.SetType("custom.source.event")
	event.SetTime(time.Now())
	err = event.SetData(cloudevents.ApplicationJSON, payload)
	if err != nil {
		http.Error(w, "Failed to encode CloudEvent", http.StatusInternalServerError)
		return
	}

	// Als HTTP-Request senden
	sendEventToSink(event)

	w.WriteHeader(http.StatusAccepted)
	w.Write([]byte("Event forwarded\n"))
}

func sendEventToSink(event cloudevents.Event) {
	ctx := cloudevents.ContextWithTarget(context.Background(), sinkURL)
	p, err := cehttp.New()
	if err != nil {
		log.Printf("Failed to create protocol: %v", err)
		return
	}

	client, err := cloudevents.NewClient(p)
	if err != nil {
		log.Printf("Failed to create CloudEvents client: %v", err)
		return
	}

	result := client.Send(ctx, event)
	if cloudevents.IsUndelivered(result) {
		log.Printf("Failed to send: %v", result)
	} else {
		log.Printf("Sent: %s", event.ID())
	}
}
