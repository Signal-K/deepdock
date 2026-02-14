if exists("g:loaded_quartz_dashboard")
  finish
endif
let g:loaded_quartz_dashboard = 1

if !exists("g:quartz_projects")
  let g:quartz_projects = [
        \ {'title': 'Daily Game', 'path': '/Users/scroobz/Navigation/saily'},
        \ {'title': 'Experiment 1', 'path': '/Users/scroobz/Navigation/Native/planet-hunters-experiment-1'},
        \ {'title': 'Web', 'path': '/Users/scroobz/Navigation/client'},
        \ {'title': 'Bumble', 'path': '/Users/scroobz/Navigation/bee-garden'},
        \ ]
endif

if !exists("g:quartz_selected_project")
  let g:quartz_selected_project = 1
endif

function! s:projects() abort
  return g:quartz_projects
endfunction

function! s:selected_index() abort
  let l:idx = g:quartz_selected_project
  if l:idx < 1 || l:idx > len(s:projects())
    let l:idx = 1
    let g:quartz_selected_project = 1
  endif
  return l:idx
endfunction

function! s:selected_project() abort
  return s:projects()[s:selected_index() - 1]
endfunction

function! s:set_project(idx) abort
  if a:idx >= 1 && a:idx <= len(s:projects())
    let g:quartz_selected_project = a:idx
  endif
  call s:render_dashboard()
endfunction

function! s:recent_files(limit) abort
  let l:out = []
  for l:f in v:oldfiles
    if filereadable(l:f) && index(l:out, l:f) < 0
      call add(l:out, l:f)
    endif
    if len(l:out) >= a:limit
      break
    endif
  endfor
  return l:out
endfunction

function! s:fit(text, maxw) abort
  let l:t = substitute(a:text, '\\n', ' ', 'g')
  if strdisplaywidth(l:t) <= a:maxw
    return l:t
  endif
  return strcharpart(l:t, 0, a:maxw - 1) . '…'
endfunction

function! s:pad(text, width) abort
  let l:t = a:text
  let l:w = strdisplaywidth(l:t)
  if l:w >= a:width
    return s:fit(l:t, a:width)
  endif
  return l:t . repeat(' ', a:width - l:w)
endfunction

function! s:center_line(line) abort
  let l:w = winwidth(0)
  let l:t = a:line
  let l:tw = strdisplaywidth(l:t)
  if l:tw >= l:w - 1
    return l:t
  endif
  let l:pad = float2nr((l:w - l:tw) / 2.0)
  return repeat(' ', max([0, l:pad])) . l:t
endfunction

function! s:center_lines(lines) abort
  let l:out = []
  for l in a:lines
    call add(l:out, s:center_line(l))
  endfor
  return l:out
endfunction

function! s:content_width() abort
  let l:ww = winwidth(0)
  let l:target = float2nr(l:ww * 0.72)
  let l:max_allowed = l:ww - 8
  return max([96, min([l:target, l:max_allowed, 220])])
endfunction

function! s:panel_wrap(lines, width) abort
  let l:maxw = max([a:width, 96])
  let l:out = []
  call add(l:out, '╭' . repeat('─', l:maxw + 2) . '╮')
  call add(l:out, '│ ' . s:pad('●  ●  ●', l:maxw) . ' │')
  call add(l:out, '├' . repeat('─', l:maxw + 2) . '┤')
  for l in a:lines
    call add(l:out, '│ ' . s:pad(s:fit(l, l:maxw), l:maxw) . ' │')
  endfor
  call add(l:out, '╰' . repeat('─', l:maxw + 2) . '╯')
  return l:out
endfunction

function! s:center_panel(lines) abort
  return repeat([''], s:panel_top(len(a:lines))) + a:lines
endfunction

function! s:panel_top(lines_len) abort
  let l:vh = winheight(0) - 2
  let l:top = float2nr((l:vh - a:lines_len) / 3.0)
  if l:top < 0
    let l:top = 0
  endif
  return l:top
endfunction

function! s:url_encode(str) abort
  let l:s = a:str
  let l:s = substitute(l:s, '%', '%25', 'g')
  let l:s = substitute(l:s, ' ', '%20', 'g')
  let l:s = substitute(l:s, '#', '%23', 'g')
  let l:s = substitute(l:s, '&', '%26', 'g')
  let l:s = substitute(l:s, '?', '%3F', 'g')
  let l:s = substitute(l:s, '+', '%2B', 'g')
  let l:s = substitute(l:s, ':', '%3A', 'g')
  let l:s = substitute(l:s, '@', '%40', 'g')
  let l:s = substitute(l:s, '=', '%3D', 'g')
  let l:s = substitute(l:s, '/', '%2F', 'g')
  return l:s
endfunction

function! s:open_obsidian(relpath) abort
  let l:vault = get(g:, 'obsidian_vault_name', 'quartz')
  let l:url = 'obsidian://open?vault=' . s:url_encode(l:vault) . '&file=' . s:url_encode(a:relpath)
  if executable('open')
    call system('open ' . shellescape(l:url))
  elseif executable('xdg-open')
    call system('xdg-open ' . shellescape(l:url))
  else
    echohl ErrorMsg | echom 'No open/xdg-open found for Obsidian URI.' | echohl None
  endif
endfunction

function! s:vault_root() abort
  if exists('g:obsidian_vault_root') && isdirectory(g:obsidian_vault_root)
    return fnamemodify(g:obsidian_vault_root, ':p')
  endif
  let l:default = expand('~/Navigation/quartz')
  if isdirectory(l:default)
    return fnamemodify(l:default, ':p')
  endif
  return fnamemodify(getcwd(), ':p')
endfunction

function! s:vault_files(root) abort
  if executable('rg')
    let l:files = systemlist('rg --files ' . shellescape(a:root))
    if v:shell_error == 0
      return l:files
    endif
  endif
  let l:all = globpath(a:root, '**/*', 1, 1)
  let l:out = []
  for l:p in l:all
    if filereadable(l:p) && l:p !~# '/\\.git/' && l:p !~# '/node_modules/'
      call add(l:out, fnamemodify(l:p, ':p'))
    endif
  endfor
  return l:out
endfunction

function! s:search_vault_file() abort
  let l:root = s:vault_root()
  let l:query = input('Filename search: ')
  if empty(l:query)
    return
  endif

  let l:files = s:vault_files(l:root)
  if empty(l:files)
    echohl ErrorMsg | echom 'No readable files found in vault: ' . l:root | echohl None
    return
  endif

  let l:q = tolower(substitute(l:query, '\\.[^./\\]\\+$', '', ''))
  let l:ranked = []
  for l:f in l:files
    let l:rel = substitute(l:f, '^' . escape(l:root, '\\') . '/', '', '')
    let l:base = fnamemodify(l:rel, ':t')
    let l:stem = substitute(tolower(l:base), '\\.[^./\\]\\+$', '', '')
    let l:path_l = tolower(l:rel)
    let l:score = 0
    if l:stem ==# l:q
      let l:score = 400
    elseif l:stem =~# '^' . escape(l:q, '\\')
      let l:score = 300
    elseif stridx(l:stem, l:q) >= 0
      let l:score = 200
    elseif stridx(l:path_l, l:q) >= 0
      let l:score = 100
    endif
    if l:score > 0
      call add(l:ranked, {'score': l:score, 'rel': l:rel, 'abs': l:f})
    endif
  endfor

  if empty(l:ranked)
    echom 'No files found for filename: ' . l:query
    return
  endif

  call sort(l:ranked, {a, b -> b.score - a.score})
  let l:max = min([40, len(l:ranked)])
  let l:menu = ['Select file (0 cancels):']
  for l:i in range(0, l:max - 1)
    call add(l:menu, printf('%2d. %s', l:i + 1, l:ranked[l:i].rel))
  endfor
  let l:pick = inputlist(l:menu)
  if l:pick <= 0 || l:pick > l:max
    return
  endif

  let l:rel = l:ranked[l:pick - 1].rel
  let l:abs = l:ranked[l:pick - 1].abs
  let l:where = inputlist([
        \ 'Open target:',
        \ '1. Vim',
        \ '2. Obsidian',
        \ '3. Both',
        \ '0. Cancel'
        \ ])

  if l:where == 1
    execute 'edit ' . fnameescape(l:abs)
  elseif l:where == 2
    call s:open_obsidian(l:rel)
  elseif l:where == 3
    execute 'edit ' . fnameescape(l:abs)
    call s:open_obsidian(l:rel)
  endif
endfunction

function! s:extract_task_meta(file) abort
  let l:lines = readfile(a:file, '', 60)
  if empty(l:lines) || l:lines[0] !=# '---'
    return {}
  endif

  let l:title = ''
  let l:status = ''
  for l:i in range(1, len(l:lines) - 1)
    let l:line = l:lines[l:i]
    if l:line ==# '---'
      break
    endif
    if l:line =~# '^title:\s*'
      let l:title = substitute(l:line, '^title:\s*', '', '')
      let l:title = substitute(l:title, "^['\"]\\|['\"]$", '', 'g')
    elseif l:line =~# '^status:\s*'
      let l:status = tolower(substitute(l:line, '^status:\s*', '', ''))
    endif
  endfor

  if empty(l:title)
    return {}
  endif
  return {'title': l:title, 'status': l:status, 'file': a:file}
endfunction

function! s:project_tasks(project) abort
  let l:dir = a:project.path . '/.knowns/tasks'
  let l:todo = []
  let l:inprog = []
  let l:review = []
  if !isdirectory(l:dir)
    return {'todo': l:todo, 'inprog': l:inprog, 'review': l:review}
  endif

  let l:files = globpath(l:dir, '*.md', 1, 1)
  call sort(l:files, {a, b -> getftime(b) - getftime(a)})

  for l:f in l:files
    let l:m = s:extract_task_meta(l:f)
    if empty(l:m)
      continue
    endif
    let l:s = l:m.status
    if l:s ==# 'done'
      continue
    endif

    if index(['todo', 'backlog', 'open'], l:s) >= 0
      if len(l:todo) < 3 | call add(l:todo, l:m) | endif
    elseif index(['in-progress', 'doing', 'wip'], l:s) >= 0
      if len(l:inprog) < 3 | call add(l:inprog, l:m) | endif
    elseif index(['in-review', 'in_review', 'inreview', 'blocked', 'on-hold'], l:s) >= 0
      if len(l:review) < 3 | call add(l:review, l:m) | endif
    endif

    if len(l:todo) >= 3 && len(l:inprog) >= 3 && len(l:review) >= 3
      break
    endif
  endfor

  return {'todo': l:todo, 'inprog': l:inprog, 'review': l:review}
endfunction

function! s:kanban_board_lines(tasks, total_w) abort
  let l:avail = a:total_w - 4
  let l:w1 = float2nr(l:avail / 3.0)
  let l:w2 = float2nr(l:avail / 3.0)
  let l:w3 = l:avail - l:w1 - l:w2
  if l:w1 < 22 || l:w2 < 22 || l:w3 < 22
    let l:w1 = 22
    let l:w2 = 22
    let l:w3 = max([22, l:avail - 44])
  endif
  let l:out = []
  let l:cells = []

  let l:top = '┌' . repeat('─', l:w1) . '┬' . repeat('─', l:w2) . '┬' . repeat('─', l:w3) . '┐'
  let l:mid = '├' . repeat('─', l:w1) . '┼' . repeat('─', l:w2) . '┼' . repeat('─', l:w3) . '┤'
  let l:bot = '└' . repeat('─', l:w1) . '┴' . repeat('─', l:w2) . '┴' . repeat('─', l:w3) . '┘'

  call add(l:out, l:top)
  call add(l:out, '│' . s:pad(' 󰄵  TODO', l:w1) . '│' . s:pad(' 󰔟  IN PROGRESS', l:w2) . '│' . s:pad(' 󱋭  REVIEW/BLOCKED', l:w3) . '│')
  call add(l:out, l:mid)

  let l:rows = max([3, len(a:tasks.todo), len(a:tasks.inprog), len(a:tasks.review)])
  for l:i in range(0, l:rows - 1)
    let l:t1 = (l:i < len(a:tasks.todo)) ? a:tasks.todo[l:i] : {}
    let l:t2 = (l:i < len(a:tasks.inprog)) ? a:tasks.inprog[l:i] : {}
    let l:t3 = (l:i < len(a:tasks.review)) ? a:tasks.review[l:i] : {}
    let l:c1 = !empty(l:t1) ? ('󰄵 ' . s:fit(l:t1.title, l:w1 - 2)) : ''
    let l:c2 = !empty(l:t2) ? ('󰔟 ' . s:fit(l:t2.title, l:w2 - 2)) : ''
    let l:c3 = !empty(l:t3) ? ('󱋭 ' . s:fit(l:t3.title, l:w3 - 2)) : ''
    if !empty(l:t1) | call add(l:cells, {'row': l:i, 'col': 1, 'task': l:t1}) | endif
    if !empty(l:t2) | call add(l:cells, {'row': l:i, 'col': 2, 'task': l:t2}) | endif
    if !empty(l:t3) | call add(l:cells, {'row': l:i, 'col': 3, 'task': l:t3}) | endif
    call add(l:out, '│' . s:pad(l:c1, l:w1) . '│' . s:pad(l:c2, l:w2) . '│' . s:pad(l:c3, l:w3) . '│')
  endfor

  call add(l:out, l:bot)
  return {'lines': l:out, 'cells': l:cells, 'w1': l:w1, 'w2': l:w2, 'w3': l:w3}
endfunction

function! s:running_knowns() abort
  let l:up = systemlist('curl -sS -m 1 http://localhost:6420/ >/dev/null 2>&1 && echo up || echo down')
  if empty(l:up) || l:up[0] !=# 'up'
    return {'running': 0, 'project': '', 'cwd': ''}
  endif

  let l:pid_lines = systemlist('lsof -nP -iTCP:6420 -sTCP:LISTEN -Fp 2>/dev/null')
  let l:pid = ''
  for l:ln in l:pid_lines
    if l:ln =~# '^p'
      let l:pid = substitute(l:ln, '^p', '', '')
      break
    endif
  endfor
  if empty(l:pid)
    return {'running': 1, 'project': 'unknown', 'cwd': ''}
  endif

  let l:cwd_lines = systemlist('lsof -a -p ' . l:pid . ' -d cwd -Fn 2>/dev/null')
  let l:cwd = ''
  for l:ln in l:cwd_lines
    if l:ln =~# '^n/'
      let l:cwd = substitute(l:ln, '^n', '', '')
      break
    endif
  endfor
  if empty(l:cwd)
    return {'running': 1, 'project': 'unknown', 'cwd': ''}
  endif

  for l:p in s:projects()
    if fnamemodify(l:p.path, ':p') ==# fnamemodify(l:cwd, ':p')
      return {'running': 1, 'project': l:p.title, 'cwd': l:cwd, 'pid': l:pid}
    endif
  endfor
  return {'running': 1, 'project': fnamemodify(l:cwd, ':t'), 'cwd': l:cwd, 'pid': l:pid}
endfunction

function! s:kanban_status_line() abort
  let l:state = s:running_knowns()
  if l:state.running
    return '󰐊 Kanban: ' . l:state.project . ' running'
  endif
  return '󰐊 Kanban: stopped'
endfunction

function! s:run_project_bg(cmd) abort
  let l:p = s:selected_project()
  let l:safe = 'cd ' . shellescape(l:p.path) . ' && ' . a:cmd . ' >/tmp/quartz-dashboard-cmd.log 2>&1 &'
  call system(l:safe)
  echom 'Started: ' . a:cmd . ' [' . l:p.title . ']'
endfunction

function! s:knowns_listener_pids() abort
  let l:pid_lines = systemlist('lsof -nP -iTCP:6420 -sTCP:LISTEN -Fp 2>/dev/null')
  let l:pids = []
  for l:ln in l:pid_lines
    if l:ln =~# '^p\d\+$'
      call add(l:pids, substitute(l:ln, '^p', '', ''))
    endif
  endfor
  return uniq(sort(l:pids))
endfunction

function! s:pid_cwd(pid) abort
  let l:cwd_lines = systemlist('lsof -a -p ' . a:pid . ' -d cwd -Fn 2>/dev/null')
  for l:ln in l:cwd_lines
    if l:ln =~# '^n/'
      return substitute(l:ln, '^n', '', '')
    endif
  endfor
  return ''
endfunction

function! s:stop_knowns_pid(pid) abort
  call system('kill ' . a:pid . ' >/dev/null 2>&1')
  sleep 200m
  let l:alive = systemlist('kill -0 ' . a:pid . ' >/dev/null 2>&1 && echo up || echo down')
  if !empty(l:alive) && l:alive[0] ==# 'up'
    call system('kill -9 ' . a:pid . ' >/dev/null 2>&1')
  endif
endfunction

function! s:stop_other_knowns() abort
  let l:selected = fnamemodify(s:selected_project().path, ':p')
  for l:pid in s:knowns_listener_pids()
    let l:cwd_raw = s:pid_cwd(l:pid)
    let l:cwd = empty(l:cwd_raw) ? '' : fnamemodify(l:cwd_raw, ':p')
    if empty(l:cwd) || l:cwd !=# l:selected
      call s:stop_knowns_pid(l:pid)
    endif
  endfor
endfunction

function! s:run_knowns_browser_safe() abort
  call s:stop_other_knowns()
  call s:run_project_bg('knowns browser')
  sleep 300m
  call s:render_dashboard()
endfunction

function! s:cursor_board_col(line_text, cursor_col) abort
  let l:before = strpart(a:line_text, 0, a:cursor_col - 1)
  let l:sep_count = len(split(l:before, '│')) - 1
  if l:sep_count >= 1 && l:sep_count <= 3
    return l:sep_count
  endif
  return 0
endfunction

function! s:next_task_point(backward) abort
  if !exists('b:quartz_task_points') || empty(b:quartz_task_points)
    return
  endif
  let l:cur_l = line('.')
  let l:cur_c = col('.')
  let l:best = -1

  if a:backward
    for l:i in range(len(b:quartz_task_points) - 1, 0, -1)
      let l:p = b:quartz_task_points[l:i]
      if l:p.line < l:cur_l || (l:p.line == l:cur_l && l:p.col < l:cur_c)
        let l:best = l:i
        break
      endif
    endfor
    if l:best < 0
      let l:best = len(b:quartz_task_points) - 1
    endif
  else
    for l:i in range(0, len(b:quartz_task_points) - 1)
      let l:p = b:quartz_task_points[l:i]
      if l:p.line > l:cur_l || (l:p.line == l:cur_l && l:p.col > l:cur_c)
        let l:best = l:i
        break
      endif
    endfor
    if l:best < 0
      let l:best = 0
    endif
  endif

  let l:target = b:quartz_task_points[l:best]
  call cursor(l:target.line, l:target.col)
endfunction

function! s:open_task_in_code(task_file) abort
  if empty(a:task_file)
    return
  endif
  call s:run_project_bg('code -r .')
  call s:run_project_bg('code -r ' . shellescape(a:task_file))
  echom 'Opened task: ' . fnamemodify(a:task_file, ':t')
endfunction

function! s:open_task_under_cursor() abort
  if !exists('b:quartz_task_rows') || empty(b:quartz_task_rows)
    return
  endif
  let l:ln = line('.')
  if !has_key(b:quartz_task_rows, l:ln)
    return
  endif

  let l:row = b:quartz_task_rows[l:ln]
  let l:board_col = s:cursor_board_col(getline('.'), col('.'))
  if l:board_col > 0 && has_key(l:row, l:board_col)
    call s:open_task_in_code(l:row[l:board_col].file)
    return
  endif

  for l:c in [1, 2, 3]
    if has_key(l:row, l:c)
      call s:open_task_in_code(l:row[l:c].file)
      return
    endif
  endfor
endfunction

function! s:random_id(len) abort
  let l:chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
  let l:mod = strlen(l:chars)
  let l:seed = localtime()
  let l:out = ''
  for l:i in range(1, a:len)
    let l:seed = (l:seed * 1103515245 + 12345) % 2147483647
    let l:idx = l:seed % l:mod
    let l:out .= strcharpart(l:chars, l:idx, 1)
  endfor
  return l:out
endfunction

function! s:ensure_unique_task_path(tasks_dir, task_id) abort
  let l:id = a:task_id
  let l:path = a:tasks_dir . '/' . l:id . '.md'
  while filereadable(l:path)
    let l:id = s:random_id(6)
    let l:path = a:tasks_dir . '/' . l:id . '.md'
  endwhile
  return {'id': l:id, 'path': l:path}
endfunction

function! s:prompt_choice(prompt, options, default_idx) abort
  " options must be a list of display labels; returns index (1-based) or 0 when cancelled
  let l:parts = []
  for l:i in range(1, len(a:options))
    call add(l:parts, printf('%d=%s', l:i, a:options[l:i - 1]))
  endfor
  let l:msg = a:prompt . ' [' . join(l:parts, ', ') . ', 0=cancel] (default ' . a:default_idx . '): '
  redraw
  let l:raw = trim(input(l:msg))
  if empty(l:raw)
    return a:default_idx
  endif
  if l:raw !~# '^\d\+$'
    return 0
  endif
  let l:pick = str2nr(l:raw)
  if l:pick < 0 || l:pick > len(a:options)
    return 0
  endif
  return l:pick
endfunction

function! s:create_knowns_task() abort
  let l:project_labels = map(copy(s:projects()), {_, p -> p.title})
  let l:pick = s:prompt_choice('Project', l:project_labels, s:selected_index())
  if l:pick <= 0 || l:pick > len(s:projects())
    call s:render_dashboard()
    return
  endif

  let g:quartz_selected_project = l:pick
  let l:project = s:selected_project()

  redraw
  let l:title = input('Task title: ')
  if empty(l:title)
    call s:render_dashboard()
    return
  endif

  let l:status_pick = s:prompt_choice('Status', ['todo', 'in-progress', 'in-review'], 1)
  if l:status_pick == 0
    call s:render_dashboard()
    return
  endif
  let l:status = (l:status_pick == 2) ? 'in-progress' : (l:status_pick == 3 ? 'in-review' : 'todo')

  let l:priority_pick = s:prompt_choice('Priority', ['high', 'medium', 'low'], 2)
  if l:priority_pick == 0
    call s:render_dashboard()
    return
  endif
  let l:priority = (l:priority_pick == 1) ? 'high' : (l:priority_pick == 3 ? 'low' : 'medium')

  redraw
  let l:labels_input = input('Categories/labels (comma-separated, optional): ')
  let l:labels = []
  if !empty(l:labels_input)
    for l:item in split(l:labels_input, ',')
      let l:label = trim(l:item)
      if !empty(l:label)
        call add(l:labels, l:label)
      endif
    endfor
  endif

  redraw
  let l:desc = input('Description (optional): ')
  let l:tasks_dir = l:project.path . '/.knowns/tasks'
  if !isdirectory(l:tasks_dir)
    call mkdir(l:tasks_dir, 'p')
  endif

  let l:id_info = s:ensure_unique_task_path(l:tasks_dir, s:random_id(6))
  let l:id = l:id_info.id
  let l:file = l:id_info.path
  let l:now = strftime('%Y-%m-%dT%H:%M:%SZ', localtime())
  let l:title_safe = substitute(l:title, '"', '\\"', 'g')

  let l:lines = [
        \ '---',
        \ 'id: ' . l:id,
        \ 'title: "' . l:title_safe . '"',
        \ 'status: ' . l:status,
        \ 'priority: ' . l:priority
        \ ]
  if !empty(l:labels)
    call add(l:lines, 'labels:')
    for l:label in l:labels
      call add(l:lines, '  - ' . l:label)
    endfor
  endif
  call extend(l:lines, [
        \ "createdAt: '" . l:now . "'",
        \ "updatedAt: '" . l:now . "'",
        \ 'timeSpent: 0',
        \ '---',
        \ '',
        \ '# ' . l:title
        \ ])
  if !empty(l:desc)
    call add(l:lines, '')
    call add(l:lines, l:desc)
  endif

  call writefile(l:lines, l:file)
  call s:open_task_in_code(l:file)
  call s:render_dashboard()
  redraw
endfunction

function! s:run_make_up() abort
  let l:p = s:selected_project()
  execute '!' . 'cd ' . shellescape(l:p.path) . ' && make up'
endfunction

function! s:open_localhost() abort
  if executable('open')
    call system('open http://localhost:6420/')
  elseif executable('xdg-open')
    call system('xdg-open http://localhost:6420/')
  endif
endfunction

function! s:render_dashboard() abort
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nomodifiable nowrap nonumber norelativenumber signcolumn=no
  setlocal foldcolumn=0 nocursorline colorcolumn= nocursorcolumn
  setlocal filetype=quartzdashboard
  setlocal nospell
  setlocal listchars=
  setlocal fillchars=eob:\ 

  let l:p = s:selected_project()
  let l:tasks = s:project_tasks(l:p)
  let l:recent = s:recent_files(4)
  let l:content_w = s:content_width()

  let l:proj1 = ((s:selected_index() == 1) ? '󰄬 ' : '  ') . '1 Daily Game'
  let l:proj2 = ((s:selected_index() == 2) ? '󰄬 ' : '  ') . '2 Experiment 1'
  let l:proj3 = ((s:selected_index() == 3) ? '󰄬 ' : '  ') . '3 Web'
  let l:proj4 = ((s:selected_index() == 4) ? '󰄬 ' : '  ') . '4 Bumble'

  let l:lines = [
        \ '                    .-========-.',
        \ '                  .-  _    _  -.',
        \ '                 /   (o)  (o)   \\',
        \ '                /      /\\        \\',
        \ '               /   .-======-.     \\',
        \ '               |  /  .--.   \\      |',
        \ '               | |  |o  o|  |      |',
        \ '               | |  | -- |  |      |',
        \ '               |  \\  ----  /       |',
        \ '               |   `------`    __  |',
        \ '               |      ____    /__\\ |',
        \ '               |     / __ \\   |  | |',
        \ '               |____/_/  \\_\\__|__|_|',
        \ '                 /_/        \\_\\',
        \ '',
        \ '› Projects',
        \ l:proj1 . '    ' . l:proj2,
        \ l:proj3 . '    ' . l:proj4,
        \ '',
        \ '› Active',
        \ s:fit('󰌢 ' . l:p.title . '  ' . l:p.path, l:content_w),
        \ '',
        \ '› Status',
        \ s:kanban_status_line(),
        \ '',
        \ '› Task Board',
        \ ]

  let l:board_start_raw = len(l:lines) + 1
  let l:board = s:kanban_board_lines(l:tasks, l:content_w)
  call extend(l:lines, l:board.lines)

  call add(l:lines, '')
  call add(l:lines, '› Recent Files')
  if empty(l:recent)
    call add(l:lines, '(no recent files yet)')
  else
    for l:rf in l:recent
      call add(l:lines, '󰈔 ' . s:fit(fnamemodify(l:rf, ':~:.'), l:content_w - 3))
    endfor
  endif

  call add(l:lines, '')
  call add(l:lines, '› Commands')
  call add(l:lines, '󰱼  f  Search Vault Files')
  call add(l:lines, '󰈞  o  Open (code .)')
  call add(l:lines, '󰙯  k  Kanban (knowns browser)')
  call add(l:lines, '󰎔  n  New Knowns Task')
  call add(l:lines, '󰜎  u  Run (make up)')
  call add(l:lines, '󰖟  h  Open localhost:6420')
  call add(l:lines, '󰧮  r  Refresh')
  call add(l:lines, '󰁍  b  Back Dashboard')
  call add(l:lines, '󰅚  q  Quit')

  call add(l:lines, '')
  call add(l:lines, '[ one tool for one thing. ]')

  let l:lines = s:panel_wrap(l:lines, l:content_w)
  let l:lines = s:center_lines(l:lines)
  let l:panel_top = s:panel_top(len(l:lines))
  let l:lines = repeat([''], l:panel_top) + l:lines

  setlocal modifiable
  call setline(1, l:lines)
  setlocal nomodifiable
  normal! gg

  let b:quartz_task_rows = {}
  let b:quartz_task_points = []
  let l:cell_w = [l:board.w1, l:board.w2, l:board.w3]
  for l:cell in l:board.cells
    let l:raw_line = l:board_start_raw + 3 + l:cell.row
    let l:wrapped_line = l:raw_line + 3
    let l:final_line = l:panel_top + l:wrapped_line
    if l:final_line < 1 || l:final_line > len(l:lines)
      continue
    endif
    if !has_key(b:quartz_task_rows, l:final_line)
      let b:quartz_task_rows[l:final_line] = {}
    endif
    let b:quartz_task_rows[l:final_line][l:cell.col] = l:cell.task

    let l:line_text = l:lines[l:final_line - 1]
    let l:sep1 = match(l:line_text, '│')
    let l:sep2 = match(l:line_text, '│', l:sep1 + 1)
    let l:sep3 = match(l:line_text, '│', l:sep2 + 1)
    if l:sep1 >= 0 && l:sep2 >= 0 && l:sep3 >= 0
      if l:cell.col == 1
        let l:start_col = l:sep1 + 2
      elseif l:cell.col == 2
        let l:start_col = l:sep2 + 2
      else
        let l:start_col = l:sep3 + 2
      endif
      call add(b:quartz_task_points, {'line': l:final_line, 'col': l:start_col, 'task': l:cell.task})
    endif
  endfor
  call sort(b:quartz_task_points, {a,b -> (a.line == b.line ? a.col - b.col : a.line - b.line)})

  nnoremap <silent><buffer> q :qa!<CR>
  nnoremap <silent><buffer> b :BackDashboard<CR>
  nnoremap <silent><buffer> r :call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> f :call <SID>search_vault_file()<CR>
  nnoremap <silent><buffer> o :call <SID>run_project_bg('code .')<CR>:call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> k :call <SID>run_knowns_browser_safe()<CR>
  nnoremap <silent><buffer> n :call <SID>create_knowns_task()<CR>
  nnoremap <silent><buffer> <CR> :call <SID>open_task_under_cursor()<CR>
  nnoremap <silent><buffer> <Tab> :call <SID>next_task_point(0)<CR>
  nnoremap <silent><buffer> <S-Tab> :call <SID>next_task_point(1)<CR>
  nnoremap <silent><buffer> ]t :call <SID>next_task_point(0)<CR>
  nnoremap <silent><buffer> [t :call <SID>next_task_point(1)<CR>
  nnoremap <silent><buffer> u :call <SID>run_make_up()<CR>:call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> h :call <SID>open_localhost()<CR>:call <SID>render_dashboard()<CR>

  for l:i in range(1, len(s:projects()))
    execute printf('nnoremap <silent><buffer> %d :call <SID>set_project(%d)<CR>', l:i, l:i)
  endfor

  call s:dashboard_highlight()
endfunction

function! s:dashboard_highlight() abort
  highlight Normal guifg=#dcd7ba guibg=#1f2335 ctermfg=252 ctermbg=235
  highlight EndOfBuffer guifg=#1f2335 guibg=#1f2335 ctermfg=235 ctermbg=235
  highlight NonText guifg=#1f2335 guibg=#1f2335 ctermfg=235 ctermbg=235

  highlight QuartzDashDots guifg=#f7768e guibg=#1f2335 ctermfg=204 ctermbg=235
  highlight QuartzDashAccent guifg=#8a5cf6 guibg=#1f2335 ctermfg=99 ctermbg=235
  highlight QuartzDashHead guifg=#dbbc7f guibg=#1f2335 ctermfg=180 ctermbg=235
  highlight QuartzDashMuted guifg=#8f95b3 guibg=#1f2335 ctermfg=103 ctermbg=235
  highlight QuartzDashTodo guifg=#7dcfff guibg=#1f2335 ctermfg=117 ctermbg=235
  highlight QuartzDashProg guifg=#f6c177 guibg=#1f2335 ctermfg=221 ctermbg=235
  highlight QuartzDashReview guifg=#f7768e guibg=#1f2335 ctermfg=204 ctermbg=235
  highlight QuartzDashRun guifg=#9ece6a guibg=#1f2335 ctermfg=114 ctermbg=235
  highlight QuartzDashBorder guifg=#2f3652 guibg=#1f2335 ctermfg=60 ctermbg=235
  highlight QuartzDashR2 guifg=#7aa2f7 guibg=#1f2335 ctermfg=111 ctermbg=235
  highlight QuartzDashR2Detail guifg=#e5e9f0 guibg=#1f2335 ctermfg=255 ctermbg=235
  highlight QuartzDashR2Eye guifg=#f7768e guibg=#1f2335 ctermfg=204 ctermbg=235

  if exists('+winhighlight')
    setlocal winhighlight=Normal:Normal,NormalNC:Normal,EndOfBuffer:EndOfBuffer
  endif

  syntax clear
  syntax match QuartzDashBorder /[╭╮╰╯├┤┬┴┼─│]/
  syntax match QuartzDashDots /●/
  syntax match QuartzDashR2 /\.-========-\.\|\.=\\{6}\.-\|`------`\|\/_\/        \\_\\/
  syntax match QuartzDashR2Detail /\/__\\\|__\\|  \\_\\\|\\  ----  \/\|\.--\./
  syntax match QuartzDashR2Eye /(o)\|\|o  o\|/
  syntax match QuartzDashHead /^\s*›.\+$/
  syntax match QuartzDashTodo /󰄵[^│]*/
  syntax match QuartzDashProg /󰔟[^│]*/
  syntax match QuartzDashReview /󱋭[^│]*/
  syntax match QuartzDashRun /Kanban:\s.*running$/
  syntax match QuartzDashMuted /^\s*\[ one tool for one thing\. \]\s*$/
endfunction

command! QuartzDashboard call <SID>render_dashboard()
command! BackDashboard QuartzDashboard

nnoremap <silent> <leader>b :BackDashboard<CR>
nnoremap <silent> <F2> :BackDashboard<CR>

augroup QuartzDashboard
  autocmd!
  autocmd VimEnter * if argc() == 0 && &buftype ==# '' | call s:render_dashboard() | endif
  autocmd VimResized * if &filetype ==# 'quartzdashboard' | call s:render_dashboard() | endif
augroup END
