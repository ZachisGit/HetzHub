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
	if len(os.Args) < 6 {
		fmt.Println("subdomain-service <ip> <domain e.g. hetzhub.com> <zone_id> <hetzner_dns_auth_token> <output_file>")
		return
	}

	ip := os.Args[1]
	main_domain := os.Args[2]
	zone_id := os.Args[3]
	hetzner_dns_auth_token := os.Args[4]
	output_file := os.Args[5]
	subdomain := generateRandomSubdomain(8)
	createDNSRecord(ip, subdomain, zone_id, hetzner_dns_auth_token)

	output := subdomain + "." + main_domain
	err := ioutil.WriteFile(output_file, []byte(output), 0644)
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

func createDNSRecord(ip, subdomain, zone_id, hetzner_dns_auth_token string) {
	json := []byte(fmt.Sprintf(`{"value": "%s","ttl": 86400,"type": "A","name": "%s","zone_id": "%s"}`, ip, subdomain, zone_id))
	body := bytes.NewBuffer(json)

	client := &http.Client{}

	req, err := http.NewRequest("POST", "https://dns.hetzner.com/api/v1/records", body)
	if err != nil {
		log.Fatal(err)
	}

	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Auth-API-Token", hetzner_dns_auth_token)

	resp, err := client.Do(req)
	if err != nil || resp.StatusCode != 200 {
		log.Fatal(err)
	}
}
