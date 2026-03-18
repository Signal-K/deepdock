if exists("g:loaded_quartz_dashboard") && !get(g:, 'quartz_dashboard_force_reload', 0)
  finish
endif
let g:quartz_dashboard_force_reload = 0
let g:loaded_quartz_dashboard = 1

let s:projects_store = expand('~/.vim/quartz-projects.json')

function! s:default_projects() abort
  return [
        \ {'title': 'Daily Game', 'path': '/Users/scroobz/Navigation/saily', 'parent': 'Star Sailors', 'color': '#7dcfff'},
        \ {'title': 'Experiment 1', 'path': '/Users/scroobz/Navigation/Native/planet-hunters-experiment-1', 'parent': 'Star Sailors', 'color': '#f6c177'},
        \ {'title': 'Web', 'path': '/Users/scroobz/Navigation/client', 'parent': 'Star Sailors', 'color': '#9ece6a'},
        \ {'title': 'Bumble', 'path': '/Users/scroobz/Navigation/bee-garden', 'parent': 'Star Sailors', 'color': '#f7768e'},
        \ {'title': 'Post', 'path': '/Users/scroobz/Navigation/quartz', 'parent': '', 'color': '#bb9af7'},
        \ ]
endfunction

function! s:normalize_project(project) abort
  let l:title = trim(get(a:project, 'title', ''))
  let l:path = trim(get(a:project, 'path', ''))
  if empty(l:title) || empty(l:path)
    return {}
  endif
  return {
        \ 'title': l:title,
        \ 'path': l:path,
        \ 'parent': trim(get(a:project, 'parent', '')),
        \ 'color': trim(get(a:project, 'color', '#dcd7ba')),
        \ }
endfunction

function! s:save_projects() abort
  if !exists('*json_encode')
    return
  endif
  try
    call writefile([json_encode(g:quartz_projects)], s:projects_store)
  catch
  endtry
endfunction

function! s:init_projects() abort
  let l:projects = []
  if filereadable(s:projects_store) && exists('*json_decode')
    try
      let l:decoded = json_decode(join(readfile(s:projects_store), "\n"))
      if type(l:decoded) == v:t_list
        for l:p in l:decoded
          let l:n = s:normalize_project(l:p)
          if !empty(l:n)
            call add(l:projects, l:n)
          endif
        endfor
      endif
    catch
      let l:projects = []
    endtry
  endif

  if empty(l:projects)
    for l:p in s:default_projects()
      let l:n = s:normalize_project(l:p)
      if !empty(l:n)
        call add(l:projects, l:n)
      endif
    endfor
  endif
  let g:quartz_projects = l:projects
endfunction

call s:init_projects()

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
    if v:shell_error != 0
      echohl ErrorMsg | echom 'Failed to open Obsidian URI: ' . l:url | echohl None
    else
      echom 'Opened in Obsidian: ' . a:relpath
    endif
  elseif executable('xdg-open')
    call system('xdg-open ' . shellescape(l:url))
    if v:shell_error != 0
      echohl ErrorMsg | echom 'Failed to open Obsidian URI: ' . l:url | echohl None
    else
      echom 'Opened in Obsidian: ' . a:relpath
    endif
  else
    echohl ErrorMsg | echom 'No open/xdg-open found for Obsidian URI.' | echohl None
  endif
endfunction

function! s:project_env_relpath(project) abort
  let l:base = fnamemodify(get(a:project, 'path', ''), ':t')
  if empty(l:base)
    let l:base = get(a:project, 'title', 'project')
  endif
  let l:key = tolower(l:base)
  let l:key = substitute(l:key, '[^a-z0-9._-]\+', '-', 'g')
  let l:key = substitute(l:key, '^-\\+', '', '')
  let l:key = substitute(l:key, '-\\+$', '', '')
  if empty(l:key)
    let l:key = 'project'
  endif
  return 'private/project-env/' . l:key . '.env'
endfunction

function! s:project_env_abs_path(project) abort
  let l:root = s:vault_root()
  let l:rel = s:project_env_relpath(a:project)
  return {'root': l:root, 'rel': l:rel, 'abs': l:root . '/' . l:rel}
endfunction

function! s:ensure_project_env_file(project) abort
  let l:paths = s:project_env_abs_path(a:project)
  let l:abs = l:paths.abs
  let l:dir = fnamemodify(l:abs, ':h')
  if !isdirectory(l:dir)
    call mkdir(l:dir, 'p')
  endif
  if !filereadable(l:abs)
    let l:lines = [
          \ '# ' . get(a:project, 'title', 'Project') . ' env variables',
          \ '# Stored in vault/private/project-env (gitignored)',
          \ '',
          \ ]
    call writefile(l:lines, l:abs)
  endif
  return l:paths
endfunction

function! s:read_project_env(project) abort
  let l:paths = s:ensure_project_env_file(a:project)
  let l:out = []
  for l:line in readfile(l:paths.abs)
    if l:line =~# '^\s*$' || l:line =~# '^\s*#'
      continue
    endif
    let l:raw = substitute(l:line, '^\s*export\s\+', '', '')
    let l:eq = stridx(l:raw, '=')
    if l:eq <= 0
      continue
    endif
    let l:key = trim(strpart(l:raw, 0, l:eq))
    if empty(l:key)
      continue
    endif
    let l:value = strpart(l:raw, l:eq + 1)
    call add(l:out, {'key': l:key, 'value': l:value})
  endfor
  return l:out
endfunction

function! s:write_project_env(project, env_items) abort
  let l:paths = s:ensure_project_env_file(a:project)
  let l:lines = [
        \ '# ' . get(a:project, 'title', 'Project') . ' env variables',
        \ '# Stored in vault/private/project-env (gitignored)',
        \ '',
        \ ]
  for l:item in a:env_items
    if empty(get(l:item, 'key', ''))
      continue
    endif
    call add(l:lines, l:item.key . '=' . get(l:item, 'value', ''))
  endfor
  call writefile(l:lines, l:paths.abs)
  return l:paths
endfunction

function! s:env_line_index() abort
  let l:m = matchlist(getline('.'), '^\s*│\s*\(\d\+\)\s')
  if empty(l:m)
    return 0
  endif
  return str2nr(l:m[1])
endfunction

function! s:env_validate_key(key) abort
  return a:key =~# '^[A-Za-z_][A-Za-z0-9_]*$'
endfunction

function! s:env_add_var() abort
  if !exists('b:quartz_env_project')
    return
  endif
  redraw
  let l:key = trim(input('Env key: '))
  if empty(l:key)
    return
  endif
  if !s:env_validate_key(l:key)
    echohl ErrorMsg | echom 'Invalid key. Use [A-Za-z_][A-Za-z0-9_]*' | echohl None
    return
  endif
  let l:value = input('Env value: ')
  let l:items = copy(get(b:, 'quartz_env_items', []))
  let l:updated = 0
  for l:i in range(0, len(l:items) - 1)
    if l:items[l:i].key ==# l:key
      let l:items[l:i].value = l:value
      let l:updated = 1
      break
    endif
  endfor
  if !l:updated
    call add(l:items, {'key': l:key, 'value': l:value})
  endif
  call s:write_project_env(b:quartz_env_project, l:items)
  call s:render_project_env_view()
endfunction

function! s:env_edit_var() abort
  if !exists('b:quartz_env_project')
    return
  endif
  let l:idx = s:env_line_index()
  let l:items = copy(get(b:, 'quartz_env_items', []))
  if l:idx <= 0 || l:idx > len(l:items)
    echom 'Move cursor to an env variable row.'
    return
  endif
  let l:item = l:items[l:idx - 1]
  redraw
  let l:new_key = trim(input('Env key: ', l:item.key))
  if empty(l:new_key)
    return
  endif
  if !s:env_validate_key(l:new_key)
    echohl ErrorMsg | echom 'Invalid key. Use [A-Za-z_][A-Za-z0-9_]*' | echohl None
    return
  endif
  let l:new_value = input('Env value: ', l:item.value)
  let l:items[l:idx - 1] = {'key': l:new_key, 'value': l:new_value}
  call s:write_project_env(b:quartz_env_project, l:items)
  call s:render_project_env_view()
endfunction

function! s:env_delete_var() abort
  if !exists('b:quartz_env_project')
    return
  endif
  let l:idx = s:env_line_index()
  let l:items = copy(get(b:, 'quartz_env_items', []))
  if l:idx <= 0 || l:idx > len(l:items)
    echom 'Move cursor to an env variable row.'
    return
  endif
  let l:item = l:items[l:idx - 1]
  redraw
  let l:ans = tolower(trim(input('Delete ' . l:item.key . '? [y/N]: ')))
  if l:ans !~# '^y'
    return
  endif
  call remove(l:items, l:idx - 1)
  call s:write_project_env(b:quartz_env_project, l:items)
  call s:render_project_env_view()
endfunction

function! s:render_project_env_view() abort
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nomodifiable nowrap nonumber norelativenumber signcolumn=no
  setlocal foldcolumn=0 nocursorline colorcolumn= nocursorcolumn
  setlocal filetype=quartzdashboard
  setlocal nospell
  setlocal listchars=
  setlocal fillchars=eob:\ 

  let l:p = s:selected_project()
  let l:paths = s:ensure_project_env_file(l:p)
  let l:items = s:read_project_env(l:p)
  let l:content_w = s:content_width()
  let l:inner_w = max([96, l:content_w])
  let l:list_w = l:inner_w

  let l:lines = [
        \ '› Project Env',
        \ s:fit('󰌢 ' . l:p.title . '  󰉋 ' . l:paths.rel, l:inner_w),
        \ ''
        \ ]
  call add(l:lines, '┌' . repeat('─', l:list_w) . '┐')
  call add(l:lines, '│' . s:pad(' #   KEY                          VALUE', l:list_w) . '│')
  call add(l:lines, '├' . repeat('─', l:list_w) . '┤')
  if empty(l:items)
    call add(l:lines, '│' . s:pad(' (no env vars yet)', l:list_w) . '│')
  else
    let l:max_rows = min([40, len(l:items)])
    for l:i in range(0, l:max_rows - 1)
      let l:item = l:items[l:i]
      let l:row = printf(' %2d  %-28s %s', l:i + 1, l:item.key, l:item.value)
      call add(l:lines, '│' . s:pad(s:fit(l:row, l:list_w), l:list_w) . '│')
    endfor
    if len(l:items) > l:max_rows
      call add(l:lines, '│' . s:pad(' ...more vars exist in file (' . len(l:items) . ' total)', l:list_w) . '│')
    endif
  endif
  call add(l:lines, '└' . repeat('─', l:list_w) . '┘')
  call add(l:lines, '')
  call add(l:lines, s:fit('a add  e edit  d delete  r refresh  b back  q quit', l:inner_w))
  call add(l:lines, s:fit('<Enter> edit row under cursor', l:inner_w))

  let l:lines = s:panel_wrap(l:lines, l:inner_w)
  let l:lines = s:center_lines(l:lines)
  let l:panel_top = s:panel_top(len(l:lines))
  let l:lines = repeat([''], l:panel_top) + l:lines

  setlocal modifiable
  call setline(1, l:lines)
  setlocal nomodifiable
  normal! gg

  let b:quartz_view = 'projectenv'
  let b:quartz_env_project = l:p
  let b:quartz_env_items = l:items

  nnoremap <silent><buffer> q :qa!<CR>
  nnoremap <silent><buffer> b :call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> r :call <SID>render_project_env_view()<CR>
  nnoremap <silent><buffer> a :call <SID>env_add_var()<CR>
  nnoremap <silent><buffer> e :call <SID>env_edit_var()<CR>
  nnoremap <silent><buffer> d :call <SID>env_delete_var()<CR>
  nnoremap <silent><buffer> <CR> :call <SID>env_edit_var()<CR>

  call s:dashboard_highlight()
endfunction

function! s:open_project_env() abort
  call s:render_project_env_view()
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
  let l:lines = readfile(a:file, '', 120)
  if empty(l:lines) || l:lines[0] !=# '---'
    return {}
  endif

  let l:end = -1
  for l:i in range(1, len(l:lines) - 1)
    if l:lines[l:i] ==# '---'
      let l:end = l:i
      break
    endif
  endfor
  if l:end < 0
    return {}
  endif

  let l:fm = l:lines[1 : l:end - 1]
  let l:title = ''
  let l:status = ''
  let l:i = 0
  while l:i < len(l:fm)
    let l:line = l:fm[l:i]
    if l:line =~# '^title:\s*'
      let l:title = substitute(l:line, '^title:\s*', '', '')
      if l:title =~# '^>-\s*$\|^|\s*$\|^|-\s*$'
        let l:i += 1
        let l:parts = []
        while l:i < len(l:fm) && l:fm[l:i] =~# '^\s\+'
          call add(l:parts, trim(l:fm[l:i]))
          let l:i += 1
        endwhile
        let l:title = join(l:parts, ' ')
        continue
      else
        let l:title = substitute(l:title, "^['\"]\\|['\"]$", '', 'g')
      endif
    elseif l:line =~# '^status:\s*'
      let l:status = tolower(substitute(l:line, '^status:\s*', '', ''))
    endif
    let l:i += 1
  endwhile

  if empty(l:title)
    for l:j in range(l:end + 1, len(l:lines) - 1)
      if l:lines[l:j] =~# '^#\s\+'
        let l:title = substitute(l:lines[l:j], '^#\s\+', '', '')
        break
      endif
    endfor
    if empty(l:title)
      return {}
    endif
  endif
  return {'title': l:title, 'status': l:status, 'file': a:file}
endfunction

function! s:slugify_title(title) abort
  let l:s = tolower(trim(a:title))
  let l:s = substitute(l:s, '[^a-z0-9]\+', '-', 'g')
  let l:s = substitute(l:s, '^-\\|-$', '', 'g')
  return empty(l:s) ? 'task' : l:s
endfunction

function! s:legacy_task_id_from_file(file) abort
  let l:base = fnamemodify(a:file, ':t')
  if l:base =~# '^[a-z0-9]\{6\}\.md$'
    return substitute(l:base, '\.md$', '', '')
  endif
  return ''
endfunction

function! s:migrate_legacy_task_file(file) abort
  let l:id = s:legacy_task_id_from_file(a:file)
  if empty(l:id)
    return a:file
  endif

  let l:meta = s:extract_task_meta(a:file)
  if empty(l:meta) || empty(get(l:meta, 'title', ''))
    return a:file
  endif

  let l:dir = fnamemodify(a:file, ':h')
  let l:slug = s:slugify_title(l:meta.title)
  let l:new = l:dir . '/task-' . l:id . ' - ' . l:slug . '.md'
  if filereadable(l:new)
    return l:new
  endif
  if rename(a:file, l:new) == 0
    return l:new
  endif
  return a:file
endfunction

function! s:migrate_project_legacy_tasks() abort
  let l:p = s:selected_project()
  let l:dir = l:p.path . '/.knowns/tasks'
  if !isdirectory(l:dir)
    echom 'No .knowns/tasks directory for ' . l:p.title
    return
  endif

  let l:files = globpath(l:dir, '*.md', 1, 1)
  let l:moved = 0
  let l:failed = 0
  for l:f in l:files
    let l:new = s:migrate_legacy_task_file(l:f)
    if l:new !=# l:f
      let l:moved += 1
    elseif !empty(s:legacy_task_id_from_file(l:f))
      let l:failed += 1
    endif
  endfor

  echom printf('Migration [%s]: renamed %d legacy tasks%s',
        \ l:p.title,
        \ l:moved,
        \ (l:failed > 0 ? printf(', %d unchanged', l:failed) : ''))
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

  for l:f_raw in l:files
    let l:f = s:migrate_legacy_task_file(l:f_raw)
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

function! s:project_tasks_full(project) abort
  let l:dir = a:project.path . '/.knowns/tasks'
  let l:todo = []
  let l:inprog = []
  let l:review = []
  if !isdirectory(l:dir)
    return {'todo': l:todo, 'inprog': l:inprog, 'review': l:review}
  endif

  let l:files = globpath(l:dir, '*.md', 1, 1)
  call sort(l:files, {a, b -> getftime(b) - getftime(a)})
  for l:f_raw in l:files
    let l:f = s:migrate_legacy_task_file(l:f_raw)
    let l:m = s:extract_task_meta(l:f)
    if empty(l:m)
      continue
    endif
    let l:s = l:m.status
    if l:s ==# 'done'
      continue
    endif

    if index(['todo', 'backlog', 'open'], l:s) >= 0
      call add(l:todo, l:m)
    elseif index(['in-progress', 'doing', 'wip'], l:s) >= 0
      call add(l:inprog, l:m)
    elseif index(['in-review', 'in_review', 'inreview', 'blocked', 'on-hold'], l:s) >= 0
      call add(l:review, l:m)
    endif
  endfor
  return {'todo': l:todo, 'inprog': l:inprog, 'review': l:review}
endfunction

function! s:project_tasks_kanban(project, include_archived) abort
  let l:dir = a:project.path . '/.knowns/tasks'
  let l:todo = []
  let l:inprog = []
  let l:review = []
  let l:done = []
  if !isdirectory(l:dir)
    return {'todo': l:todo, 'inprog': l:inprog, 'review': l:review, 'done': l:done}
  endif

  let l:files = globpath(l:dir, '*.md', 1, 1)
  call sort(l:files, {a, b -> getftime(b) - getftime(a)})
  for l:f_raw in l:files
    let l:f = s:migrate_legacy_task_file(l:f_raw)
    let l:m = s:extract_task_meta(l:f)
    if empty(l:m)
      continue
    endif
    let l:s = tolower(l:m.status)

    if index(['todo', 'backlog', 'open'], l:s) >= 0
      call add(l:todo, l:m)
    elseif index(['in-progress', 'doing', 'wip'], l:s) >= 0
      call add(l:inprog, l:m)
    elseif index(['in-review', 'in_review', 'inreview', 'blocked', 'on-hold'], l:s) >= 0
      call add(l:review, l:m)
    elseif index(['done', 'closed', 'completed'], l:s) >= 0
      call add(l:done, l:m)
    elseif a:include_archived && index(['archived', 'archive', 'obsolete', 'cancelled', 'canceled'], l:s) >= 0
      call add(l:done, l:m)
    endif
  endfor
  return {'todo': l:todo, 'inprog': l:inprog, 'review': l:review, 'done': l:done}
endfunction

function! s:project_tasks_all(project) abort
  let l:dir = a:project.path . '/.knowns/tasks'
  let l:out = []
  if !isdirectory(l:dir)
    return l:out
  endif

  let l:files = globpath(l:dir, '*.md', 1, 1)
  call sort(l:files, {a, b -> getftime(b) - getftime(a)})
  for l:f_raw in l:files
    let l:f = s:migrate_legacy_task_file(l:f_raw)
    let l:m = s:extract_task_meta(l:f)
    if empty(l:m)
      continue
    endif
    call add(l:out, l:m)
  endfor
  return l:out
endfunction

function! s:status_label(status) abort
  let l:s = tolower(a:status)
  if index(['todo', 'backlog', 'open'], l:s) >= 0
    return '[TODO]'
  endif
  if index(['in-progress', 'doing', 'wip'], l:s) >= 0
    return '[IN PROGRESS]'
  endif
  if index(['in-review', 'in_review', 'inreview'], l:s) >= 0
    return '[REVIEW]'
  endif
  if index(['blocked', 'on-hold'], l:s) >= 0
    return '[BLOCKED]'
  endif
  if index(['done', 'closed', 'completed'], l:s) >= 0
    return '[DONE]'
  endif
  return '[OTHER]'
endfunction

function! s:task_status_group(status) abort
  let l:s = tolower(a:status)
  if index(['todo', 'backlog', 'open'], l:s) >= 0
    return 'todo'
  endif
  if index(['in-progress', 'doing', 'wip'], l:s) >= 0
    return 'inprog'
  endif
  if index(['in-review', 'in_review', 'inreview'], l:s) >= 0
    return 'review'
  endif
  if index(['blocked', 'on-hold'], l:s) >= 0
    return 'blocked'
  endif
  if index(['done', 'closed', 'completed'], l:s) >= 0
    return 'done'
  endif
  return 'other'
endfunction

function! s:filter_mode_label(mode) abort
  let l:map = {
        \ 'all': 'ALL',
        \ 'todo': 'TODO',
        \ 'inprog': 'IN PROGRESS',
        \ 'review': 'REVIEW',
        \ 'blocked': 'BLOCKED',
        \ 'other': 'OTHER',
        \ 'done': 'DONE'
        \ }
  return get(l:map, a:mode, 'ALL')
endfunction

function! s:filter_tasks_by_mode(tasks, mode) abort
  if a:mode ==# 'all'
    return a:tasks
  endif
  let l:out = []
  for l:t in a:tasks
    if s:task_status_group(get(l:t, 'status', '')) ==# a:mode
      call add(l:out, l:t)
    endif
  endfor
  return l:out
endfunction

function! s:task_sort_rank(task) abort
  let l:group = s:task_status_group(get(a:task, 'status', ''))
  if l:group ==# 'todo'
    return 0
  endif
  if l:group ==# 'inprog'
    return 1
  endif
  if l:group ==# 'review'
    return 2
  endif
  if l:group ==# 'blocked'
    return 3
  endif
  if l:group ==# 'other'
    return 4
  endif
  return 5
endfunction

function! s:task_list_cycle_filter() abort
  let l:modes = ['all', 'todo', 'inprog', 'review', 'blocked', 'other', 'done']
  let l:cur = get(b:, 'quartz_task_filter', 'all')
  let l:idx = index(l:modes, l:cur)
  if l:idx < 0
    let l:idx = 0
  endif
  let l:next = l:modes[(l:idx + 1) % len(l:modes)]
  call s:render_task_list_view(get(b:, 'quartz_task_query', ''), l:next)
endfunction

function! s:open_list_task_by_number_prompt() abort
  let l:max = get(b:, 'quartz_list_max_index', 0)
  if l:max <= 0
    echom 'No tasks in current list.'
    return
  endif
  redraw
  let l:raw = trim(input('Task # (1-' . l:max . '): '))
  if empty(l:raw) || l:raw !~# '^\d\+$'
    return
  endif
  let l:n = str2nr(l:raw)
  call s:open_list_task_slot(l:n)
endfunction

function! s:task_list_header_label(query, mode) abort
  let l:parts = []
  if a:mode !=# 'all'
    call add(l:parts, 'Filter=' . s:filter_mode_label(a:mode))
  endif
  if !empty(a:query)
    call add(l:parts, 'Search="' . a:query . '"')
  endif
  return empty(l:parts) ? '' : join(l:parts, '  ')
endfunction

function! s:task_matches_query(task, query) abort
  if empty(a:query)
    return 1
  endif
  let l:q = tolower(a:query)
  let l:title = tolower(get(a:task, 'title', ''))
  let l:status = tolower(get(a:task, 'status', ''))
  let l:file = tolower(fnamemodify(get(a:task, 'file', ''), ':t'))
  return stridx(l:title, l:q) >= 0 || stridx(l:status, l:q) >= 0 || stridx(l:file, l:q) >= 0
endfunction

function! s:filter_tasks(tasks, query) abort
  if empty(a:query)
    return a:tasks
  endif
  let l:out = []
  for l:t in a:tasks
    if s:task_matches_query(l:t, a:query)
      call add(l:out, l:t)
    endif
  endfor
  return l:out
endfunction

function! s:render_task_list_view(...) abort
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nomodifiable nowrap nonumber norelativenumber signcolumn=no
  setlocal foldcolumn=0 nocursorline colorcolumn= nocursorcolumn
  setlocal filetype=quartzdashboard
  setlocal nospell
  setlocal listchars=
  setlocal fillchars=eob:\ 

  let l:p = s:selected_project()
  let l:from_list = (exists('b:quartz_view') && b:quartz_view ==# 'tasklist')
  let l:query = (a:0 >= 1) ? a:1 : (l:from_list ? get(b:, 'quartz_task_query', '') : '')
  let l:mode = (a:0 >= 2) ? a:2 : (l:from_list ? get(b:, 'quartz_task_filter', 'all') : 'all')
  let l:all_tasks = s:project_tasks_all(l:p)
  let l:tasks = s:filter_tasks_by_mode(s:filter_tasks(l:all_tasks, l:query), l:mode)
  if l:mode ==# 'all'
    call sort(l:tasks, {a, b -> s:task_sort_rank(a) - s:task_sort_rank(b)})
  endif
  let l:content_w = s:content_width()
  let l:inner_w = max([90, l:content_w])
  let l:list_w = l:inner_w

  let l:lines = [
        \ '› Task List',
        \ s:fit('󰌢 ' . l:p.title . '  󰈔 ' . l:p.path, l:inner_w),
        \ ''
        \ ]

  call add(l:lines, '┌' . repeat('─', l:list_w) . '┐')
  call add(l:lines, '│' . s:pad(' #   STATUS            TITLE', l:list_w) . '│')
  let l:header = s:task_list_header_label(l:query, l:mode)
  if !empty(l:header)
    call add(l:lines, '│' . s:pad(' ' . s:fit(l:header, l:list_w - 1), l:list_w) . '│')
  endif
  call add(l:lines, '├' . repeat('─', l:list_w) . '┤')

  let b:quartz_list_slots = {}
  let b:quartz_list_index = {}
  let l:max_rows = min([25, len(l:tasks)])
  let b:quartz_list_max_index = l:max_rows
  if l:max_rows == 0
    if empty(l:query) && l:mode ==# 'all'
      call add(l:lines, '│' . s:pad(' (no tasks found)', l:list_w) . '│')
    else
      call add(l:lines, '│' . s:pad(' (no tasks match current search/filter)', l:list_w) . '│')
    endif
  else
    for l:i in range(0, l:max_rows - 1)
      let l:t = l:tasks[l:i]
      let l:idx = l:i + 1
      let l:status = s:status_label(get(l:t, 'status', ''))
      let l:row = printf(' %2d  %-18s %s', l:idx, l:status, l:t.title)
      call add(l:lines, '│' . s:pad(s:fit(l:row, l:list_w), l:list_w) . '│')
      let b:quartz_list_index[l:idx] = l:t
      if l:idx <= 9
        let b:quartz_list_slots[l:idx] = l:t
      endif
    endfor
  endif
  call add(l:lines, '└' . repeat('─', l:list_w) . '┘')
  call add(l:lines, '')
  call add(l:lines, s:fit('Showing first 25 rows. 1-9 quick open  + open by task number  s search  f cycle filter', l:inner_w))
  call add(l:lines, s:fit('r refresh  b back  q quit', l:inner_w))
  call add(l:lines, s:fit('M migrate legacy task filenames for this project', l:inner_w))

  let l:lines = s:panel_wrap(l:lines, l:inner_w)
  let l:lines = s:center_lines(l:lines)
  let l:panel_top = s:panel_top(len(l:lines))
  let l:lines = repeat([''], l:panel_top) + l:lines

  setlocal modifiable
  call setline(1, l:lines)
  setlocal nomodifiable
  normal! gg

  let b:quartz_view = 'tasklist'
  let b:quartz_task_query = l:query
  let b:quartz_task_filter = l:mode

  nnoremap <silent><buffer> q :qa!<CR>
  nnoremap <silent><buffer> b :call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> r :call <SID>render_task_list_view(get(b:, "quartz_task_query", ""), get(b:, "quartz_task_filter", "all"))<CR>
  nnoremap <silent><buffer> s :call <SID>task_list_interactive_search()<CR>
  nnoremap <silent><buffer> f :call <SID>task_list_cycle_filter()<CR>
  nnoremap <silent><buffer> + :call <SID>open_list_task_by_number_prompt()<CR>
  nnoremap <silent><buffer> M :call <SID>migrate_project_legacy_tasks()<CR>:call <SID>render_task_list_view(get(b:, "quartz_task_query", ""), get(b:, "quartz_task_filter", "all"))<CR>
  nnoremap <silent><buffer> d :call <SID>render_docker_view()<CR>
  nnoremap <silent><buffer> j :call <SID>render_full_kanban_view()<CR>
  nnoremap <silent><buffer> K :call <SID>render_knowns_kanban_view(0)<CR>
  nnoremap <silent><buffer> , :call <SID>stop_running_knowns()<CR>
  nnoremap <silent><buffer> <CR> :call <SID>open_list_task_under_cursor()<CR>
  for l:i in range(1, 9)
    execute printf('nnoremap <silent><buffer> %d :call <SID>open_list_task_slot(%d)<CR>', l:i, l:i)
  endfor

  call s:dashboard_highlight()
endfunction

function! s:task_list_interactive_search() abort
  if !exists('b:quartz_view') || b:quartz_view !=# 'tasklist'
    return
  endif

  let l:q = get(b:, 'quartz_task_query', '')
  let l:mode = get(b:, 'quartz_task_filter', 'all')
  call s:render_task_list_view(l:q, l:mode)
  while 1
    redraw
    echo 'Search tickets: ' . l:q . '   (<Esc> clear, <CR> done, <BS> delete)'
    let l:ch = getcharstr()
    if l:ch ==# "\<CR>"
      break
    endif
    if l:ch ==# "\<Esc>"
      let l:q = ''
      call s:render_task_list_view(l:q, l:mode)
      break
    endif
    if l:ch ==# "\<BS>" || l:ch ==# "\<Del>" || l:ch ==# nr2char(127)
      if strchars(l:q) > 0
        let l:q = strcharpart(l:q, 0, strchars(l:q) - 1)
      endif
      call s:render_task_list_view(l:q, l:mode)
      continue
    endif
    if l:ch =~# '^[[:print:]]$'
      let l:q .= l:ch
      call s:render_task_list_view(l:q, l:mode)
    endif
  endwhile
  redraw
endfunction

function! s:render_full_kanban_view() abort
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nomodifiable nowrap nonumber norelativenumber signcolumn=no
  setlocal foldcolumn=0 nocursorline colorcolumn= nocursorcolumn
  setlocal filetype=quartzdashboard
  setlocal nospell
  setlocal listchars=
  setlocal fillchars=eob:\ 

  let l:p = s:selected_project()
  let l:tasks = s:project_tasks_full(l:p)
  let l:content_w = s:content_width()
  let l:inner_w = max([110, l:content_w + 8])

  let l:lines = [
        \ '› Full Kanban',
        \ s:fit('󰌢 ' . l:p.title . '  (all open tasks)', l:inner_w),
        \ ''
        \ ]

  let l:board_start_raw = len(l:lines) + 1
  let l:board = s:kanban_board_lines(l:tasks, l:inner_w)
  call extend(l:lines, l:board.lines)
  call add(l:lines, '')
  call add(l:lines, s:fit('⇥/⇧⇥ or ]t/[t move tasks, <Enter> open detail, O open code, r refresh, b back, q quit', l:inner_w))

  let l:lines = s:panel_wrap(l:lines, l:inner_w)
  let l:lines = s:center_lines(l:lines)
  let l:panel_top = s:panel_top(len(l:lines))
  let l:lines = repeat([''], l:panel_top) + l:lines

  setlocal modifiable
  call setline(1, l:lines)
  setlocal nomodifiable
  normal! gg

  let b:quartz_view = 'fullkanban'
  let b:quartz_task_rows = {}
  let b:quartz_task_points = []
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
  nnoremap <silent><buffer> b :call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> r :call <SID>render_full_kanban_view()<CR>
  nnoremap <silent><buffer> d :call <SID>render_docker_view()<CR>
  nnoremap <silent><buffer> K :call <SID>render_knowns_kanban_view(0)<CR>
  nnoremap <silent><buffer> , :call <SID>stop_running_knowns()<CR>
  nnoremap <silent><buffer> <CR> :call <SID>open_task_detail_under_cursor()<CR>
  nnoremap <silent><buffer> O :call <SID>open_task_in_code_under_cursor()<CR>
  nnoremap <silent><buffer> <Tab> :call <SID>next_task_point(0)<CR>
  nnoremap <silent><buffer> <S-Tab> :call <SID>next_task_point(1)<CR>
  nnoremap <silent><buffer> ]t :call <SID>next_task_point(0)<CR>
  nnoremap <silent><buffer> [t :call <SID>next_task_point(1)<CR>

  call s:dashboard_highlight()
endfunction

function! s:render_knowns_kanban_view(...) abort
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nomodifiable nowrap nonumber norelativenumber signcolumn=no
  setlocal foldcolumn=0 nocursorline colorcolumn= nocursorcolumn
  setlocal filetype=quartzdashboard
  setlocal nospell
  setlocal listchars=
  setlocal fillchars=eob:\ 

  let l:include_archived = (a:0 >= 1) ? a:1 : get(b:, 'quartz_include_archived', 0)
  let l:p = s:selected_project()
  let l:tasks = s:project_tasks_kanban(l:p, l:include_archived)
  let l:content_w = s:content_width()
  let l:inner_w = max([130, l:content_w + 14])

  let l:lines = [
        \ '› Knowns Kanban',
        \ s:fit('󰌢 ' . l:p.title . '  |  archived: ' . (l:include_archived ? 'ON' : 'OFF'), l:inner_w),
        \ ''
        \ ]

  let l:board_start_raw = len(l:lines) + 1
  let l:board = s:kanban_board_lines_4(l:tasks, l:inner_w)
  call extend(l:lines, l:board.lines)
  call add(l:lines, '')
  call add(l:lines, s:fit('a toggle archived  ⇥/⇧⇥ or ]t/[t move tasks  <Enter> open detail  O open code', l:inner_w))
  call add(l:lines, s:fit('r refresh  b back  q quit', l:inner_w))

  let l:lines = s:panel_wrap(l:lines, l:inner_w)
  let l:lines = s:center_lines(l:lines)
  let l:panel_top = s:panel_top(len(l:lines))
  let l:lines = repeat([''], l:panel_top) + l:lines

  setlocal modifiable
  call setline(1, l:lines)
  setlocal nomodifiable
  normal! gg

  let b:quartz_view = 'knownskanban'
  let b:quartz_include_archived = l:include_archived
  let b:quartz_task_rows = {}
  let b:quartz_task_points = []

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
    let l:seps = []
    let l:pos = match(l:line_text, '│')
    while l:pos >= 0
      call add(l:seps, l:pos)
      let l:pos = match(l:line_text, '│', l:pos + 1)
    endwhile
    if len(l:seps) >= l:cell.col + 1
      let l:start_col = l:seps[l:cell.col - 1] + 2
      call add(b:quartz_task_points, {'line': l:final_line, 'col': l:start_col, 'task': l:cell.task})
    endif
  endfor
  call sort(b:quartz_task_points, {a,b -> (a.line == b.line ? a.col - b.col : a.line - b.line)})

  nnoremap <silent><buffer> q :qa!<CR>
  nnoremap <silent><buffer> b :call <SID>render_dashboard()<CR>
  execute 'nnoremap <silent><buffer> r :call <SID>render_knowns_kanban_view(' . l:include_archived . ')<CR>'
  nnoremap <silent><buffer> a :call <SID>render_knowns_kanban_view(get(b:, "quartz_include_archived", 0) ? 0 : 1)<CR>
  nnoremap <silent><buffer> <CR> :call <SID>open_task_detail_under_cursor()<CR>
  nnoremap <silent><buffer> O :call <SID>open_task_in_code_under_cursor()<CR>
  nnoremap <silent><buffer> <Tab> :call <SID>next_task_point(0)<CR>
  nnoremap <silent><buffer> <S-Tab> :call <SID>next_task_point(1)<CR>
  nnoremap <silent><buffer> ]t :call <SID>next_task_point(0)<CR>
  nnoremap <silent><buffer> [t :call <SID>next_task_point(1)<CR>

  call s:dashboard_highlight()
endfunction

function! s:open_list_task_slot(slot) abort
  if exists('b:quartz_list_index') && has_key(b:quartz_list_index, a:slot)
    call s:render_task_detail(b:quartz_list_index[a:slot].file)
    return
  endif
  if !exists('b:quartz_list_slots') || !has_key(b:quartz_list_slots, a:slot)
    echom 'No task at slot ' . a:slot
    return
  endif
  call s:render_task_detail(b:quartz_list_slots[a:slot].file)
endfunction

function! s:open_list_task_under_cursor() abort
  if !exists('b:quartz_list_index')
    return
  endif
  let l:txt = getline('.')
  let l:m = matchlist(l:txt, '^\s*│\s*\(\d\+\)\s')
  if empty(l:m)
    return
  endif
  let l:idx = str2nr(l:m[1])
  call s:open_list_task_slot(l:idx)
endfunction

function! s:docker_containers(include_all) abort
  if !executable('docker')
    return []
  endif
  let l:base = a:include_all ? 'docker ps -a' : 'docker ps'
  let l:cmd = l:base . " --format '{{.ID}}|{{.Names}}|{{.Image}}|{{.Status}}|{{.State}}|{{.Label \"com.docker.compose.project\"}}|{{.Label \"com.docker.compose.project.working_dir\"}}'"
  let l:rows = systemlist(l:cmd)
  if v:shell_error != 0
    return []
  endif

  let l:out = []
  for l:row in l:rows
    if empty(l:row)
      continue
    endif
    let l:parts = split(l:row, '|', 1)
    while len(l:parts) < 7
      call add(l:parts, '')
    endwhile
    call add(l:out, {
          \ 'id': l:parts[0],
          \ 'name': l:parts[1],
          \ 'image': l:parts[2],
          \ 'status': l:parts[3],
          \ 'state': tolower(l:parts[4]),
          \ 'compose_project': l:parts[5],
          \ 'working_dir': l:parts[6],
          \ })
  endfor
  return l:out
endfunction

function! s:running_docker_containers() abort
  return s:docker_containers(0)
endfunction

function! s:container_matches_project(c, project_path) abort
  let l:sel = fnamemodify(a:project_path, ':p')
  let l:sel_base = tolower(fnamemodify(l:sel, ':t'))
  let l:cwd = get(a:c, 'working_dir', '')
  let l:cwd_norm = empty(l:cwd) ? '' : fnamemodify(l:cwd, ':p')
  if !empty(l:cwd_norm) && (l:cwd_norm ==# l:sel || l:cwd_norm =~# '^' . escape(l:sel, '\'))
    return 1
  endif

  let l:compose = tolower(get(a:c, 'compose_project', ''))
  if !empty(l:compose) && l:compose ==# l:sel_base
    return 1
  endif

  let l:name = tolower(get(a:c, 'name', ''))
  if !empty(l:sel_base) && stridx(l:name, l:sel_base) >= 0
    return 1
  endif
  return 0
endfunction

function! s:project_docker_containers(project, include_all) abort
  let l:all = s:docker_containers(a:include_all)
  let l:out = []
  for l:c in l:all
    if s:container_matches_project(l:c, a:project.path)
      call add(l:out, l:c)
    endif
  endfor
  return l:out
endfunction

function! s:is_supabase_container(c) abort
  let l:name = tolower(get(a:c, 'name', ''))
  let l:image = tolower(get(a:c, 'image', ''))
  let l:proj = tolower(get(a:c, 'compose_project', ''))
  return stridx(l:name, 'supabase') >= 0 || stridx(l:image, 'supabase') >= 0 || stridx(l:proj, 'supabase') >= 0
endfunction

function! s:container_project_text(c) abort
  let l:proj = get(a:c, 'compose_project', '')
  let l:dir = get(a:c, 'working_dir', '')
  if empty(l:proj)
    let l:proj = empty(l:dir) ? '-' : fnamemodify(l:dir, ':t')
  endif
  let l:dir_short = empty(l:dir) ? '-' : fnamemodify(l:dir, ':~')
  return l:proj . ' @ ' . l:dir_short
endfunction

function! s:docker_state_tag(c) abort
  return get(a:c, 'state', '') ==# 'running' ? '[RUNNING]' : '[STOPPED]'
endfunction

function! s:project_docker_summary_lines(project, maxw, max_rows) abort
  let l:containers = s:project_docker_containers(a:project, 1)
  if empty(l:containers)
    return ['(no project containers found)']
  endif

  let l:out = []
  let l:max = min([a:max_rows, len(l:containers)])
  for l:i in range(0, l:max - 1)
    let l:c = l:containers[l:i]
    let l:tag = s:is_supabase_container(l:c) ? '[SUPABASE]' : '[CONTAINER]'
    let l:state = s:docker_state_tag(l:c)
    let l:line = printf('%s %s %s (%s)', l:tag, l:state, l:c.name, l:c.image)
    call add(l:out, s:fit(l:line, a:maxw))
  endfor
  if len(l:containers) > l:max
    call add(l:out, printf('...and %d more', len(l:containers) - l:max))
  endif
  return l:out
endfunction

function! s:open_docker_container(container) abort
  let l:id = get(a:container, 'id', '')
  let l:name = get(a:container, 'name', '')
  if empty(l:id)
    return
  endif
  if executable('open')
    let l:url = 'docker-desktop://dashboard/container/' . l:id
    call system('open ' . shellescape(l:url))
    if v:shell_error == 0
      echom 'Opened container in Docker: ' . l:name
      return
    endif
    call system('open -a Docker')
    echom 'Opened Docker app. Container: ' . l:name
    return
  endif
  echom 'Cannot open Docker Desktop from this environment.'
endfunction

function! s:open_docker_container_slot(slot) abort
  if !exists('b:quartz_docker_index') || !has_key(b:quartz_docker_index, a:slot)
    echom 'No container at slot ' . a:slot
    return
  endif
  call s:open_docker_container(b:quartz_docker_index[a:slot])
endfunction

function! s:open_docker_container_under_cursor() abort
  if !exists('b:quartz_docker_index')
    return
  endif
  let l:txt = getline('.')
  let l:m = matchlist(l:txt, '^\s*│\s*\(\d\+\)\s')
  if empty(l:m)
    return
  endif
  call s:open_docker_container_slot(str2nr(l:m[1]))
endfunction

function! s:open_docker_container_by_prompt() abort
  let l:max = get(b:, 'quartz_docker_max_index', 0)
  if l:max <= 0
    echom 'No containers in current list.'
    return
  endif
  redraw
  let l:raw = trim(input('Container # (1-' . l:max . '): '))
  if empty(l:raw) || l:raw !~# '^\d\+$'
    return
  endif
  call s:open_docker_container_slot(str2nr(l:raw))
endfunction

function! s:start_docker_container(container) abort
  let l:id = get(a:container, 'id', '')
  let l:name = get(a:container, 'name', '')
  if empty(l:id)
    return 0
  endif
  call system('docker start ' . shellescape(l:id) . ' >/dev/null 2>&1')
  if v:shell_error == 0
    echom 'Started container: ' . l:name
    return 1
  endif
  echom 'Failed to start container: ' . l:name
  return 0
endfunction

function! s:start_docker_container_slot() abort
  let l:txt = getline('.')
  let l:m = matchlist(l:txt, '^\s*│\s*\(\d\+\)\s')
  if empty(l:m)
    echom 'Move cursor to a container row.'
    return
  endif
  let l:idx = str2nr(l:m[1])
  if !exists('b:quartz_docker_index') || !has_key(b:quartz_docker_index, l:idx)
    echom 'No container at slot ' . l:idx
    return
  endif
  call s:start_docker_container(b:quartz_docker_index[l:idx])
  call s:render_docker_view()
endfunction

function! s:start_all_project_docker_containers_safe() abort
  let l:p = s:selected_project()
  let l:containers = s:project_docker_containers(l:p, 1)
  if empty(l:containers)
    echom 'No containers found for project ' . l:p.title
    return
  endif

  redraw
  let l:ans = tolower(trim(input('Start all ' . len(l:containers) . ' project containers? [y/N]: ')))
  if l:ans !~# '^y'
    echom 'Cancelled.'
    return
  endif

  let l:started = 0
  let l:failed = 0
  for l:c in l:containers
    if get(l:c, 'state', '') ==# 'running'
      continue
    endif
    if s:start_docker_container(l:c)
      let l:started += 1
    else
      let l:failed += 1
    endif
  endfor
  echom printf('Docker start complete: %d started, %d failed.', l:started, l:failed)
  call s:render_docker_view()
endfunction

function! s:stop_all_docker_containers_safe() abort
  let l:containers = s:running_docker_containers()
  if empty(l:containers)
    echom 'No running Docker containers.'
    return
  endif
  redraw
  let l:ans = tolower(trim(input('Stop all ' . len(l:containers) . ' running containers? [y/N]: ')))
  if l:ans !~# '^y'
    echom 'Cancelled.'
    return
  endif

  let l:stopped = 0
  let l:failed = 0
  for l:c in l:containers
    call system('docker stop -t 10 ' . shellescape(l:c.id) . ' >/dev/null 2>&1')
    if v:shell_error == 0
      let l:stopped += 1
    else
      let l:failed += 1
    endif
  endfor
  echom printf('Docker stop complete: %d stopped, %d failed.', l:stopped, l:failed)
  call s:render_docker_view()
endfunction

function! s:render_docker_view() abort
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nomodifiable nowrap nonumber norelativenumber signcolumn=no
  setlocal foldcolumn=0 nocursorline colorcolumn= nocursorcolumn
  setlocal filetype=quartzdashboard
  setlocal nospell
  setlocal listchars=
  setlocal fillchars=eob:\ 

  let l:p = s:selected_project()
  let l:containers = s:project_docker_containers(l:p, 1)
  let l:content_w = s:content_width()
  let l:inner_w = max([110, l:content_w + 8])

  let l:lines = [
        \ '› Docker',
        \ s:fit('󰡨 Project containers (running + stopped)  |  selected project: ' . l:p.title, l:inner_w),
        \ ''
        \ ]

  call add(l:lines, '┌' . repeat('─', l:inner_w) . '┐')
  call add(l:lines, '│' . s:pad(' #  TAG         NAME                 IMAGE                     STATUS               PROJECT @ DIR', l:inner_w) . '│')
  call add(l:lines, '├' . repeat('─', l:inner_w) . '┤')

  let b:quartz_docker_index = {}
  let l:max_rows = min([30, len(l:containers)])
  let b:quartz_docker_max_index = l:max_rows
  if l:max_rows == 0
    call add(l:lines, '│' . s:pad(' (no project containers found)', l:inner_w) . '│')
  else
    for l:i in range(0, l:max_rows - 1)
      let l:c = l:containers[l:i]
      let l:idx = l:i + 1
      let l:tag = s:is_supabase_container(l:c) ? '[SUPABASE]' : '[CONTAINER]'
      let l:name = s:fit(l:c.name, 20)
      let l:image = s:fit(l:c.image, 24)
      let l:status = s:fit(l:c.status, 18)
      let l:proj = s:fit(s:container_project_text(l:c), 48)
      let l:row = printf(' %2d %-11s %-20s %-24s %-18s %s', l:idx, l:tag, l:name, l:image, l:status, l:proj)
      call add(l:lines, '│' . s:pad(s:fit(l:row, l:inner_w), l:inner_w) . '│')
      let b:quartz_docker_index[l:idx] = l:c
    endfor
  endif
  call add(l:lines, '└' . repeat('─', l:inner_w) . '┘')
  call add(l:lines, '')
  call add(l:lines, s:fit('1-9 quick open in Docker  + open by number  <Enter> open under cursor', l:inner_w))
  call add(l:lines, s:fit('a start selected container  A start all project containers', l:inner_w))
  call add(l:lines, s:fit('k safely stop all running containers  r refresh  b back  q quit', l:inner_w))

  let l:lines = s:panel_wrap(l:lines, l:inner_w)
  let l:lines = s:center_lines(l:lines)
  let l:panel_top = s:panel_top(len(l:lines))
  let l:lines = repeat([''], l:panel_top) + l:lines

  setlocal modifiable
  call setline(1, l:lines)
  setlocal nomodifiable
  normal! gg

  let b:quartz_view = 'docker'

  nnoremap <silent><buffer> q :qa!<CR>
  nnoremap <silent><buffer> b :call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> r :call <SID>render_docker_view()<CR>
  nnoremap <silent><buffer> <CR> :call <SID>open_docker_container_under_cursor()<CR>
  nnoremap <silent><buffer> + :call <SID>open_docker_container_by_prompt()<CR>
  nnoremap <silent><buffer> a :call <SID>start_docker_container_slot()<CR>
  nnoremap <silent><buffer> A :call <SID>start_all_project_docker_containers_safe()<CR>
  nnoremap <silent><buffer> k :call <SID>stop_all_docker_containers_safe()<CR>
  for l:i in range(1, 9)
    execute printf('nnoremap <silent><buffer> %d :call <SID>open_docker_container_slot(%d)<CR>', l:i, l:i)
  endfor

  call s:dashboard_highlight()
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

function! s:kanban_board_lines_4(tasks, total_w) abort
  let l:avail = a:total_w - 5
  let l:w = float2nr(l:avail / 4.0)
  let l:w1 = l:w
  let l:w2 = l:w
  let l:w3 = l:w
  let l:w4 = l:avail - l:w1 - l:w2 - l:w3
  if l:w1 < 18 || l:w2 < 18 || l:w3 < 18 || l:w4 < 18
    let l:w1 = 18
    let l:w2 = 18
    let l:w3 = 18
    let l:w4 = max([18, l:avail - 54])
  endif

  let l:out = []
  let l:cells = []
  let l:top = '┌' . repeat('─', l:w1) . '┬' . repeat('─', l:w2) . '┬' . repeat('─', l:w3) . '┬' . repeat('─', l:w4) . '┐'
  let l:mid = '├' . repeat('─', l:w1) . '┼' . repeat('─', l:w2) . '┼' . repeat('─', l:w3) . '┼' . repeat('─', l:w4) . '┤'
  let l:bot = '└' . repeat('─', l:w1) . '┴' . repeat('─', l:w2) . '┴' . repeat('─', l:w3) . '┴' . repeat('─', l:w4) . '┘'

  call add(l:out, l:top)
  call add(l:out, '│'
        \ . s:pad(' 󰄵 TODO (' . len(a:tasks.todo) . ')', l:w1) . '│'
        \ . s:pad(' 󰔟 IN PROGRESS (' . len(a:tasks.inprog) . ')', l:w2) . '│'
        \ . s:pad(' 󱋭 REVIEW/BLOCKED (' . len(a:tasks.review) . ')', l:w3) . '│'
        \ . s:pad(' 󰄲 DONE (' . len(a:tasks.done) . ')', l:w4) . '│')
  call add(l:out, l:mid)

  let l:rows = max([3, len(a:tasks.todo), len(a:tasks.inprog), len(a:tasks.review), len(a:tasks.done)])
  for l:i in range(0, l:rows - 1)
    let l:t1 = (l:i < len(a:tasks.todo)) ? a:tasks.todo[l:i] : {}
    let l:t2 = (l:i < len(a:tasks.inprog)) ? a:tasks.inprog[l:i] : {}
    let l:t3 = (l:i < len(a:tasks.review)) ? a:tasks.review[l:i] : {}
    let l:t4 = (l:i < len(a:tasks.done)) ? a:tasks.done[l:i] : {}
    let l:c1 = !empty(l:t1) ? ('󰄵 ' . s:fit(l:t1.title, l:w1 - 2)) : ''
    let l:c2 = !empty(l:t2) ? ('󰔟 ' . s:fit(l:t2.title, l:w2 - 2)) : ''
    let l:c3 = !empty(l:t3) ? ('󱋭 ' . s:fit(l:t3.title, l:w3 - 2)) : ''
    let l:c4 = !empty(l:t4) ? ('󰄲 ' . s:fit(l:t4.title, l:w4 - 2)) : ''
    if !empty(l:t1) | call add(l:cells, {'row': l:i, 'col': 1, 'task': l:t1}) | endif
    if !empty(l:t2) | call add(l:cells, {'row': l:i, 'col': 2, 'task': l:t2}) | endif
    if !empty(l:t3) | call add(l:cells, {'row': l:i, 'col': 3, 'task': l:t3}) | endif
    if !empty(l:t4) | call add(l:cells, {'row': l:i, 'col': 4, 'task': l:t4}) | endif
    call add(l:out, '│'
          \ . s:pad(l:c1, l:w1) . '│'
          \ . s:pad(l:c2, l:w2) . '│'
          \ . s:pad(l:c3, l:w3) . '│'
          \ . s:pad(l:c4, l:w4) . '│')
  endfor

  call add(l:out, l:bot)
  return {'lines': l:out, 'cells': l:cells}
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

function! s:stop_running_knowns() abort
  let l:pids = s:knowns_listener_pids()
  if empty(l:pids)
    echom 'No running Knowns server found on :6420.'
    return
  endif

  for l:pid in l:pids
    call s:stop_knowns_pid(l:pid)
  endfor
  echom 'Stopped Knowns listener(s): ' . join(l:pids, ', ')
endfunction

function! s:run_knowns_browser_safe() abort
  call s:stop_other_knowns()
  call s:run_project_bg('knowns browser --no-open')
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

function! s:task_file_under_cursor() abort
  if !exists('b:quartz_task_rows') || empty(b:quartz_task_rows)
    return ''
  endif
  let l:ln = line('.')
  if !has_key(b:quartz_task_rows, l:ln)
    return ''
  endif

  let l:row = b:quartz_task_rows[l:ln]
  let l:board_col = s:cursor_board_col(getline('.'), col('.'))
  if l:board_col > 0 && has_key(l:row, l:board_col)
    return l:row[l:board_col].file
  endif

  for l:c in [1, 2, 3]
    if has_key(l:row, l:c)
      return l:row[l:c].file
    endif
  endfor
  return ''
endfunction

function! s:open_task_detail_under_cursor() abort
  let l:file = s:task_file_under_cursor()
  if empty(l:file)
    return
  endif
  call s:render_task_detail(l:file)
endfunction

function! s:open_task_in_code_under_cursor() abort
  let l:file = s:task_file_under_cursor()
  if empty(l:file)
    return
  endif
  call s:open_task_in_code(l:file)
endfunction

function! s:open_task_slot(slot) abort
  if !exists('b:quartz_task_points') || empty(b:quartz_task_points)
    echom 'No tasks available in board.'
    return
  endif
  if a:slot < 1 || a:slot > len(b:quartz_task_points)
    echom 'Task slot g' . a:slot . ' is empty.'
    return
  endif
  let l:pt = b:quartz_task_points[a:slot - 1]
  call cursor(l:pt.line, l:pt.col)
  call s:render_task_detail(l:pt.task.file)
endfunction

function! s:task_sections(task_file) abort
  let l:lines = filereadable(a:task_file) ? readfile(a:task_file) : []
  if empty(l:lines) || l:lines[0] !=# '---'
    return {'lines': l:lines, 'fm_start': -1, 'fm_end': -1, 'fm': [], 'body': l:lines}
  endif

  let l:end = -1
  for l:i in range(1, len(l:lines) - 1)
    if l:lines[l:i] ==# '---'
      let l:end = l:i
      break
    endif
  endfor
  if l:end < 0
    return {'lines': l:lines, 'fm_start': -1, 'fm_end': -1, 'fm': [], 'body': l:lines}
  endif

  return {
        \ 'lines': l:lines,
        \ 'fm_start': 0,
        \ 'fm_end': l:end,
        \ 'fm': l:lines[1 : l:end - 1],
        \ 'body': l:lines[l:end + 1 :],
        \ }
endfunction

function! s:strip_quotes(val) abort
  let l:v = trim(a:val)
  if (l:v =~# '^".*"$') || (l:v =~# "^'.*'$")
    return l:v[1:-2]
  endif
  return l:v
endfunction

function! s:parse_frontmatter(fm_lines) abort
  let l:meta = {'labels': []}
  let l:i = 0
  while l:i < len(a:fm_lines)
    let l:line = a:fm_lines[l:i]
    if l:line =~# '^\s*labels:\s*$'
      let l:i += 1
      while l:i < len(a:fm_lines) && a:fm_lines[l:i] =~# '^\s*-\s*'
        call add(l:meta.labels, trim(substitute(a:fm_lines[l:i], '^\s*-\s*', '', '')))
        let l:i += 1
      endwhile
      continue
    endif
    let l:m = matchlist(l:line, '^\s*\([^:][^:]*\):\s*\(.*\)$')
    if !empty(l:m)
      let l:key = trim(l:m[1])
      let l:val = s:strip_quotes(l:m[2])
      if l:key !=# 'labels'
        let l:meta[l:key] = l:val
      endif
    endif
    let l:i += 1
  endwhile
  return l:meta
endfunction

function! s:set_frontmatter_value(fm_lines, key, value, quoted) abort
  let l:val = a:quoted ? ('"' . substitute(a:value, '"', '\\"', 'g') . '"') : a:value
  let l:new_line = a:key . ': ' . l:val
  let l:re = '^\s*' . escape(a:key, '\') . ':\s*'

  let l:out = copy(a:fm_lines)
  let l:idx = -1
  for l:i in range(0, len(l:out) - 1)
    if l:out[l:i] =~# l:re
      let l:idx = l:i
      break
    endif
  endfor

  if l:idx >= 0
    let l:out[l:idx] = l:new_line
  else
    call add(l:out, l:new_line)
  endif
  return l:out
endfunction

function! s:task_now_iso() abort
  return strftime('%Y-%m-%dT%H:%M:%SZ', localtime())
endfunction

function! s:write_task_sections(task_file, fm_lines, body_lines) abort
  let l:out = ['---']
  call extend(l:out, a:fm_lines)
  call add(l:out, '---')
  call extend(l:out, a:body_lines)
  call writefile(l:out, a:task_file)
endfunction

function! s:yaml_quoted(text) abort
  let l:v = substitute(a:text, '\\', '\\\\', 'g')
  let l:v = substitute(l:v, '"', '\\"', 'g')
  return '"' . l:v . '"'
endfunction

function! s:task_desc_begin_marker() abort
  return '<!-- SECTION:DESCRIPTION:BEGIN -->'
endfunction

function! s:task_desc_end_marker() abort
  return '<!-- SECTION:DESCRIPTION:END -->'
endfunction

function! s:task_body_with_description(title, description) abort
  let l:body = [
        \ '',
        \ '# ' . a:title,
        \ '',
        \ '## Description',
        \ '',
        \ s:task_desc_begin_marker()
        \ ]
  if !empty(a:description)
    call extend(l:body, split(a:description, "\n", 1))
  endif
  call add(l:body, s:task_desc_end_marker())
  return l:body
endfunction

function! s:task_body_preview(task_file, max_lines) abort
  let l:sec = s:task_sections(a:task_file)
  let l:body = copy(l:sec.body)
  while !empty(l:body) && l:body[0] ==# ''
    call remove(l:body, 0)
  endwhile
  if a:max_lines > 0 && len(l:body) > a:max_lines
    let l:body = l:body[0 : a:max_lines - 1]
    call add(l:body, '')
    call add(l:body, '...(truncated)')
  endif
  return l:body
endfunction

function! s:task_file_all_lines(task_file) abort
  if empty(a:task_file) || !filereadable(a:task_file)
    return []
  endif
  return readfile(a:task_file)
endfunction

function! s:extract_description_from_body(body_lines) abort
  let l:begin = -1
  let l:end = -1
  for l:i in range(0, len(a:body_lines) - 1)
    if a:body_lines[l:i] ==# s:task_desc_begin_marker()
      let l:begin = l:i
    elseif a:body_lines[l:i] ==# s:task_desc_end_marker()
      let l:end = l:i
      break
    endif
  endfor

  if l:begin >= 0 && l:end > l:begin
    return join(a:body_lines[l:begin + 1 : l:end - 1], "\n")
  endif

  let l:desc_lines = copy(a:body_lines)
  if !empty(l:desc_lines) && l:desc_lines[0] =~# '^# '
    call remove(l:desc_lines, 0)
    if !empty(l:desc_lines) && l:desc_lines[0] ==# ''
      call remove(l:desc_lines, 0)
    endif
  endif
  if !empty(l:desc_lines) && l:desc_lines[0] =~# '^##\s\+Description'
    call remove(l:desc_lines, 0)
    if !empty(l:desc_lines) && l:desc_lines[0] ==# ''
      call remove(l:desc_lines, 0)
    endif
  endif
  return join(l:desc_lines, "\n")
endfunction

function! s:update_task_field(task_file, key, value, quoted) abort
  let l:sec = s:task_sections(a:task_file)
  let l:fm = copy(l:sec.fm)
  let l:fm = s:set_frontmatter_value(l:fm, a:key, a:value, a:quoted)
  if a:key !=# 'updatedAt'
    let l:fm = s:set_frontmatter_value(l:fm, 'updatedAt', s:task_now_iso(), 1)
  endif
  call s:write_task_sections(a:task_file, l:fm, l:sec.body)
endfunction

function! s:task_meta(task_file) abort
  let l:sec = s:task_sections(a:task_file)
  let l:meta = s:parse_frontmatter(l:sec.fm)
  let l:body_desc = s:extract_description_from_body(l:sec.body)
  let l:fm_desc = get(l:meta, 'description', '')
  let l:desc = !empty(l:body_desc) ? l:body_desc : l:fm_desc
  return {'meta': l:meta, 'sections': l:sec, 'description': l:desc}
endfunction

function! s:task_timer_state(task_file) abort
  if !exists('g:quartz_task_timer') || type(g:quartz_task_timer) != v:t_dict
    return {'running': 0, 'seconds': 0}
  endif
  if get(g:quartz_task_timer, 'file', '') !=# a:task_file
    return {'running': 0, 'seconds': 0}
  endif
  let l:start = str2nr(get(g:quartz_task_timer, 'start', 0))
  if l:start <= 0
    return {'running': 0, 'seconds': 0}
  endif
  return {'running': 1, 'seconds': max([0, localtime() - l:start])}
endfunction

function! s:format_seconds(total) abort
  let l:t = max([0, str2nr(a:total)])
  let l:h = l:t / 3600
  let l:m = (l:t % 3600) / 60
  let l:s = l:t % 60
  return printf('%02dh %02dm %02ds', l:h, l:m, l:s)
endfunction

function! s:stop_task_timer(file, silent) abort
  if !exists('g:quartz_task_timer') || type(g:quartz_task_timer) != v:t_dict
    return 0
  endif
  if get(g:quartz_task_timer, 'file', '') !=# a:file
    return 0
  endif
  let l:start = str2nr(get(g:quartz_task_timer, 'start', 0))
  if l:start <= 0
    unlet g:quartz_task_timer
    return 0
  endif

  let l:elapsed = max([0, localtime() - l:start])
  let l:info = s:task_meta(a:file)
  let l:current = str2nr(get(l:info.meta, 'timeSpent', '0'))
  call s:update_task_field(a:file, 'timeSpent', string(l:current + l:elapsed), 0)
  unlet g:quartz_task_timer
  if !a:silent
    echom 'Stopped timer: +' . s:format_seconds(l:elapsed)
  endif
  return l:elapsed
endfunction

function! s:toggle_task_timer() abort
  if !exists('b:quartz_task_file') || empty(b:quartz_task_file)
    return
  endif
  let l:file = b:quartz_task_file

  if exists('g:quartz_task_timer') && type(g:quartz_task_timer) == v:t_dict
    let l:running_file = get(g:quartz_task_timer, 'file', '')
    if l:running_file ==# l:file
      call s:stop_task_timer(l:file, 0)
      call s:render_task_detail(l:file)
      return
    elseif !empty(l:running_file)
      call s:stop_task_timer(l:running_file, 1)
    endif
  endif

  let g:quartz_task_timer = {'file': l:file, 'start': localtime()}
  echom 'Timer started.'
  call s:render_task_detail(l:file)
endfunction

function! s:wrap_text_lines(text, width, max_lines) abort
  let l:out = []
  let l:w = max([24, a:width])
  let l:paras = split(a:text, "\n", 1)
  if empty(l:paras)
    return ['(no description)']
  endif
  for l:p in l:paras
    if empty(l:p)
      call add(l:out, '')
      continue
    endif
    let l:rest = l:p
    while strdisplaywidth(l:rest) > l:w
      call add(l:out, strcharpart(l:rest, 0, l:w))
      let l:rest = strcharpart(l:rest, l:w)
    endwhile
    call add(l:out, l:rest)
  endfor
  if empty(l:out)
    let l:out = ['(no description)']
  endif
  if len(l:out) > a:max_lines
    let l:out = l:out[0 : a:max_lines - 1]
    let l:last = l:out[-1]
    let l:out[-1] = s:fit(l:last, l:w - 1) . '…'
  endif
  return l:out
endfunction

function! s:render_task_detail(task_file) abort
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nomodifiable nowrap nonumber norelativenumber signcolumn=no
  setlocal foldcolumn=0 nocursorline colorcolumn= nocursorcolumn
  setlocal filetype=quartzdashboard
  setlocal nospell
  setlocal listchars=
  setlocal fillchars=eob:\ 

  let l:p = s:selected_project()
  let l:info = s:task_meta(a:task_file)
  let l:m = l:info.meta
  let l:title = get(l:m, 'title', fnamemodify(a:task_file, ':t:r'))
  let l:status = get(l:m, 'status', 'todo')
  let l:priority = get(l:m, 'priority', 'medium')
  let l:labels = get(l:m, 'labels', [])
  let l:label_text = empty(l:labels) ? '(none)' : join(l:labels, ', ')
  let l:stored = str2nr(get(l:m, 'timeSpent', '0'))
  let l:timer = s:task_timer_state(a:task_file)
  let l:total = l:stored + l:timer.seconds
  let l:timer_text = l:timer.running ? ('running +' . s:format_seconds(l:timer.seconds)) : 'stopped'
  let l:content_w = s:content_width()
  let l:inner_w = max([90, l:content_w])
  let l:left_w = float2nr((l:inner_w - 3) / 2.0)
  let l:right_w = l:inner_w - 3 - l:left_w

  let l:grid = []
  call add(l:grid, '┌' . repeat('─', l:left_w) . '┬' . repeat('─', l:right_w) . '┐')
  call add(l:grid, '│' . s:pad(' 󰘬 TASK', l:left_w) . '│' . s:pad(' 󰵅 QUICK ACTIONS', l:right_w) . '│')
  call add(l:grid, '├' . repeat('─', l:left_w) . '┼' . repeat('─', l:right_w) . '┤')
  call add(l:grid, '│' . s:pad('Title: ' . s:fit(l:title, l:left_w - 8), l:left_w) . '│' . s:pad('e Edit title', l:right_w) . '│')
  call add(l:grid, '│' . s:pad('Status: ' . l:status, l:left_w) . '│' . s:pad('d Edit description', l:right_w) . '│')
  call add(l:grid, '│' . s:pad('Priority: ' . l:priority, l:left_w) . '│' . s:pad('s Change status', l:right_w) . '│')
  call add(l:grid, '│' . s:pad('Labels: ' . s:fit(l:label_text, l:left_w - 9), l:left_w) . '│' . s:pad('p Change priority', l:right_w) . '│')
  call add(l:grid, '│' . s:pad('Tracked: ' . s:format_seconds(l:total), l:left_w) . '│' . s:pad('t Start/stop timer', l:right_w) . '│')
  call add(l:grid, '│' . s:pad('Timer: ' . l:timer_text, l:left_w) . '│' . s:pad('<Enter> Open in code', l:right_w) . '│')
  call add(l:grid, '└' . repeat('─', l:left_w) . '┴' . repeat('─', l:right_w) . '┘')

  let l:desc_w = l:inner_w
  let l:desc_lines = s:wrap_text_lines(l:info.description, l:desc_w - 2, 12)
  let l:desc_box = []
  call add(l:desc_box, '┌' . repeat('─', l:desc_w) . '┐')
  call add(l:desc_box, '│' . s:pad(' 󰍩 DESCRIPTION', l:desc_w) . '│')
  call add(l:desc_box, '├' . repeat('─', l:desc_w) . '┤')
  for l:ln in l:desc_lines
    call add(l:desc_box, '│' . s:pad(' ' . s:fit(l:ln, l:desc_w - 1), l:desc_w) . '│')
  endfor
  call add(l:desc_box, '└' . repeat('─', l:desc_w) . '┘')

  let l:lines = [
        \ '› Task Detail',
        \ s:fit('󰌢 ' . l:p.title . '  󰈔 ' . fnamemodify(a:task_file, ':~'), l:inner_w),
        \ ''
        \ ]
  call extend(l:lines, l:grid)
  call add(l:lines, '')
  call extend(l:lines, l:desc_box)
  call add(l:lines, '')
  call add(l:lines, s:fit('e title  d desc  s status  p priority  t timer  <Enter>/o open code  r refresh  b back  q quit', l:inner_w))

  let l:lines = s:panel_wrap(l:lines, l:inner_w)
  let l:lines = s:center_lines(l:lines)
  let l:panel_top = s:panel_top(len(l:lines))
  let l:lines = repeat([''], l:panel_top) + l:lines

  setlocal modifiable
  call setline(1, l:lines)
  setlocal nomodifiable
  normal! gg

  let b:quartz_view = 'task'
  let b:quartz_task_file = a:task_file

  nnoremap <silent><buffer> q :qa!<CR>
  nnoremap <silent><buffer> b :call <SID>render_dashboard()<CR>
  execute 'nnoremap <silent><buffer> r :call <SID>render_task_detail(' . string(a:task_file) . ')<CR>'
  nnoremap <silent><buffer> j :call <SID>render_full_kanban_view()<CR>
  nnoremap <silent><buffer> K :call <SID>render_knowns_kanban_view(0)<CR>
  nnoremap <silent><buffer> , :call <SID>stop_running_knowns()<CR>
  nnoremap <silent><buffer> <CR> :call <SID>open_task_in_code(b:quartz_task_file)<CR>
  nnoremap <silent><buffer> o :call <SID>open_task_in_code(b:quartz_task_file)<CR>
  nnoremap <silent><buffer> e :call <SID>edit_task_title()<CR>
  nnoremap <silent><buffer> d :call <SID>edit_task_description()<CR>
  nnoremap <silent><buffer> s :call <SID>edit_task_status()<CR>
  nnoremap <silent><buffer> p :call <SID>edit_task_priority()<CR>
  nnoremap <silent><buffer> t :call <SID>toggle_task_timer()<CR>

  call s:dashboard_highlight()
endfunction

function! s:edit_task_title() abort
  if !exists('b:quartz_task_file') || empty(b:quartz_task_file)
    return
  endif
  let l:file = b:quartz_task_file
  let l:info = s:task_meta(l:file)
  let l:current = get(l:info.meta, 'title', fnamemodify(l:file, ':t:r'))
  redraw
  let l:new = trim(input('Title: ', l:current))
  if empty(l:new) || l:new ==# l:current
    call s:render_task_detail(l:file)
    return
  endif

  let l:fm = s:set_frontmatter_value(l:info.sections.fm, 'title', l:new, 1)
  let l:fm = s:set_frontmatter_value(l:fm, 'updatedAt', s:task_now_iso(), 1)
  let l:body = s:task_body_with_description(l:new, l:info.description)
  call s:write_task_sections(l:file, l:fm, l:body)
  call s:render_task_detail(l:file)
endfunction

function! s:edit_task_description() abort
  if !exists('b:quartz_task_file') || empty(b:quartz_task_file)
    return
  endif
  let l:file = b:quartz_task_file
  let l:info = s:task_meta(l:file)
  redraw
  let l:new = input('Description (single line): ', l:info.description)

  let l:title = get(l:info.meta, 'title', fnamemodify(l:file, ':t:r'))
  let l:body = s:task_body_with_description(l:title, l:new)
  let l:fm = copy(l:info.sections.fm)
  let l:fm = s:set_frontmatter_value(l:fm, 'updatedAt', s:task_now_iso(), 1)
  call s:write_task_sections(l:file, l:fm, l:body)
  call s:render_task_detail(l:file)
endfunction

function! s:edit_task_status() abort
  if !exists('b:quartz_task_file') || empty(b:quartz_task_file)
    return
  endif
  let l:file = b:quartz_task_file
  let l:info = s:task_meta(l:file)
  let l:opts = ['todo', 'in-progress', 'in-review', 'done']
  let l:current = tolower(get(l:info.meta, 'status', 'todo'))
  let l:default_idx = index(l:opts, l:current) + 1
  if l:default_idx <= 0
    let l:default_idx = 1
  endif
  let l:pick = s:prompt_choice('Status', l:opts, l:default_idx)
  if l:pick <= 0
    call s:render_task_detail(l:file)
    return
  endif
  call s:update_task_field(l:file, 'status', l:opts[l:pick - 1], 0)
  call s:render_task_detail(l:file)
endfunction

function! s:edit_task_priority() abort
  if !exists('b:quartz_task_file') || empty(b:quartz_task_file)
    return
  endif
  let l:file = b:quartz_task_file
  let l:info = s:task_meta(l:file)
  let l:opts = ['high', 'medium', 'low']
  let l:current = tolower(get(l:info.meta, 'priority', 'medium'))
  let l:default_idx = index(l:opts, l:current) + 1
  if l:default_idx <= 0
    let l:default_idx = 2
  endif
  let l:pick = s:prompt_choice('Priority', l:opts, l:default_idx)
  if l:pick <= 0
    call s:render_task_detail(l:file)
    return
  endif
  call s:update_task_field(l:file, 'priority', l:opts[l:pick - 1], 0)
  call s:render_task_detail(l:file)
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

function! s:ensure_unique_task_path(tasks_dir, task_id, title) abort
  let l:id = a:task_id
  let l:slug = s:slugify_title(a:title)
  let l:path = a:tasks_dir . '/task-' . l:id . ' - ' . l:slug . '.md'
  while filereadable(l:path)
    let l:id = s:random_id(6)
    let l:path = a:tasks_dir . '/task-' . l:id . ' - ' . l:slug . '.md'
  endwhile
  return {'id': l:id, 'path': l:path}
endfunction

function! s:task_id_from_task_file(task_file) abort
  let l:name = fnamemodify(a:task_file, ':t')
  let l:m = matchlist(l:name, '^task-\([a-z0-9]\+\)\s\+-')
  if !empty(l:m)
    return l:m[1]
  endif
  return s:legacy_task_id_from_file(a:task_file)
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

function! s:render_task_mentions_picker(project, tasks, query, selected_files, note) abort
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal nomodifiable nowrap nonumber norelativenumber signcolumn=no
  setlocal foldcolumn=0 nocursorline colorcolumn= nocursorcolumn
  setlocal filetype=quartzdashboard
  setlocal nospell
  setlocal listchars=
  setlocal fillchars=eob:\ 

  let l:filtered = s:filter_tasks(a:tasks, a:query)
  let l:content_w = s:content_width()
  let l:inner_w = max([100, l:content_w])
  let l:list_w = l:inner_w

  let l:selected_count = len(keys(a:selected_files))
  let l:lines = [
        \ '› Mention Tasks',
        \ s:fit('󰌢 ' . a:project.title . '  󰈔 ' . a:project.path, l:inner_w),
        \ ''
        \ ]

  call add(l:lines, '┌' . repeat('─', l:list_w) . '┐')
  call add(l:lines, '│' . s:pad(' #  PICK  STATUS            TITLE', l:list_w) . '│')
  call add(l:lines, '│' . s:pad(' Filter="' . a:query . '"  Matches=' . len(l:filtered) . '/' . len(a:tasks) . '  Selected=' . l:selected_count, l:list_w) . '│')
  if l:selected_count > 0
    let l:selected_ids = []
    for l:t in a:tasks
      let l:f = get(l:t, 'file', '')
      if has_key(a:selected_files, l:f)
        let l:id = get(l:t, 'id', '')
        call add(l:selected_ids, empty(l:id) ? fnamemodify(l:f, ':t:r') : l:id)
      endif
    endfor
    call add(l:lines, '│' . s:pad(' Selected IDs: ' . join(l:selected_ids, ', '), l:list_w) . '│')
  endif
  call add(l:lines, '├' . repeat('─', l:list_w) . '┤')

  let b:quartz_mention_index = {}
  let l:max_rows = min([25, len(l:filtered)])
  let b:quartz_mention_max_index = l:max_rows
  if l:max_rows == 0
    call add(l:lines, '│' . s:pad(' (no tasks match current search)', l:list_w) . '│')
  else
    for l:i in range(0, l:max_rows - 1)
      let l:t = l:filtered[l:i]
      let l:idx = l:i + 1
      let l:file = get(l:t, 'file', '')
      let l:mark = has_key(a:selected_files, l:file) ? '[x]' : '[ ]'
      let l:status = s:status_label(get(l:t, 'status', ''))
      let l:id = get(l:t, 'id', '')
      let l:suffix = empty(l:id) ? '' : ' [' . l:id . ']'
      let l:row = printf(' %2d  %-4s %-18s %s%s', l:idx, l:mark, l:status, l:t.title, l:suffix)
      call add(l:lines, '│' . s:pad(s:fit(l:row, l:list_w), l:list_w) . '│')
      let b:quartz_mention_index[l:idx] = l:t
    endfor
  endif
  call add(l:lines, '└' . repeat('─', l:list_w) . '┘')
  call add(l:lines, '')
  call add(l:lines, s:fit('Type to filter live. 1-9 quick toggle, p pick row # (+ alias). <BS> delete. <Esc> clear. <CR> continue.', l:inner_w))
  if !empty(a:note)
    call add(l:lines, s:fit('Note: ' . a:note, l:inner_w))
  endif

  let l:lines = s:panel_wrap(l:lines, l:inner_w)
  let l:lines = s:center_lines(l:lines)
  let l:panel_top = s:panel_top(len(l:lines))
  let l:lines = repeat([''], l:panel_top) + l:lines

  setlocal modifiable
  call setline(1, l:lines)
  if line('$') > len(l:lines)
    execute (len(l:lines) + 1) . ',$delete _'
  endif
  setlocal nomodifiable
  normal! gg

  let b:quartz_view = 'mentionpick'
  let b:quartz_mention_query = a:query
  call s:dashboard_highlight()
endfunction

function! s:prompt_task_mentions(project, tasks) abort
  let l:selected = []
  let l:selected_files = {}
  if empty(a:tasks)
    return l:selected
  endif

  let l:query = ''
  let l:note = ''
  while 1
    call s:render_task_mentions_picker(a:project, a:tasks, l:query, l:selected_files, l:note)
    let l:note = ''

    redraw
    echo 'Mention search: ' . l:query . '   (type filter, 1-9 toggle, p pick #, <Esc> clear, <CR> done, <BS> delete)'
    let l:ch = getcharstr()

    if l:ch ==# "\<CR>"
      if empty(l:selected)
        redraw
        let l:confirm = tolower(trim(input('No tickets selected. Create page without ticket context? [y/N]: ')))
        if l:confirm !~# '^y'
          let l:note = 'Pick at least one ticket (press 1-9 or p) or confirm explicit skip.'
          continue
        endif
      endif
      break
    endif
    if l:ch ==# "\<Esc>"
      let l:query = ''
      continue
    endif
    if l:ch ==# "\<BS>" || l:ch ==# "\<Del>" || l:ch ==# nr2char(127)
      if strchars(l:query) > 0
        let l:query = strcharpart(l:query, 0, strchars(l:query) - 1)
      endif
      continue
    endif
    if l:ch ==# 'p' || l:ch ==# '+'
      let l:max = get(b:, 'quartz_mention_max_index', 0)
      if l:max <= 0
        let l:note = 'No rows available to pick.'
        continue
      endif
      redraw
      let l:raw = trim(input('Toggle row # (1-' . l:max . '): '))
      if l:raw !~# '^\d\+$'
        let l:note = 'Invalid row number.'
        continue
      endif
      let l:n = str2nr(l:raw)
      if l:n < 1 || l:n > l:max || !has_key(b:quartz_mention_index, l:n)
        let l:note = 'Row out of range.'
        continue
      endif

      let l:task = copy(b:quartz_mention_index[l:n])
      let l:file = get(l:task, 'file', '')
      if has_key(l:selected_files, l:file)
        call remove(l:selected_files, l:file)
        for l:i in range(0, len(l:selected) - 1)
          if get(l:selected[l:i], 'file', '') ==# l:file
            call remove(l:selected, l:i)
            break
          endif
        endfor
        let l:note = 'Removed: ' . get(l:task, 'title', '')
      else
        let l:selected_files[l:file] = 1
        call add(l:selected, l:task)
        let l:note = 'Added: ' . get(l:task, 'title', '')
      endif
      continue
    endif
    if l:ch =~# '^[1-9]$'
      let l:n = str2nr(l:ch)
      let l:max = get(b:, 'quartz_mention_max_index', 0)
      if l:n > l:max || !has_key(b:quartz_mention_index, l:n)
        let l:note = 'Row out of range.'
        continue
      endif
      let l:task = copy(b:quartz_mention_index[l:n])
      let l:file = get(l:task, 'file', '')
      if has_key(l:selected_files, l:file)
        call remove(l:selected_files, l:file)
        for l:i in range(0, len(l:selected) - 1)
          if get(l:selected[l:i], 'file', '') ==# l:file
            call remove(l:selected, l:i)
            break
          endif
        endfor
        let l:note = 'Removed: ' . get(l:task, 'title', '')
      else
        let l:selected_files[l:file] = 1
        call add(l:selected, l:task)
        let l:note = 'Added: ' . get(l:task, 'title', '')
      endif
      continue
    endif
    if l:ch =~# '^[[:print:]]$'
      let l:query .= l:ch
    endif
  endwhile

  redraw
  return l:selected
endfunction

function! s:create_project() abort
  redraw
  let l:title = trim(input('Project name: '))
  if empty(l:title)
    call s:render_dashboard()
    return
  endif

  let l:existing = index(map(copy(s:projects()), {_, p -> tolower(get(p, 'title', ''))}), tolower(l:title))
  if l:existing >= 0
    echom 'Project already exists: ' . l:title
    call s:render_dashboard()
    return
  endif

  let l:default_path = getcwd()
  let l:path = trim(input('Project path: ', l:default_path))
  if empty(l:path)
    call s:render_dashboard()
    return
  endif
  let l:path = fnamemodify(l:path, ':p')
  if !isdirectory(l:path)
    redraw
    let l:mk = tolower(trim(input('Path not found. Create it? [y/N]: ')))
    if l:mk !~# '^y'
      call s:render_dashboard()
      return
    endif
    call mkdir(l:path, 'p')
  endif

  redraw
  let l:parent = trim(input('Parent category (optional): '))

  let l:color_options = ['Sky Blue', 'Amber', 'Green', 'Rose', 'Violet', 'Slate']
  let l:color_vals = ['#7dcfff', '#f6c177', '#9ece6a', '#f7768e', '#bb9af7', '#8f95b3']
  let l:pick = s:prompt_choice('Color', l:color_options, 1)
  if l:pick <= 0
    call s:render_dashboard()
    return
  endif

  let l:new_project = {
        \ 'title': l:title,
        \ 'path': l:path,
        \ 'parent': l:parent,
        \ 'color': l:color_vals[l:pick - 1],
        \ }
  call add(g:quartz_projects, l:new_project)
  call mkdir(l:path . '/.knowns/tasks', 'p')
  let g:quartz_selected_project = len(g:quartz_projects)
  call s:save_projects()
  call s:render_dashboard()
endfunction

function! s:create_vault_task_with_mentions() abort
  let l:project_labels = map(copy(s:projects()), {_, p -> p.title})
  let l:pick = s:prompt_choice('Project', l:project_labels, s:selected_index())
  if l:pick <= 0 || l:pick > len(s:projects())
    call s:render_dashboard()
    return
  endif

  let g:quartz_selected_project = l:pick
  let l:project = s:selected_project()

  let l:mention_pool = []
  for l:t in s:project_tasks_all(l:project)
    let l:item = copy(l:t)
    let l:item.id = s:task_id_from_task_file(get(l:t, 'file', ''))
    call add(l:mention_pool, l:item)
  endfor
  let l:mentions = s:prompt_task_mentions(l:project, l:mention_pool)

  redraw
  let l:title = trim(input('Page title: '))
  if empty(l:title)
    call s:render_dashboard()
    return
  endif

  redraw
  let l:desc = input('Page notes (optional): ')

  let l:project_dir = s:slugify_title(l:project.title)
  let l:pages_dir = s:vault_root() . 'content/Operations/Pages/' . l:project_dir
  if !isdirectory(l:pages_dir)
    call mkdir(l:pages_dir, 'p')
  endif

  let l:slug = s:slugify_title(l:title)
  let l:base = strftime('%Y-%m-%d') . ' - ' . l:slug
  let l:file = l:pages_dir . '/' . l:base . '.md'
  let l:suffix = 2
  while filereadable(l:file)
    let l:file = l:pages_dir . '/' . l:base . ' (' . l:suffix . ').md'
    let l:suffix += 1
  endwhile

  let l:now = strftime('%Y-%m-%dT%H:%M:%SZ', localtime())
  let l:lines = [
        \ '---',
        \ 'title: ' . s:yaml_quoted(l:title),
        \ 'type: page',
        \ 'project: ' . s:yaml_quoted(l:project.title),
        \ 'projectPath: ' . s:yaml_quoted(l:project.path)
        \ ]
  if !empty(l:mentions)
    let l:mention_ids = []
    for l:m in l:mentions
      let l:mention_id = get(l:m, 'id', '')
      if empty(l:mention_id)
        let l:mention_id = fnamemodify(get(l:m, 'file', ''), ':t:r')
      endif
      call add(l:mention_ids, l:mention_id)
    endfor
    call add(l:lines, 'mentions:')
    for l:mention_id in l:mention_ids
      call add(l:lines, '  - ' . s:yaml_quoted(l:mention_id))
    endfor
    call add(l:lines, 'ticketIds:')
    for l:mention_id in l:mention_ids
      call add(l:lines, '  - ' . s:yaml_quoted(l:mention_id))
    endfor
  endif
  call extend(l:lines, [
        \ "createdAt: '" . l:now . "'",
        \ "updatedAt: '" . l:now . "'",
        \ '---'
        \ ])

  let l:body = [
        \ '',
        \ '# ' . l:title
        \ ]
  if !empty(l:desc)
    call add(l:body, '')
    call add(l:body, '## Notes')
    call add(l:body, '')
    call extend(l:body, split(l:desc, "\n", 1))
  endif
  if !empty(l:mentions)
    call add(l:body, '')
    call add(l:body, '## Mentioned Tasks')
    call add(l:body, '')
    for l:m in l:mentions
      let l:mention_id = get(l:m, 'id', '')
      let l:suffix = empty(l:mention_id) ? '' : ' [' . l:mention_id . ']'
      call add(l:body, '- ' . s:status_label(get(l:m, 'status', '')) . ' ' . get(l:m, 'title', '') . l:suffix)
    endfor
    call add(l:body, '')
    call add(l:body, '## Knowns Ticket Context And Content')
    call add(l:body, '')
    for l:m in l:mentions
      let l:mention_id = get(l:m, 'id', '')
      let l:suffix = empty(l:mention_id) ? '' : ' [' . l:mention_id . ']'
      let l:source = get(l:m, 'file', '')
      let l:info = s:task_meta(l:source)
      let l:meta = get(l:info, 'meta', {})
      let l:raw = s:task_file_all_lines(l:source)
      call add(l:body, '### ' . get(l:m, 'title', '') . l:suffix)
      call add(l:body, '- Ticket ID: ' . (empty(l:mention_id) ? 'unknown' : l:mention_id))
      call add(l:body, '- Status: ' . get(l:m, 'status', 'unknown'))
      if has_key(l:meta, 'priority')
        call add(l:body, '- Priority: ' . get(l:meta, 'priority', ''))
      endif
      if has_key(l:meta, 'labels') && type(l:meta.labels) == v:t_list && !empty(l:meta.labels)
        call add(l:body, '- Labels: ' . join(l:meta.labels, ', '))
      endif
      call add(l:body, '- Source: `' . l:source . '`')
      call add(l:body, '')
      call add(l:body, '#### Full Ticket File')
      call add(l:body, '')
      if empty(l:raw)
        call add(l:body, '_No ticket content found._')
      else
        call add(l:body, '```markdown')
        for l:line in l:raw
          call add(l:body, l:line)
        endfor
        call add(l:body, '```')
      endif
      call add(l:body, '')
    endfor
  endif
  call extend(l:lines, l:body)

  call writefile(l:lines, l:file)
  let l:rel = substitute(fnamemodify(l:file, ':p'), '^' . escape(s:vault_root(), '\'), '', '')
  let l:rel = substitute(l:rel, '^/', '', '')
  call s:open_obsidian(l:rel)
  echom 'Created vault page: ' . l:title . ' -> ' . l:rel
  call s:render_dashboard()
  redraw
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

  let l:id_info = s:ensure_unique_task_path(l:tasks_dir, s:random_id(6), l:title)
  let l:id = l:id_info.id
  let l:file = l:id_info.path
  let l:now = strftime('%Y-%m-%dT%H:%M:%SZ', localtime())
  let l:lines = [
        \ '---',
        \ 'id: ' . l:id,
        \ 'title: ' . s:yaml_quoted(l:title),
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
        \ '---'
        \ ])
  call extend(l:lines, s:task_body_with_description(l:title, l:desc))

  call writefile(l:lines, l:file)
  echom 'Created task: ' . l:title . ' [' . l:id . ']'
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

function! s:open_knowns_in_new_terminal_tab() abort
  let l:p = s:selected_project()
  call s:stop_other_knowns()

  if executable('osascript')
    let l:cmd = 'cd ' . shellescape(l:p.path) . ' && knowns browser --no-open'
    let l:term_program = tolower($TERM_PROGRAM)

    if l:term_program =~# 'warp'
      " Warp has no stable do-script API; use UI scripting to create a tab and run command.
      let l:script = [
            \ 'tell application "Warp" to activate',
            \ 'tell application "System Events"',
            \ '  tell process "Warp"',
            \ '    keystroke "t" using command down',
            \ '    delay 0.12',
            \ '    keystroke ' . string(l:cmd),
            \ '    key code 36',
            \ '  end tell',
            \ 'end tell'
            \ ]
      let l:osa = 'osascript'
      for l:line in l:script
        let l:osa .= ' -e ' . shellescape(l:line)
      endfor
      let l:out = system(l:osa)
      if v:shell_error == 0
        echom 'Opened Knowns in new Warp tab [' . l:p.title . ']'
        return
      endif
      if executable('open')
        let l:open_out = system('open -na Warp')
        if v:shell_error == 0
          echom 'Warp tab automation failed; opened new Warp window instead.'
          echom 'Launching Knowns in background for [' . l:p.title . ']'
          call s:run_project_bg('knowns browser --no-open')
          return
        endif
        echohl ErrorMsg
        echom 'Failed to open Warp tab/window (System Events permission may be required).'
        if !empty(l:out)
          echom substitute(l:out, '\n\+$', '', '')
        endif
        if !empty(l:open_out)
          echom substitute(l:open_out, '\n\+$', '', '')
        endif
        echohl None
      else
        echohl ErrorMsg
        echom 'Failed to open Warp tab (System Events permission may be required).'
        if !empty(l:out)
          echom substitute(l:out, '\n\+$', '', '')
        endif
        echohl None
      endif
    else
      let l:script = [
            \ 'tell application "Terminal"',
            \ '  activate',
            \ '  if (count of windows) = 0 then',
            \ '    do script ' . string(l:cmd),
            \ '  else',
            \ '    tell front window',
            \ '      do script ' . string(l:cmd) . ' in selected tab',
            \ '    end tell',
            \ '  end if',
            \ 'end tell'
            \ ]
      let l:osa = 'osascript'
      for l:line in l:script
        let l:osa .= ' -e ' . shellescape(l:line)
      endfor
      let l:out = system(l:osa)
      if v:shell_error == 0
        echom 'Opened Knowns in new terminal tab [' . l:p.title . ']'
        return
      endif
      echohl ErrorMsg
      echom 'Failed to open terminal tab for Knowns.'
      if !empty(l:out)
        echom substitute(l:out, '\n\+$', '', '')
      endif
      echohl None
    endif
  endif

  " Fallback: background launch in selected project
  echom 'Falling back to background Knowns launch in current environment.'
  call s:run_project_bg('knowns browser --no-open')
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

  let l:groups = {}
  let l:group_order = []
  for l:i in range(1, len(s:projects()))
    let l:proj = s:projects()[l:i - 1]
    let l:parent = trim(get(l:proj, 'parent', ''))
    let l:group = empty(l:parent) ? 'Independent' : l:parent
    if !has_key(l:groups, l:group)
      let l:groups[l:group] = []
      call add(l:group_order, l:group)
    endif
    call add(l:groups[l:group], {'idx': l:i, 'project': l:proj})
  endfor

  if index(l:group_order, 'Star Sailors') >= 0
    call remove(l:group_order, index(l:group_order, 'Star Sailors'))
    let l:group_order = ['Star Sailors'] + l:group_order
  endif

  let l:lines = ['› Projects']
  for l:g in l:group_order
    call add(l:lines, '  ' . l:g)
    let l:row = ''
    for l:item in l:groups[l:g]
      let l:seg = ((s:selected_index() == l:item.idx) ? '󰄬 ' : '  ') . l:item.idx . ' ' . l:item.project.title
      if empty(l:row)
        let l:row = l:seg
      elseif strdisplaywidth(l:row . '    ' . l:seg) <= l:content_w
        let l:row .= '    ' . l:seg
      else
        call add(l:lines, l:row)
        let l:row = l:seg
      endif
    endfor
    if !empty(l:row)
      call add(l:lines, l:row)
    endif
  endfor
  call add(l:lines, '')
  call add(l:lines, '› Active')
  call add(l:lines, s:fit('󰌢 ' . l:p.title . '  ' . l:p.path, l:content_w))
  call add(l:lines, '')
  call add(l:lines, '› Status')
  call add(l:lines, s:kanban_status_line())
  call add(l:lines, '')
  let l:parent_label = trim(get(l:p, 'parent', ''))
  if !empty(l:parent_label)
    call add(l:lines, s:fit('› Task Board  [' . l:parent_label . ' / ' . l:p.title . ']', l:content_w))
  else
    call add(l:lines, s:fit('› Task Board  [' . l:p.title . ']', l:content_w))
  endif

  let l:board_start_raw = len(l:lines) + 1
  let l:board = s:kanban_board_lines(l:tasks, l:content_w)
  call extend(l:lines, l:board.lines)

  call add(l:lines, '')
  call add(l:lines, '› Docker (Project)')
  for l:dc in s:project_docker_summary_lines(l:p, l:content_w, 99)
    call add(l:lines, l:dc)
  endfor

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
  call add(l:lines, s:fit("󰱼 f Search files  󰈞 o Open code  x Project env  󰙯 k Kanban(run headless)  󰎔 n New task  󰧮 r Refresh", l:content_w))
  call add(l:lines, s:fit('󰎔 P New vault page (task context)  󰐕 C New project', l:content_w))
  call add(l:lines, s:fit('󰙯 j Full kanban  K Knowns board  󰡨 d Docker  󰖟 h Knowns(new tab)  󰖟 l Task list', l:content_w))
  call add(l:lines, s:fit(', Stop Knowns', l:content_w))
  call add(l:lines, s:fit('󰅚 q Quit', l:content_w))
  call add(l:lines, s:fit('⏎ task view  O open in code', l:content_w))
  call add(l:lines, s:fit('⇥/⇧⇥ or ]t/[t move tasks, g1..g9 open board slots directly', l:content_w))

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

  call s:bind_dashboard_keys()

  for l:i in range(1, len(s:projects()))
    execute printf('nnoremap <silent><buffer> %d :call <SID>set_project(%d)<CR>', l:i, l:i)
  endfor
  for l:i in range(1, 9)
    execute printf('nnoremap <silent><buffer> g%d :call <SID>open_task_slot(%d)<CR>', l:i, l:i)
  endfor

  call s:dashboard_highlight()
endfunction

function! s:bind_dashboard_keys() abort
  if &filetype !=# 'quartzdashboard'
    return
  endif
  nnoremap <silent><buffer> q :qa!<CR>
  nnoremap <silent><buffer> b :BackDashboard<CR>
  nnoremap <silent><buffer> r :call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> f :call <SID>search_vault_file()<CR>
  silent! nunmap <buffer> ;
  nnoremap <silent><buffer> x :call <SID>open_project_env()<CR>
  nnoremap <silent><buffer> ' :call <SID>open_project_env()<CR>
  nnoremap <silent><buffer> E :call <SID>open_project_env()<CR>
  nnoremap <silent><buffer> e :call <SID>open_project_env()<CR>
  nnoremap <silent><buffer> o :call <SID>run_project_bg('code .')<CR>:call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> k :call <SID>run_knowns_browser_safe()<CR>
  nnoremap <silent><buffer> j :call <SID>render_full_kanban_view()<CR>
  nnoremap <silent><buffer> K :call <SID>render_knowns_kanban_view(0)<CR>
  nnoremap <silent><buffer> d :call <SID>render_docker_view()<CR>
  nnoremap <silent><buffer> n :call <SID>create_knowns_task()<CR>
  nnoremap <silent><buffer> P :call <SID>create_vault_task_with_mentions()<CR>
  nnoremap <silent><buffer> C :call <SID>create_project()<CR>
  nnoremap <silent><buffer> M :call <SID>migrate_project_legacy_tasks()<CR>:call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> , :call <SID>stop_running_knowns()<CR>:call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> <CR> :call <SID>open_task_detail_under_cursor()<CR>
  nnoremap <silent><buffer> O :call <SID>open_task_in_code_under_cursor()<CR>
  nnoremap <silent><buffer> <Tab> :call <SID>next_task_point(0)<CR>
  nnoremap <silent><buffer> <S-Tab> :call <SID>next_task_point(1)<CR>
  nnoremap <silent><buffer> ]t :call <SID>next_task_point(0)<CR>
  nnoremap <silent><buffer> [t :call <SID>next_task_point(1)<CR>
  nnoremap <silent><buffer> u :call <SID>run_make_up()<CR>:call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> h :call <SID>open_knowns_in_new_terminal_tab()<CR>:call <SID>render_dashboard()<CR>
  nnoremap <silent><buffer> l :call <SID>render_task_list_view('', 'all')<CR>
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
  syntax match QuartzDashAccent /^\s\{2}[A-Za-z].*$/
  syntax match QuartzDashTodo /󰄵[^│]*/
  syntax match QuartzDashProg /󰔟[^│]*/
  syntax match QuartzDashReview /󱋭[^│]*/
  syntax match QuartzDashRun /󰄲[^│]*/
  syntax match QuartzDashTodo /\[TODO\]/
  syntax match QuartzDashProg /\[IN PROGRESS\]/
  syntax match QuartzDashReview /\[REVIEW\]/
  syntax match QuartzDashReview /\[BLOCKED\]/
  syntax match QuartzDashMuted /\[OTHER\]/
  syntax match QuartzDashRun /\[SUPABASE\]/
  syntax match QuartzDashRun /\[RUNNING\]/
  syntax match QuartzDashMuted /\[STOPPED\]/
  syntax match QuartzDashMuted /\[CONTAINER\]/
  syntax match QuartzDashRun /\[DONE\]/
  syntax match QuartzDashRun /Kanban:\s.*running$/

  let l:idx = 1
  for l:p in s:projects()
    let l:g = 'QuartzProject' . l:idx
    let l:hex = get(l:p, 'color', '#dcd7ba')
    execute 'highlight ' . l:g . ' guifg=' . l:hex . ' guibg=#1f2335 ctermfg=252 ctermbg=235'
    execute 'syntax match ' . l:g . ' /' . escape(l:p.title, '/\') . '/'
    let l:idx += 1
  endfor
endfunction

command! QuartzDashboard call <SID>render_dashboard()
command! BackDashboard QuartzDashboard
command! QuartzDashboardReload let g:quartz_dashboard_force_reload = 1 | execute 'source ' . fnameescape(expand('~/Navigation/quartz/.vim/quartz-dashboard.vim')) | BackDashboard
command! ProjectEnv call <SID>open_project_env()

nnoremap <silent> <leader>b :BackDashboard<CR>
nnoremap <silent> <F2> :BackDashboard<CR>

augroup QuartzDashboard
  autocmd!
  autocmd VimEnter * if argc() == 0 && &buftype ==# '' | call s:render_dashboard() | endif
  autocmd VimResized * if &filetype ==# 'quartzdashboard' | call s:render_dashboard() | endif
  autocmd FileType quartzdashboard call s:bind_dashboard_keys()
augroup END
