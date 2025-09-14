package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
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

// Extract all tags from a file (e.g. SSG-281, SSA-1)
func extractTagsFromFile(filename string) ([]string, error) {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}
	re := regexp.MustCompile(`[A-Z]{3}-\d+`)
	matches := re.FindAllString(string(data), -1)
	return matches, nil
}

// Fetch all commits from a repo and branch, filter by tag
func fetchCommits(repo string, branch string, tag string, debug bool) ([]Commit, error) {
	url := fmt.Sprintf("https://api.github.com/repos/%s/commits?sha=%s&per_page=40", repo, branch)
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != 200 {
		body, _ := ioutil.ReadAll(resp.Body)
		fmt.Printf("GitHub API error: %s\nStatus: %d\nResponse: %s\n", url, resp.StatusCode, string(body))
		return nil, fmt.Errorf("GitHub API returned status %d", resp.StatusCode)
	}
	var commits CommitsResponse
	if err := json.NewDecoder(resp.Body).Decode(&commits); err != nil {
		return nil, err
	}
	var result []Commit
	for _, c := range commits {
		if debug {
			fmt.Printf("Searched commit: %s by %s on %s\nURL: %s\n", c.Commit.Message, c.Commit.Author.Name, c.Commit.Author.Date, c.HTMLURL)
		}
		if strings.Contains(c.Commit.Message, tag) {
			result = append(result, c)
		}
	}
	return result, nil
}

func main() {
	// Define repos and branches to search
	var repos []string
	// var branches []string
	var debug bool
	if len(os.Args) == 3 {
		// If branch and repo are provided as arguments, use only those
		repos = []string{os.Args[2]}
		fmt.Printf("Filtering to branch: %s, repo: %s\n", os.Args[1], os.Args[2])
		debug = true
	} else {
		repos = []string{
			"signal-k/client",
			"signal-k/deepdock",
			"signal-k/manuscript",
			"signal-k/sytizen",
		}
		debug = false
	}

	// Find all board files
	boardDir := "content/Boards"
	files, err := filepath.Glob(filepath.Join(boardDir, "*.md"))
	if err != nil {
		log.Fatalf("Failed to list board files: %v", err)
	}

	tagRe := regexp.MustCompile(`[A-Z]{3}-\d+`)
	for _, file := range files {
		base := filepath.Base(file)
		tags := tagRe.FindAllString(base, -1)
		contentBytes, err := os.ReadFile(file)
		content := ""
		if err == nil {
			content = string(contentBytes)
		}
		contentTags := tagRe.FindAllString(content, -1)
		allTags := make(map[string]struct{})
		for _, tag := range tags {
			allTags[tag] = struct{}{}
		}
		for _, tag := range contentTags {
			allTags[tag] = struct{}{}
		}
		if len(allTags) > 0 {
			fmt.Printf("Processing file: %s\n", file)
			fmt.Printf("Tags found: %v\n", tags)
		}
		// For each tag in this file, process commit section
		contentToUpdate := content
		for tag := range allTags {
			var allCommits []Commit
			for _, repo := range repos {
				var repoBranches []string
				if repo == "signal-k/sytizen" {
					repoBranches = []string{"main", "SSG-100"}
				} else {
					repoBranches = []string{"main", "master", "SSG-281"}
				}
				for _, branch := range repoBranches {
					commits, err := fetchCommits(repo, branch, tag, debug)
					if err != nil {
						// Only skip if 404 (branch not found), otherwise print error
						if strings.Contains(err.Error(), "status 404") {
							continue
						} else {
							fmt.Printf("Error fetching commits for %s/%s: %v\n", repo, branch, err)
							continue
						}
					}
					if len(commits) > 0 {
						allCommits = append(allCommits, commits...)
					}
				}
			}
			if len(allCommits) == 0 {
				continue
			}
			// Format results
			var sb strings.Builder
			sb.WriteString(fmt.Sprintf("\n\n## Commits mentioning %s\n", tag))
			for _, c := range allCommits {
				sb.WriteString(fmt.Sprintf("- [%s](%s) by %s on %s\n", c.Commit.Message, c.HTMLURL, c.Commit.Author.Name, c.Commit.Author.Date))
			}
			// Remove previous commit section for this tag
			sectionRe := regexp.MustCompile(`(?s)\n*## Commits mentioning ` + tag + `\n.*?(\n## |$)`)
			matches := sectionRe.FindAllStringSubmatch(contentToUpdate, -1)
			for _, match := range matches {
				log.Printf("Deleting previous commit section in %s for tag %s:\n%s", file, tag, match[0])
			}
			contentToUpdate = sectionRe.ReplaceAllString(contentToUpdate, "$1")
			// Append new section
			contentToUpdate += sb.String()
		}
		// Write back only if changed
		if contentToUpdate != content {
			if err := os.WriteFile(file, []byte(contentToUpdate), 0600); err != nil {
				log.Printf("Failed to write to %s: %v", file, err)
			} else {
				fmt.Printf("Updated commit sections in %s\n", file)
			}
		}
	}
}
