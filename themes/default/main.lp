<% local app_name = require 'conf.conf'.sailor.app_name %>
<% local access = require('sailor.access') %>
<% local User = require('sailor.model')('user') %>
<!doctype html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/@picocss/pico@latest/css/pico.min.css" crossorigin="anonymous">
    <title><%=page.title%></title>
  </head>
  <body>

    <% if not access.is_guest() then %>
      <nav class="container-fluid">
        <ul>
          <li><a href="<%= page:make_url('bookmark/index') %>" class="contrast"><strong><%= app_name %></strong></a></li>
        </ul>
        <ul>
          <li><a href="<%= page:make_url('bookmark/index') %>" class="contrast">Bookmarks</a></li>
          <li><a href="<%= page:make_url('tag/index') %>" class="contrast">Tags</a></li>
          <% local user = User:find_by_id(access.data.id) %>
          <% if user.role.name == 'admin' then %>
            <li><a href="<%= page:make_url('user/index') %>" class="contrast">Users</a></li>
          <% end %>
          <li>
            <details role="list" dir="rtl">
              <summary aria-haspopup="listbox" role="link" class="secondary"><%= access.data.login %></summary>
              <ul role="listbox">
                <li><a href="<%= page:make_url('settings/view') %>">Settings</a></li>
                <li><a href="<%= page:make_url('user/logout') %>">Logout</a></li>
              </ul>
            </details>
          </li>
        </ul>
      </nav>
    <% end %>

    <main class="container">
      {{content}}
    </main>

    <footer class="container">
      <hr>
      <p>
        <small>
          Copyright &copy; <%= os.date('%Y') %>
          <a href="https://github.com/ricardogj08/lualinks" target="_blank" class="secondary"><%= app_name %></a> by
          <a href="https://github.com/ricardogj08" target="_blank" class="secondary">Ricardo García Jiménez</a>.
          &#9889; Powered by &#127959; <a href="https://picocss.com/" target="_blank" class="secondary">pico.css</a>,
          &#127769; <a href="https://github.com/sailorproject/sailor" target="_blank" class="secondary">Sailor MVC</a> and
          <a href="https://www.lua.org/" target="_blank" class="secondary">Lua</a>.
        </small>
      </p>
    </footer>
    <script src="https://unpkg.com/@picocss/pico@latest/docs/js/modal.min.js" crossorigin="anonymous"></script>
  </body>
</html>
