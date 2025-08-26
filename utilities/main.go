package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"regexp"
	"strings"
)

// Commit represents a GitHub commit
type Commit struct {
	HTMLURL string `json:"html_url"`
	Commit  struct {
		Message string `json:"message"`
		Author  struct {
			Name string `json:"name"`
			Date string `json:"date"`
		} `json:"author"`
	} `json:"commit"`
}

type CommitsResponse []Commit

func fetchAllCommits(repo, branch string) ([]Commit, error) {
	url := fmt.Sprintf("https://api.github.com/repos/%s/commits?sha=%s&per_page=100", repo, branch)
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	var commits CommitsResponse
	if err := json.NewDecoder(resp.Body).Decode(&commits); err != nil {
		return nil, err
	}
	return commits, nil
}

func extractKeywordsFromFile(filename string) ([]string, error) {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}
	re := regexp.MustCompile(`SSG-\d+`)
	matches := re.FindAllString(string(data), -1)
	return matches, nil
}

func formatCommits(title string, commits []Commit) string {
	var sb strings.Builder
	sb.WriteString(fmt.Sprintf("\n\n## %s\n", title))
	for _, c := range commits {
		sb.WriteString(fmt.Sprintf("- [%s](%s) by %s on %s\n", c.Commit.Message, c.HTMLURL, c.Commit.Author.Name, c.Commit.Author.Date))
	}
	return sb.String()
}

func main() {
	if len(os.Args) < 4 {
		fmt.Println("Usage: go run main.go <github_repo> <branch> <md_file>")
		os.Exit(1)
	}
	repoUrl := os.Args[1]
	branch := os.Args[2]
	mdFile := os.Args[3]

	keywords, err := extractKeywordsFromFile(mdFile)
	if err != nil {
		log.Fatalf("Failed to extract keywords: %v", err)
	}
	if len(keywords) == 0 {
		log.Fatalf("No ticket IDs found in file.")
	}
	keyword := keywords[0] // Use the first found ticket ID

	// Get all commits in main branch mentioning the ticket
	mainCommits, err := fetchAllCommits(repoUrl, "main")
	if err != nil {
		log.Fatalf("Error fetching commits from main: %v", err)
	}
	var mainMentions []Commit
	for _, c := range mainCommits {
		if strings.Contains(c.Commit.Message, keyword) {
			mainMentions = append(mainMentions, c)
		}
	}

	// Get all commits in the feature branch
	featureCommits, err := fetchAllCommits(repoUrl, branch)
	if err != nil {
		log.Fatalf("Error fetching commits from branch %s: %v", branch, err)
	}

	// Format results
	result := formatCommits(fmt.Sprintf("Commits mentioning %s in main", keyword), mainMentions)
	result += formatCommits(fmt.Sprintf("All commits in branch %s", branch), featureCommits)

	// Append to markdown file
	f, err := os.OpenFile(mdFile, os.O_APPEND|os.O_WRONLY, 0600)
	if err != nil {
		log.Fatalf("Failed to open markdown file: %v", err)
	}
	defer f.Close()
	if _, err := f.WriteString(result); err != nil {
		log.Fatalf("Failed to write to markdown file: %v", err)
	}
	fmt.Println("Results appended to", mdFile)
}
