<% page:include('views/components/header') %>
<nav class="container-fluid">
  <ul>
    <li><a href="<%= page:make_url('bookmark/index') %>" class="contrast"><strong>lualinks</strong></a></li>
  </ul>
  <ul>
    <li><a href="<%= page:make_url('bookmark/index') %>" class="contrast">Bookmarks</a></li>
    <li><a href="<%= page:make_url('tag/index') %>" class="contrast">Tags</a></li>
    <li><a href="<%= page:make_url('user/index') %>" class="contrast">Users</a></li>
    <li>
      <details role="list" dir="rtl">
        <summary aria-haspopup="listbox" role="link" class="secondary">ricardogj08</summary>
        <ul role="listbox">
          <li><a>Settings</a></li>
          <li><a href="<%= page:make_url('user/logout') %>">Logout</a></li>
        </ul>
      </details>
    </li>
  </ul>
</nav>
<main class="container">
  {{content}}
</main>
<% page:include('views/components/footer') %>
