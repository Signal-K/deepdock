package main

import (
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"html/template"
	"io/fs"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"time"
)

type Project struct {
	Title         string `json:"title"`
	Path          string `json:"path"`
	Parent        string `json:"parent"`
	Color         string `json:"color"`
	Slug          string `json:"slug"`
	ContainerPath string `json:"-"`
}

type Task struct {
	ID          string            `json:"id"`
	Title       string            `json:"title"`
	Status      string            `json:"status"`
	Priority    string            `json:"priority"`
	Labels      []string          `json:"labels"`
	Frontmatter map[string]string `json:"frontmatter,omitempty"`
	Body        string            `json:"body,omitempty"`
	Project     string            `json:"project"`
	ProjectSlug string            `json:"projectSlug"`
	File        string            `json:"file"`
	Path        string            `json:"path"`
	UpdatedAt   string            `json:"updatedAt"`
	ModTime     time.Time         `json:"modTime"`
	Raw         string            `json:"raw,omitempty"`
}

type DashboardData struct {
	Projects []Project `json:"projects"`
	Tasks    []Task    `json:"tasks"`
	Today    []Task    `json:"today"`
	ThisWeek []Task    `json:"thisWeek"`
	AI       []Task    `json:"ai"`
	Human    []Task    `json:"human"`
	Counts   Counts    `json:"counts"`
}

type Counts struct {
	Tasks    int `json:"tasks"`
	Today    int `json:"today"`
	ThisWeek int `json:"thisWeek"`
	AI       int `json:"ai"`
	Human    int `json:"human"`
}

var (
	port          = env("PORT", "3737")
	projectsFile  = env("PROJECTS_FILE", "/config/projects.json")
	hostHome      = env("HOST_HOME", "/Users/scroobz")
	containerHome = env("CONTAINER_HOME", "/userhome")
)

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", handleIndex)
	mux.HandleFunc("/api/dashboard", handleDashboard)
	mux.HandleFunc("/api/projects", handleProjects)
	mux.HandleFunc("/api/projects/", handleProjectAPI)
	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		writeJSON(w, map[string]any{"ok": true, "time": time.Now().Format(time.RFC3339)})
	})

	log.Printf("knowns-dashboard listening on :%s", port)
	log.Printf("projects file : %s", projectsFile)
	log.Printf("host home     : %s", hostHome)
	log.Printf("container home: %s", containerHome)
	log.Fatal(http.ListenAndServe(":"+port, mux))
}

func handleIndex(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := page.Execute(w, nil); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func handleDashboard(w http.ResponseWriter, r *http.Request) {
	data, err := buildDashboard()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	writeJSON(w, data)
}

func handleProjects(w http.ResponseWriter, r *http.Request) {
	projects := loadProjects()
	writeJSON(w, projects)
}

func handleProjectAPI(w http.ResponseWriter, r *http.Request) {
	parts := splitPath(strings.TrimPrefix(r.URL.Path, "/api/projects/"))
	if len(parts) < 2 {
		http.NotFound(w, r)
		return
	}
	project, ok := findProject(parts[0])
	if !ok {
		http.Error(w, "project not found", http.StatusNotFound)
		return
	}

	if parts[1] != "tasks" {
		http.NotFound(w, r)
		return
	}

	if len(parts) == 2 && r.Method == http.MethodGet {
		tasks, err := listProjectTasks(project, false)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		writeJSON(w, tasks)
		return
	}

	if len(parts) == 2 && r.Method == http.MethodPost {
		handleCreateTask(w, r, project)
		return
	}

	if len(parts) == 3 {
		switch r.Method {
		case http.MethodGet:
			handleGetTask(w, r, project, parts[2])
		case http.MethodPut:
			handleSaveTask(w, r, project, parts[2])
		case http.MethodPatch:
			handlePatchTask(w, r, project, parts[2])
		default:
			http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		}
		return
	}

	http.NotFound(w, r)
}

func handleGetTask(w http.ResponseWriter, _ *http.Request, project Project, id string) {
	task, err := readTask(project, id, true)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, os.ErrNotExist) {
			status = http.StatusNotFound
		}
		http.Error(w, err.Error(), status)
		return
	}
	writeJSON(w, task)
}

func handleSaveTask(w http.ResponseWriter, r *http.Request, project Project, id string) {
	var body struct {
		Raw      string            `json:"raw"`
		Fields   map[string]string `json:"fields"`
		Labels   []string          `json:"labels"`
		Body     string            `json:"body"`
		SaveMode string            `json:"saveMode"`
	}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	file, err := taskFileByID(project, id)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, os.ErrNotExist) {
			status = http.StatusNotFound
		}
		http.Error(w, err.Error(), status)
		return
	}
	raw := body.Raw
	if body.SaveMode == "structured" || len(body.Fields) > 0 {
		current, err := parseTaskFile(project, file, true)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		raw = renderStructuredTask(current.Raw, body.Fields, body.Labels, body.Body)
	}
	if !strings.Contains(raw, "\n") {
		http.Error(w, "markdown is empty or invalid", http.StatusBadRequest)
		return
	}
	if err := os.WriteFile(file, []byte(raw), 0o644); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	task, err := readTask(project, id, true)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	writeJSON(w, task)
}

func handlePatchTask(w http.ResponseWriter, r *http.Request, project Project, id string) {
	var body struct {
		Status string `json:"status"`
	}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if body.Status == "" {
		http.Error(w, "status is required", http.StatusBadRequest)
		return
	}
	task, err := readTask(project, id, true)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}
	raw := replaceFrontmatterField(task.Raw, "status", body.Status)
	raw = replaceFrontmatterField(raw, "updatedAt", time.Now().Format(time.RFC3339))
	file, err := taskFileByID(project, id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}
	if err := os.WriteFile(file, []byte(raw), 0o644); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	updated, err := readTask(project, id, true)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	writeJSON(w, updated)
}

func handleCreateTask(w http.ResponseWriter, r *http.Request, project Project) {
	var body struct {
		Title       string   `json:"title"`
		Status      string   `json:"status"`
		Priority    string   `json:"priority"`
		Labels      []string `json:"labels"`
		Description string   `json:"description"`
	}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	body.Title = strings.TrimSpace(body.Title)
	if body.Title == "" {
		http.Error(w, "title is required", http.StatusBadRequest)
		return
	}
	if body.Status == "" {
		body.Status = "todo"
	}
	if body.Priority == "" {
		body.Priority = "medium"
	}
	id := randomID()
	now := time.Now().Format(time.RFC3339)
	raw := renderTaskMarkdown(id, body.Title, body.Status, body.Priority, body.Labels, body.Description, now)
	dir := filepath.Join(project.ContainerPath, ".knowns", "tasks")
	if err := os.MkdirAll(dir, 0o755); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	file := filepath.Join(dir, fmt.Sprintf("task-%s - %s.md", id, slugify(body.Title)))
	if err := os.WriteFile(file, []byte(raw), 0o644); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	task, err := readTask(project, id, true)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusCreated)
	writeJSON(w, task)
}

func buildDashboard() (DashboardData, error) {
	projects := loadProjects()
	var tasks []Task
	for _, project := range projects {
		projectTasks, err := listProjectTasks(project, false)
		if err != nil {
			return DashboardData{}, err
		}
		tasks = append(tasks, projectTasks...)
	}
	sortTasks(tasks)
	today := pickToday(tasks)
	week := pickWeek(tasks)
	ai := pickAI(tasks)
	human := pickHuman(tasks)
	return DashboardData{
		Projects: projects,
		Tasks:    tasks,
		Today:    today,
		ThisWeek: week,
		AI:       ai,
		Human:    human,
		Counts: Counts{
			Tasks: len(tasks), Today: len(today), ThisWeek: len(week), AI: len(ai), Human: len(human),
		},
	}, nil
}

func loadProjects() []Project {
	raw, err := os.ReadFile(projectsFile)
	if err == nil {
		var projects []Project
		if json.Unmarshal(raw, &projects) == nil && len(projects) > 0 {
			return normalizeProjects(projects)
		}
	}
	return normalizeProjects([]Project{
		{Title: "Daily Game", Path: "/Users/scroobz/Navigation/saily", Parent: "Star Sailors", Color: "#7dcfff"},
		{Title: "Experiment 1", Path: "/Users/scroobz/Navigation/Native/planet-hunters-experiment-1", Parent: "Star Sailors", Color: "#f6c177"},
		{Title: "Web", Path: "/Users/scroobz/Navigation/client", Parent: "Star Sailors", Color: "#9ece6a"},
		{Title: "Bumble", Path: "/Users/scroobz/Navigation/bee-garden", Parent: "Star Sailors", Color: "#f7768e"},
		{Title: "Coral", Path: "/Users/scroobz/Navigation/Coral", Parent: "Star Sailors", Color: "#9ece6a"},
		{Title: "Post", Path: "/Users/scroobz/Navigation/quartz", Parent: "", Color: "#bb9af7"},
	})
}

func normalizeProjects(projects []Project) []Project {
	out := make([]Project, 0, len(projects))
	seen := map[string]bool{}
	for _, p := range projects {
		if p.Title == "" || p.Path == "" {
			continue
		}
		if !isStarSailorsProject(p) {
			continue
		}
		p.Slug = slugify(filepath.Base(strings.TrimRight(p.Path, "/")))
		if p.Slug == "" {
			p.Slug = slugify(p.Title)
		}
		if seen[p.Slug] {
			p.Slug = slugify(p.Title)
		}
		seen[p.Slug] = true
		if p.Color == "" {
			p.Color = "#dcd7ba"
		}
		p.ContainerPath = hostToContainer(p.Path)
		out = append(out, p)
	}
	return out
}

func isStarSailorsProject(project Project) bool {
	return strings.EqualFold(strings.TrimSpace(project.Parent), "Star Sailors")
}

func findProject(slug string) (Project, bool) {
	for _, p := range loadProjects() {
		if p.Slug == slug {
			return p, true
		}
	}
	return Project{}, false
}

func listProjectTasks(project Project, includeDone bool) ([]Task, error) {
	dir := filepath.Join(project.ContainerPath, ".knowns", "tasks")
	entries, err := os.ReadDir(dir)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return nil, nil
		}
		return nil, err
	}
	var tasks []Task
	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".md") {
			continue
		}
		file := filepath.Join(dir, entry.Name())
		task, err := parseTaskFile(project, file, false)
		if err != nil {
			continue
		}
		if !includeDone && statusGroup(task.Status) == "done" {
			continue
		}
		tasks = append(tasks, task)
	}
	sortTasks(tasks)
	return tasks, nil
}

func readTask(project Project, id string, includeRaw bool) (Task, error) {
	file, err := taskFileByID(project, id)
	if err != nil {
		return Task{}, err
	}
	return parseTaskFile(project, file, includeRaw)
}

func taskFileByID(project Project, id string) (string, error) {
	dir := filepath.Join(project.ContainerPath, ".knowns", "tasks")
	entries, err := os.ReadDir(dir)
	if err != nil {
		return "", err
	}
	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".md") {
			continue
		}
		if strings.HasPrefix(entry.Name(), "task-"+id+" ") || strings.HasPrefix(entry.Name(), "task-"+id+".") {
			return filepath.Join(dir, entry.Name()), nil
		}
		task, err := parseTaskFile(project, filepath.Join(dir, entry.Name()), false)
		if err == nil && task.ID == id {
			return filepath.Join(dir, entry.Name()), nil
		}
	}
	return "", os.ErrNotExist
}

func parseTaskFile(project Project, file string, includeRaw bool) (Task, error) {
	rawBytes, err := os.ReadFile(file)
	if err != nil {
		return Task{}, err
	}
	raw := string(rawBytes)
	frontmatter, body := splitFrontmatter(raw)
	meta := parseFrontmatter(frontmatter)
	stat, _ := os.Stat(file)
	id := meta["id"]
	if id == "" {
		id = idFromFilename(filepath.Base(file))
	}
	title := meta["title"]
	if title == "" {
		title = firstMarkdownHeading(body)
	}
	if title == "" {
		title = filepath.Base(file)
	}
	task := Task{
		ID:          id,
		Title:       title,
		Status:      defaultString(meta["status"], "todo"),
		Priority:    defaultString(meta["priority"], "medium"),
		Labels:      parseLabels(frontmatter),
		Frontmatter: meta,
		Project:     project.Title,
		ProjectSlug: project.Slug,
		File:        filepath.Base(file),
		Path:        containerToHost(file),
		UpdatedAt:   meta["updatedAt"],
	}
	if stat != nil {
		task.ModTime = stat.ModTime()
	}
	if includeRaw {
		task.Raw = raw
		task.Body = body
	}
	return task, nil
}

func splitFrontmatter(raw string) (string, string) {
	raw = strings.ReplaceAll(raw, "\r\n", "\n")
	if !strings.HasPrefix(raw, "---\n") {
		return "", raw
	}
	rest := strings.TrimPrefix(raw, "---\n")
	idx := strings.Index(rest, "\n---")
	if idx < 0 {
		return "", raw
	}
	fm := rest[:idx]
	body := strings.TrimPrefix(rest[idx+4:], "\n")
	return fm, body
}

func parseFrontmatter(fm string) map[string]string {
	out := map[string]string{}
	lines := strings.Split(fm, "\n")
	for i := 0; i < len(lines); i++ {
		line := strings.TrimSpace(lines[i])
		if line == "" || strings.HasPrefix(line, "-") || !strings.Contains(line, ":") {
			continue
		}
		parts := strings.SplitN(line, ":", 2)
		key := strings.TrimSpace(parts[0])
		value := strings.TrimSpace(parts[1])
		value = strings.Trim(value, `"'`)
		if value == ">-" || value == "|" || value == "|-" {
			var parts []string
			for i+1 < len(lines) && (strings.HasPrefix(lines[i+1], " ") || strings.HasPrefix(lines[i+1], "\t")) {
				i++
				parts = append(parts, strings.TrimSpace(lines[i]))
			}
			value = strings.Join(parts, " ")
		}
		out[key] = value
	}
	return out
}

func parseLabels(fm string) []string {
	lines := strings.Split(fm, "\n")
	var labels []string
	for i := 0; i < len(lines); i++ {
		if strings.TrimSpace(lines[i]) == "labels:" {
			for i+1 < len(lines) && strings.HasPrefix(strings.TrimSpace(lines[i+1]), "- ") {
				i++
				label := strings.TrimSpace(strings.TrimPrefix(strings.TrimSpace(lines[i]), "- "))
				label = strings.Trim(label, `"'`)
				if label != "" {
					labels = append(labels, label)
				}
			}
		}
	}
	return labels
}

func replaceFrontmatterField(raw, key, value string) string {
	fm, body := splitFrontmatter(raw)
	if fm == "" {
		return raw
	}
	lines := strings.Split(fm, "\n")
	replaced := false
	for i, line := range lines {
		if strings.HasPrefix(strings.TrimSpace(line), key+":") {
			lines[i] = key + ": " + quoteIfNeeded(value)
			replaced = true
			break
		}
	}
	if !replaced {
		lines = append(lines, key+": "+quoteIfNeeded(value))
	}
	return "---\n" + strings.Join(lines, "\n") + "\n---\n" + body
}

func renderStructuredTask(raw string, fields map[string]string, labels []string, markdownBody string) string {
	fm, existingBody := splitFrontmatter(raw)
	if fm == "" {
		fm = "id: " + defaultString(fields["id"], randomID())
	}
	if markdownBody == "" {
		markdownBody = existingBody
	}
	fields = cloneStringMap(fields)
	fields["updatedAt"] = time.Now().Format(time.RFC3339)
	lines := rewriteFrontmatterLines(fm, fields, labels)
	return "---\n" + strings.Join(lines, "\n") + "\n---\n" + strings.TrimLeft(markdownBody, "\n")
}

func rewriteFrontmatterLines(fm string, fields map[string]string, labels []string) []string {
	lines := strings.Split(fm, "\n")
	out := make([]string, 0, len(lines)+len(fields)+len(labels)+2)
	seen := map[string]bool{}
	for i := 0; i < len(lines); i++ {
		line := lines[i]
		trimmed := strings.TrimSpace(line)
		if trimmed == "" {
			out = append(out, line)
			continue
		}
		if strings.HasPrefix(trimmed, "labels:") {
			seen["labels"] = true
			for i+1 < len(lines) && isIndentedYAMLLine(lines[i+1]) {
				i++
			}
			if labels != nil {
				out = append(out, renderLabels(labels)...)
			}
			continue
		}
		if !strings.Contains(trimmed, ":") || strings.HasPrefix(trimmed, "-") {
			out = append(out, line)
			continue
		}
		key := strings.TrimSpace(strings.SplitN(trimmed, ":", 2)[0])
		if value, ok := fields[key]; ok {
			out = append(out, key+": "+quoteIfNeeded(value))
			seen[key] = true
			continue
		}
		out = append(out, line)
		seen[key] = true
	}
	for _, key := range preferredFrontmatterOrder() {
		value, ok := fields[key]
		if !ok || seen[key] {
			continue
		}
		out = append(out, key+": "+quoteIfNeeded(value))
		seen[key] = true
	}
	if labels != nil && !seen["labels"] {
		out = append(out, renderLabels(labels)...)
	}
	for key, value := range fields {
		if seen[key] || key == "labels" {
			continue
		}
		out = append(out, key+": "+quoteIfNeeded(value))
	}
	return compactBlankLines(out)
}

func isIndentedYAMLLine(line string) bool {
	trimmed := strings.TrimSpace(line)
	return trimmed == "" || strings.HasPrefix(line, " ") || strings.HasPrefix(line, "\t") || strings.HasPrefix(trimmed, "- ")
}

func renderLabels(labels []string) []string {
	clean := make([]string, 0, len(labels))
	for _, label := range labels {
		label = strings.TrimSpace(label)
		if label != "" {
			clean = append(clean, label)
		}
	}
	if len(clean) == 0 {
		return []string{"labels: []"}
	}
	out := []string{"labels:"}
	for _, label := range clean {
		out = append(out, "  - "+quoteIfNeeded(label))
	}
	return out
}

func preferredFrontmatterOrder() []string {
	return []string{"id", "title", "status", "priority", "assignee", "createdAt", "updatedAt", "timeSpent"}
}

func cloneStringMap(in map[string]string) map[string]string {
	out := map[string]string{}
	for key, value := range in {
		out[key] = value
	}
	return out
}

func compactBlankLines(lines []string) []string {
	out := make([]string, 0, len(lines))
	lastBlank := false
	for _, line := range lines {
		blank := strings.TrimSpace(line) == ""
		if blank && lastBlank {
			continue
		}
		out = append(out, line)
		lastBlank = blank
	}
	return out
}

func renderTaskMarkdown(id, title, status, priority string, labels []string, description, now string) string {
	var b strings.Builder
	b.WriteString("---\n")
	b.WriteString("id: " + id + "\n")
	b.WriteString("title: " + quoteIfNeeded(title) + "\n")
	b.WriteString("status: " + status + "\n")
	b.WriteString("priority: " + priority + "\n")
	if len(labels) > 0 {
		b.WriteString("labels:\n")
		for _, label := range labels {
			b.WriteString("  - " + label + "\n")
		}
	}
	b.WriteString("createdAt: '" + now + "'\n")
	b.WriteString("updatedAt: '" + now + "'\n")
	b.WriteString("timeSpent: 0\n")
	b.WriteString("---\n\n")
	b.WriteString("# " + title + "\n\n")
	b.WriteString("## Description\n\n")
	b.WriteString("<!-- SECTION:DESCRIPTION:BEGIN -->\n")
	b.WriteString(description + "\n")
	b.WriteString("<!-- SECTION:DESCRIPTION:END -->\n\n")
	b.WriteString("## Acceptance Criteria\n\n- [ ] \n")
	return b.String()
}

func pickToday(tasks []Task) []Task {
	tasks = focusOrAll(tasks)
	var out []Task
	for _, task := range tasks {
		if task.Priority == "high" || strings.HasPrefix(task.ID, "pm") || statusGroup(task.Status) == "inprog" {
			out = append(out, task)
		}
		if len(out) >= 8 {
			break
		}
	}
	return out
}

func pickWeek(tasks []Task) []Task {
	if focused := focusTasks(tasks); len(focused) > 0 {
		return focused
	}
	if len(tasks) <= 36 {
		return tasks
	}
	return tasks[:36]
}

func pickAI(tasks []Task) []Task {
	tasks = focusOrAll(tasks)
	keywords := []string{"implement", "ship", "fix", "replace", "finish", "enforce", "verify", "validate", "run", "stabilize", "polish", "add", "wire", "build", "refresh"}
	return pickByKeywords(tasks, keywords, 16)
}

func pickHuman(tasks []Task) []Task {
	tasks = focusOrAll(tasks)
	keywords := []string{"define", "decide", "choose", "sketch", "design", "maintain", "prepare", "reconstruct", "create minimum", "intake", "distribution", "feedback", "scope"}
	return pickByKeywords(tasks, keywords, 16)
}

func focusOrAll(tasks []Task) []Task {
	if focused := focusTasks(tasks); len(focused) > 0 {
		return focused
	}
	return tasks
}

func focusTasks(tasks []Task) []Task {
	var focused []Task
	for _, task := range tasks {
		if isFocusTask(task) {
			focused = append(focused, task)
		}
	}
	return focused
}

func isFocusTask(task Task) bool {
	for _, prefix := range []string{"ssw", "sly", "phx", "cor", "bum", "pm"} {
		if strings.HasPrefix(task.ID, prefix) {
			return true
		}
	}
	if strings.Contains(task.UpdatedAt, "2026-04-20") || strings.Contains(task.UpdatedAt, "2026-04-19") {
		return true
	}
	return false
}

func pickByKeywords(tasks []Task, keywords []string, max int) []Task {
	var out []Task
	for _, task := range tasks {
		text := strings.ToLower(task.Title + " " + strings.Join(task.Labels, " "))
		for _, keyword := range keywords {
			if strings.Contains(text, keyword) {
				out = append(out, task)
				break
			}
		}
		if len(out) >= max {
			break
		}
	}
	return out
}

func sortTasks(tasks []Task) {
	sort.SliceStable(tasks, func(i, j int) bool {
		fi, fj := isFocusTask(tasks[i]), isFocusTask(tasks[j])
		if fi != fj {
			return fi
		}
		ri, rj := statusRank(tasks[i].Status), statusRank(tasks[j].Status)
		if ri != rj {
			return ri < rj
		}
		pi, pj := priorityRank(tasks[i].Priority), priorityRank(tasks[j].Priority)
		if pi != pj {
			return pi < pj
		}
		return tasks[i].ModTime.After(tasks[j].ModTime)
	})
}

func statusRank(status string) int {
	switch statusGroup(status) {
	case "inprog":
		return 0
	case "todo":
		return 1
	case "blocked":
		return 2
	case "review":
		return 3
	case "done":
		return 5
	default:
		return 4
	}
}

func priorityRank(priority string) int {
	switch strings.ToLower(priority) {
	case "urgent", "high":
		return 0
	case "medium":
		return 1
	case "low":
		return 2
	default:
		return 3
	}
}

func statusGroup(status string) string {
	switch strings.ToLower(strings.TrimSpace(status)) {
	case "todo", "open", "backlog":
		return "todo"
	case "in-progress", "in_progress", "doing", "wip":
		return "inprog"
	case "in-review", "in_review", "inreview":
		return "review"
	case "blocked", "on-hold":
		return "blocked"
	case "done", "closed", "completed":
		return "done"
	default:
		return "other"
	}
}

func hostToContainer(p string) string {
	if strings.HasPrefix(p, hostHome) {
		return containerHome + strings.TrimPrefix(p, hostHome)
	}
	return p
}

func containerToHost(p string) string {
	if strings.HasPrefix(p, containerHome) {
		return hostHome + strings.TrimPrefix(p, containerHome)
	}
	return p
}

func splitPath(p string) []string {
	var out []string
	for _, part := range strings.Split(p, "/") {
		if part != "" {
			out = append(out, part)
		}
	}
	return out
}

func writeJSON(w http.ResponseWriter, data any) {
	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(data); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func env(key, fallback string) string {
	value := os.Getenv(key)
	if value == "" {
		return fallback
	}
	return value
}

func defaultString(value, fallback string) string {
	if value == "" {
		return fallback
	}
	return value
}

func firstMarkdownHeading(body string) string {
	for _, line := range strings.Split(body, "\n") {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "# ") {
			return strings.TrimSpace(strings.TrimPrefix(line, "# "))
		}
	}
	return ""
}

func idFromFilename(name string) string {
	re := regexp.MustCompile(`^task-([a-zA-Z0-9_-]+)`)
	match := re.FindStringSubmatch(name)
	if len(match) > 1 {
		return match[1]
	}
	return strings.TrimSuffix(name, filepath.Ext(name))
}

func slugify(s string) string {
	s = strings.ToLower(strings.TrimSpace(s))
	re := regexp.MustCompile(`[^a-z0-9]+`)
	s = re.ReplaceAllString(s, "-")
	s = strings.Trim(s, "-")
	if len(s) > 90 {
		s = s[:90]
	}
	if s == "" {
		return "task"
	}
	return s
}

func randomID() string {
	var b [3]byte
	if _, err := rand.Read(b[:]); err != nil {
		return fmt.Sprintf("%06d", time.Now().UnixNano()%1000000)
	}
	return hex.EncodeToString(b[:])
}

func quoteIfNeeded(value string) string {
	if value == "" {
		return "''"
	}
	if strings.ContainsAny(value, ":#'\"[]{}") {
		return "'" + strings.ReplaceAll(value, "'", "''") + "'"
	}
	return value
}

func walkMarkdown(dir string) []string {
	var out []string
	_ = filepath.WalkDir(dir, func(p string, d fs.DirEntry, err error) error {
		if err != nil || d.IsDir() {
			return nil
		}
		if strings.HasSuffix(d.Name(), ".md") {
			out = append(out, p)
		}
		return nil
	})
	return out
}

var page = template.Must(template.New("page").Parse(`<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Star Sailors Knowns</title>
<style>
:root{color-scheme:dark;--bg:#0b0f14;--panel:#111822;--panel2:#0f151d;--text:#e7edf7;--muted:#94a3b8;--line:#263241;--green:#9ece6a;--blue:#7dcfff;--amber:#f6c177;--red:#f7768e;--purple:#bb9af7}
*{box-sizing:border-box}html,body{height:100%;overflow:hidden}body{margin:0;background:radial-gradient(circle at top left,#172033,#0b0f14 38rem);color:var(--text);font:14px/1.45 ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;letter-spacing:0}
button,input,textarea,select{font:inherit}button{cursor:pointer}
.shell{height:100vh;padding:14px;display:grid;grid-template-rows:auto minmax(0,1fr);gap:14px;overflow:hidden}
.window{border:1px solid var(--line);background:rgba(12,18,26,.92);box-shadow:0 24px 90px rgba(0,0,0,.38);border-radius:8px;overflow:hidden;min-height:0}
.bar{height:28px;border-bottom:1px solid var(--line);display:flex;align-items:center;gap:8px;padding:0 12px;background:#101722}.dot{width:10px;height:10px;border-radius:50%}.red{background:var(--red)}.amber{background:var(--amber)}.green{background:var(--green)}
.hero{padding:12px 16px 10px;display:grid;grid-template-columns:1fr auto;align-items:end;gap:16px}.logo{white-space:pre;font-size:10px;color:#cdd6f4;margin:0}.commands{display:flex;gap:8px;flex-wrap:wrap;justify-content:flex-end}.cmd{border:1px solid var(--line);background:#162231;color:var(--text);border-radius:6px;padding:7px 9px}.cmd:hover{border-color:var(--blue)}
.grid{display:grid;grid-template-columns:244px minmax(360px,1fr) minmax(430px,44vw);min-height:0}
.side{border-right:1px solid var(--line);padding:14px;background:rgba(9,14,20,.7);overflow:hidden}.main{padding:14px;display:grid;grid-template-rows:auto minmax(0,1fr);gap:12px;overflow:hidden;min-width:0}.editor{border-left:1px solid var(--line);background:var(--panel2);display:grid;grid-template-rows:auto minmax(0,1fr) auto;min-width:0;overflow:hidden}
h2,h3{margin:0 0 8px}h2{font-size:13px;color:var(--blue)}h3{font-size:13px;color:#cdd6f4}.muted{color:var(--muted)}.project{width:100%;text-align:left;border:1px solid var(--line);background:#0d141d;color:var(--text);border-radius:6px;padding:9px;margin-bottom:7px}.project.active{border-color:var(--blue);background:#132034}.swatch{display:inline-block;width:9px;height:9px;border-radius:2px;margin-right:7px}.project-sub{color:var(--muted);font-size:11px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-top:2px}
.columns{display:grid;grid-template-columns:1fr 1fr;gap:10px;min-height:0}.card{border:1px solid var(--line);background:rgba(16,24,34,.8);border-radius:8px;padding:10px;min-width:0}.bucket-list{display:grid;gap:7px}.task-section{display:grid;grid-template-rows:auto minmax(0,1fr);min-height:0}.task-scroll{display:grid;gap:8px;overflow:auto;padding-right:4px}
.task{border:1px solid var(--line);background:#0d141d;color:var(--text);text-align:left;border-radius:6px;padding:9px;min-width:0}.task:hover,.task.active{border-color:var(--amber)}.task-title{display:block;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.meta{margin-top:6px;color:var(--muted);font-size:11px;display:flex;gap:6px;flex-wrap:wrap}.pill{border:1px solid var(--line);border-radius:999px;padding:1px 6px}.high{color:var(--red)}.medium{color:var(--amber)}
.editor-head{padding:14px 16px;border-bottom:1px solid var(--line)}.title-input{width:100%;border:0;background:transparent;color:var(--text);font-size:22px;font-weight:700;outline:none}.editor-path{font-size:11px;color:var(--muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-top:5px}
.task-page{display:grid;grid-template-rows:auto minmax(0,1fr);min-height:0}.properties{padding:12px 16px;border-bottom:1px solid var(--line);display:grid;grid-template-columns:1fr 1fr;gap:10px}.field{min-width:0}.field label{display:block;color:var(--muted);font-size:11px;margin-bottom:4px}.field input,.field select{width:100%;border:1px solid var(--line);background:#091018;color:var(--text);border-radius:6px;padding:8px 9px;outline:none}.field input:focus,.field select:focus{border-color:var(--blue)}
.body-wrap{min-height:0;display:grid}.body-editor{width:100%;height:100%;resize:none;border:0;background:#090e14;color:#dce7f7;padding:16px;outline:none;line-height:1.55;overflow:auto}
.editor-actions{border-top:1px solid var(--line);padding:10px 16px;display:flex;gap:9px;align-items:center;min-width:0}.primary{border:1px solid var(--green);background:#142615;color:var(--green);border-radius:6px;padding:8px 12px}.danger{border:1px solid var(--red);background:#281419;color:var(--red);border-radius:6px;padding:8px 12px}.status{color:var(--muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.search{width:100%;border:1px solid var(--line);background:#091018;color:var(--text);border-radius:6px;padding:8px 9px;margin:0 0 10px;outline:none}.empty{color:var(--muted);padding:10px;border:1px dashed var(--line);border-radius:6px}
@media(max-width:1180px){html,body{overflow:auto}.shell{height:auto;overflow:visible}.grid{grid-template-columns:1fr}.side,.editor{border:0}.editor{min-height:680px}.columns{grid-template-columns:1fr}.logo{font-size:8px}.hero{grid-template-columns:1fr}.commands{justify-content:flex-start}}
</style>
</head>
<body>
<div class="shell">
  <section class="window">
    <div class="bar"><span class="dot red"></span><span class="dot amber"></span><span class="dot green"></span></div>
    <div class="hero">
<pre class="logo">  ____  ____   _____ ___ ____ ___    _    _   _
 / __ )/ __ \ / ___// _ \_  //   |  / |  / | / /
/ __  / / / / \__ \/ // // / / /| | /  | /  |/ /
/ /_/ / /_/ / ___/ / // // /_/ ___ |/ /| |/ /|  /
\____/\____/ /____/____/___/_/  |_/_/ |_/_/ |_/</pre>
      <div class="commands">
        <button class="cmd" onclick="refresh()">refresh</button>
        <button class="cmd" onclick="showBucket('today')">today</button>
        <button class="cmd" onclick="showBucket('week')">this week</button>
        <button class="cmd" onclick="showBucket('ai')">AI work</button>
        <button class="cmd" onclick="showBucket('human')">my work</button>
      </div>
    </div>
  </section>

  <section class="window grid">
    <aside class="side">
      <h2>Star Sailors</h2>
      <input class="search" id="search" placeholder="Search tasks" oninput="renderTasks()">
      <div id="projects"></div>
    </aside>
    <main class="main">
      <div class="columns">
        <section class="card"><h2>What do I do today?</h2><div id="today" class="bucket-list"></div></section>
        <section class="card"><h2>What is this week?</h2><div id="week" class="bucket-list"></div></section>
        <section class="card"><h2>AI should do</h2><div id="ai" class="bucket-list"></div></section>
        <section class="card"><h2>I should do</h2><div id="human" class="bucket-list"></div></section>
      </div>
      <section class="card task-section"><h2 id="taskHeading">All active tasks</h2><div id="tasks" class="task-scroll"></div></section>
    </main>
    <aside class="editor">
      <div class="editor-head">
        <input class="title-input" id="field-title" placeholder="Select a task" oninput="markDirty()">
        <div class="editor-path" id="editorPath">Knowns Markdown opens here.</div>
      </div>
      <div class="task-page">
        <div class="properties">
          <div class="field"><label>Status</label><select id="field-status" onchange="markDirty()"><option>todo</option><option>in-progress</option><option>blocked</option><option>in-review</option><option>done</option></select></div>
          <div class="field"><label>Priority</label><select id="field-priority" onchange="markDirty()"><option>high</option><option>medium</option><option>low</option></select></div>
          <div class="field"><label>Labels</label><input id="field-labels" placeholder="comma separated" oninput="markDirty()"></div>
          <div class="field"><label>Assignee</label><input id="field-assignee" placeholder="me, agent, codex" oninput="markDirty()"></div>
          <div class="field"><label>ID</label><input id="field-id" disabled></div>
          <div class="field"><label>Updated</label><input id="field-updatedAt" disabled></div>
        </div>
        <div class="body-wrap"><textarea class="body-editor" id="body" spellcheck="false" placeholder="Task notes, plan, acceptance criteria, and agent handoff live here." oninput="markDirty()"></textarea></div>
      </div>
      <div class="editor-actions">
        <button class="primary" onclick="saveTask()">save task</button>
        <button class="danger" onclick="quickStatus('done')">mark done</button>
        <button class="cmd" onclick="quickStatus('in-progress')">in progress</button>
        <span class="status" id="saveStatus"></span>
      </div>
    </aside>
  </section>
</div>
<script>
let data={projects:[],tasks:[],today:[],thisWeek:[],ai:[],human:[]};
let selectedProject='all';
let selectedTask=null;
let bucket='all';
let dirty=false;

async function refresh(){
  const res=await fetch('/api/dashboard');
  data=await res.json();
  renderProjects(); renderBuckets(); renderTasks();
}
function renderProjects(){
  const el=document.getElementById('projects');
  el.innerHTML='';
  el.append(projectButton({slug:'all',title:'All Star Sailors',color:'#7dcfff',parent:String(data.projects.length)+' projects'}));
  data.projects.forEach(function(p){el.append(projectButton(p));});
}
function projectButton(p){
  const b=document.createElement('button');
  b.className='project'+(selectedProject===p.slug?' active':'');
  b.innerHTML='<span class="swatch" style="background:'+p.color+'"></span>'+escapeHtml(p.title)+'<div class="project-sub">'+escapeHtml(p.parent||p.path||'')+'</div>';
  b.onclick=function(){selectedProject=p.slug; bucket='all'; renderProjects(); renderTasks();};
  return b;
}
function renderBuckets(){
  renderList('today', data.today, 3);
  renderList('week', data.thisWeek, 3);
  renderList('ai', data.ai, 3);
  renderList('human', data.human, 3);
}
function showBucket(name){ bucket=name; selectedProject='all'; renderProjects(); renderTasks(); }
function sourceTasks(){
  if(bucket==='today') return data.today;
  if(bucket==='week') return data.thisWeek;
  if(bucket==='ai') return data.ai;
  if(bucket==='human') return data.human;
  return data.tasks;
}
function renderTasks(){
  const query=document.getElementById('search').value.toLowerCase();
  const heading={all:'All active tasks',today:'Today',week:'This week',ai:'AI should do',human:'I should do'}[bucket]||'Tasks';
  document.getElementById('taskHeading').textContent=heading;
  let tasks=sourceTasks();
  if(selectedProject!=='all') tasks=tasks.filter(function(t){return t.projectSlug===selectedProject;});
  if(query) tasks=tasks.filter(function(t){return (t.title+' '+t.project+' '+t.status+' '+t.priority+' '+(t.labels||[]).join(' ')).toLowerCase().includes(query);});
  renderList('tasks', tasks, 0);
}
function renderList(id,tasks,limit){
  const el=document.getElementById(id);
  el.innerHTML='';
  if(!tasks||!tasks.length){ el.innerHTML='<div class="empty">No tasks here.</div>'; return; }
  let shown=limit&&tasks.length>limit?tasks.slice(0,limit):tasks;
  shown.forEach(function(t){el.append(taskButton(t));});
  if(limit&&tasks.length>limit){
    const more=document.createElement('button');
    more.className='task';
    more.textContent='+'+(tasks.length-limit)+' more';
    more.onclick=function(){showBucket(id==='week'?'week':id);};
    el.append(more);
  }
}
function taskButton(t){
  const b=document.createElement('button');
  b.className='task'+(selectedTask&&selectedTask.id===t.id&&selectedTask.projectSlug===t.projectSlug?' active':'');
  b.innerHTML='<span class="task-title">'+escapeHtml(t.title)+'</span><div class="meta"><span class="pill">'+escapeHtml(t.project)+'</span><span class="pill">'+escapeHtml(t.status)+'</span><span class="pill '+escapeHtml(t.priority)+'">'+escapeHtml(t.priority)+'</span></div>';
  b.onclick=function(){openTask(t.projectSlug,t.id);};
  return b;
}
async function openTask(project,id){
  if(dirty&&!confirm('Discard unsaved task edits?')) return;
  const res=await fetch('/api/projects/'+project+'/tasks/'+id);
  if(!res.ok){ alert(await res.text()); return; }
  selectedTask=await res.json();
  fillEditor(selectedTask);
  dirty=false;
  document.getElementById('saveStatus').textContent='';
  renderBuckets(); renderTasks();
}
function fillEditor(task){
  const fm=task.frontmatter||{};
  document.getElementById('field-title').value=task.title||'';
  document.getElementById('field-status').value=task.status||'todo';
  document.getElementById('field-priority').value=task.priority||'medium';
  document.getElementById('field-labels').value=(task.labels||[]).join(', ');
  document.getElementById('field-assignee').value=fm.assignee||'';
  document.getElementById('field-id').value=task.id||'';
  document.getElementById('field-updatedAt').value=task.updatedAt||'';
  document.getElementById('editorPath').textContent=task.path||'';
  document.getElementById('body').value=task.body||'';
}
function collectFields(){
  const fm=Object.assign({}, selectedTask.frontmatter||{});
  fm.id=selectedTask.id;
  fm.title=document.getElementById('field-title').value.trim();
  fm.status=document.getElementById('field-status').value;
  fm.priority=document.getElementById('field-priority').value;
  const assignee=document.getElementById('field-assignee').value.trim();
  fm.assignee=assignee;
  return fm;
}
function collectLabels(){
  return document.getElementById('field-labels').value.split(',').map(function(v){return v.trim();}).filter(Boolean);
}
async function saveTask(){
  if(!selectedTask) return;
  const payload={saveMode:'structured',fields:collectFields(),labels:collectLabels(),body:document.getElementById('body').value};
  const res=await fetch('/api/projects/'+selectedTask.projectSlug+'/tasks/'+selectedTask.id,{method:'PUT',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)});
  document.getElementById('saveStatus').textContent=res.ok?'saved':'save failed';
  if(res.ok){ selectedTask=await res.json(); dirty=false; await refresh(); await openTask(selectedTask.projectSlug, selectedTask.id); }
}
async function quickStatus(status){
  if(!selectedTask) return;
  document.getElementById('field-status').value=status;
  await saveTask();
}
function markDirty(){ dirty=true; document.getElementById('saveStatus').textContent='unsaved'; }
function escapeHtml(v){return String(v||'').replace(/[&<>"']/g,function(s){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[s];});}
refresh();
</script>
</body>
</html>`))
