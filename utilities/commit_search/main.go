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
	"path/filepath"
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
func fetchCommits(repo string, branch string, tag string) ([]Commit, error) {
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
       var result []Commit
       for _, c := range commits {
	       if strings.Contains(c.Commit.Message, tag) {
		       result = append(result, c)
	       }
       }
       return result, nil
}

func main() {
       // Define repos and branches to search
       repos := []string{
	       "signal-k/client",
	       "signal-k/deepdock",
	       "signal-k/manuscript",
	       "signal-k/sytizen",
       }
       branches := []string{"main", "master", "dev", "develop"} // common branch names

       // Find all board files
       boardDir := "content/Boards"
       files, err := filepath.Glob(filepath.Join(boardDir, "*.md"))
       if err != nil {
	       log.Fatalf("Failed to list board files: %v", err)
       }

       // Map: tag -> files with tag in title
       tagToFiles := make(map[string][]string)
       tagRe := regexp.MustCompile(`[A-Z]{3}-\d+`)
       for _, file := range files {
	       base := filepath.Base(file)
	       tags := tagRe.FindAllString(base, -1)
	       for _, tag := range tags {
		       tagToFiles[tag] = append(tagToFiles[tag], file)
	       }
       }

       // For each tag, search all repos/branches for commits
       for tag, mdFiles := range tagToFiles {
	       var allCommits []Commit
	       for _, repo := range repos {
		       for _, branch := range branches {
			       commits, err := fetchCommits(repo, branch, tag)
			       if err == nil && len(commits) > 0 {
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
	       // Append to each file with tag in title
	       for _, mdFile := range mdFiles {
		       f, err := os.OpenFile(mdFile, os.O_APPEND|os.O_WRONLY, 0600)
		       if err != nil {
			       log.Printf("Failed to open %s: %v", mdFile, err)
			       continue
		       }
		       if _, err := f.WriteString(sb.String()); err != nil {
			       log.Printf("Failed to write to %s: %v", mdFile, err)
		       }
		       f.Close()
		       fmt.Printf("Appended commits for %s to %s\n", tag, mdFile)
	       }
       }
}
