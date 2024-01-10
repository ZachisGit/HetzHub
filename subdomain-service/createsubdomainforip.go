package main

import (
	"bytes"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("IP address is required")
		return
	}

	ip := os.Args[1]
	subdomain := generateRandomSubdomain(8)
	createDNSRecord(ip, subdomain)

	output := subdomain + ".YOUR_DOMAIN"
	err := ioutil.WriteFile("/hetzhub/hostname", []byte(output), 0644)
	if err != nil {
		log.Fatal(err)
	}
}

func generateRandomSubdomain(n int) string {
	bytes := make([]byte, n)
	_, err := rand.Read(bytes)
	if err != nil {
		log.Fatal(err)
	}
	return hex.EncodeToString(bytes)
}

func createDNSRecord(ip, subdomain string) {
	json := []byte(fmt.Sprintf(`{"value": "%s","ttl": 86400,"type": "A","name": "%s","zone_id": "YOUR_HETZNER_DOMAINS_ZONE_ID"}`, ip, subdomain))
	body := bytes.NewBuffer(json)

	client := &http.Client{}

	req, err := http.NewRequest("POST", "https://dns.hetzner.com/api/v1/records", body)
	if err != nil {
		log.Fatal(err)
	}

	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Auth-API-Token", "YOUR_HETZNER_DNS_API_TOKEN")

	resp, err := client.Do(req)
	if err != nil || resp.StatusCode != 200 {
		log.Fatal(err)
	}
}
