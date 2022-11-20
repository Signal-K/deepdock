package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

// getBoardCode returns the three-letter code for a board name
func getBoardCode(boardName string) string {
	if boardName == "Administration" {
		return "SSA"
	}
	if boardName == "Frontend" {
		return "SSF"
	}
	// Default: SSG (for Sprints, General, etc)
	return "SSG"
}

// findHighestTagNumber finds the highest tag number for a given prefix in all boards
func findHighestTagNumber(files []string, prefix string) int {
	highest := 0
	re := regexp.MustCompile(prefix + `-(\d+)`)
	for _, file := range files {
		f, err := os.Open(file)
		if err != nil {
			continue
		}
		scanner := bufio.NewScanner(f)
		for scanner.Scan() {
			matches := re.FindAllStringSubmatch(scanner.Text(), -1)
			for _, m := range matches {
				num, _ := strconv.Atoi(m[1])
				if num > highest {
					highest = num
				}
			}
		}
		f.Close()
	}
	return highest
}

// tagKanbanTasks tags all tasks in a kanban board file
func tagKanbanTasks(filePath, boardName, sprintTag string, files []string) error {
	boardCode := getBoardCode(boardName)
	highest := findHighestTagNumber(files, boardCode)
	tagNum := highest + 1

	input, err := os.ReadFile(filePath)
	if err != nil {
		return err
	}
	lines := strings.Split(string(input), "\n")
	taskRe := regexp.MustCompile(`^- \[.\] .+`)
	prefixRe := regexp.MustCompile(fmt.Sprintf(`%s-\d+`, boardCode))
	for i, line := range lines {
		if taskRe.MatchString(line) {
			// Skip if already tagged with board prefix
			if prefixRe.MatchString(line) {
				continue
			}
			// Add sprint tag if not present
			if !strings.Contains(line, "#"+sprintTag) {
				line += " #" + sprintTag
			}
			// Add board tag
			tag := fmt.Sprintf("#%s-%d", boardCode, tagNum)
			line += " " + tag
			tagNum++
			lines[i] = line
		}
	}
	output := strings.Join(lines, "\n")
	return os.WriteFile(filePath, []byte(output), 0644)
}

// tagAllKanbanBoards tags all kanban boards in the provided list
func tagAllKanbanBoards(boardFiles map[string]string, sprintTag string) {
	var files []string
	for _, path := range boardFiles {
		files = append(files, path)
	}
	for boardName, filePath := range boardFiles {
		err := tagKanbanTasks(filePath, boardName, sprintTag, files)
		if err != nil {
			fmt.Printf("Error tagging %s: %v\n", filePath, err)
		} else {
			fmt.Printf("Tagged tasks in %s\n", filePath)
		}
	}
}

// Example usage
func main() {
	boardFiles := map[string]string{
		"Administration": "content/Boards/Administration.md",
		"Frontend":       "content/Boards/Frontend.md",
		"Kanban":         "content/Media/Kanban.md",
		"SSG-218 Kanban": "content/Media/SSG-218 Kanban.md",
		"SSG-281 Kanban": "content/Sprints/SSG-281 Kanban.md",
	}
	sprintTag := "SSG-281" // Pass this as an argument if needed
	tagAllKanbanBoards(boardFiles, sprintTag)
}
